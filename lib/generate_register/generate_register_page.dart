import 'dart:convert';
import 'dart:io';
import 'package:celar_app/common/custom_app_bar.dart';
import 'package:celar_app/courses/courses_controller.dart';
import 'package:celar_app/models/courses.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GenerateRegisterPage extends StatefulWidget {
  const GenerateRegisterPage({super.key});

  @override
  _GenerateRegisterPageState createState() => _GenerateRegisterPageState();
}

class _GenerateRegisterPageState extends State<GenerateRegisterPage> {
  CoursesController coursesController = CoursesController();
  List<CourseData> courses = [];
  late SharedPreferences prefs;
  @override
  void initState() {
    fecthLista();
    super.initState();
  }

  Future<List<CourseData>> fecthLista() async {
    courses = await coursesController.list();
    return courses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        name: '',
        id: '',
        imageUrl: '',
      ),
      body: Container(
        color: const Color.fromARGB(255, 18, 44, 131),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FutureBuilder<List<CourseData>>(
                    future:
                        fecthLista(), // Llama a la función que obtiene los datos
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Muestra un indicador de carga mientras se obtienen los datos
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        // Maneja posibles errores
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        // Si no hay datos o la lista está vacía
                        return const Center(
                            child: Text("No hay cursos disponibles"));
                      } else {
                        // Cuando los datos están disponibles, construye la lista
                        final courses = snapshot.data!;
                        return ListView.builder(
                          itemCount: courses.length,
                          itemBuilder: (context, index) {
                            final course = courses[index];
                            return Card(
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                title: Text(course.courseName),
                                subtitle: Text("ID: ${course.courseId}"),
                                trailing: ElevatedButton(
                                  onPressed: course.state == 'certified'
                                      ? () async {
                                          prefs = await SharedPreferences
                                              .getInstance();
                                          String base64Pdf =
                                              await fetchCertificateBase64(
                                                  prefs.getString('cedula') ??
                                                      '');
                                          await saveCertificate(
                                              base64Pdf, "${course.name}.pdf");
                                        }
                                      : null, // Deshabilita el botón si no hay PDF
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepOrangeAccent,
                                  ),
                                  child: const Text("Descargar PDF"),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Simulación de función para obtener el certificado en base64 (debería reemplazarse con una llamada HTTP real)
  Future<String> fetchCertificateBase64(String id) async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie':
          'frontend_lang=es_CO; session_id=8526f38b3effa2671a33290c13357b49ab87fbc4'
    };
    var request = http.Request(
        'POST', Uri.parse('http://142.93.61.115:8069/app/v1/courses'));
    request.body = json.encode({
      "token":
          "ueJwwRZYqi72GMCZRPhfPTTVk0okeDRFS6H3sb5Dcc6SL8aQzSUi3GakVjbdxDGY",
      "ref_student": id,
      "pdf_download": true,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = json.decode(await response.stream.bytesToString());
      return (data['data'][0]['pdf_certificate']);
    } else {
      print(response.reasonPhrase);
      return '';
    }
  }

  Future<void> saveCertificate(
      String base64Pdf, String filename) async {
    var status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      try {
        List<int> bytes = base64Decode(base64Pdf);
        final directory = Directory('/storage/emulated/0/Download');

        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }

        final file = File("${directory.path}/$filename");
        await file.writeAsBytes(bytes);

        // Mostrar un diálogo de éxito
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Éxito"),
              content: Text("Certificado guardado en: ${file.path}"),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        // Manejar errores con un mensaje visual
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content:
                  Text("No se pudo guardar el certificado. Intenta de nuevo."),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else if (status.isPermanentlyDenied) {
      // Solicitar al usuario que habilite el permiso manualmente
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Permiso necesario"),
            content: Text(
                "El permiso de almacenamiento es necesario para guardar el certificado. Por favor habilítalo en la configuración."),
            actions: [
              TextButton(
                child: Text("Abrir configuración"),
                onPressed: () {
                  openAppSettings();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Notificar si el permiso fue denegado temporalmente
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Permiso de almacenamiento denegado. No se puede guardar el certificado."),
        ),
      );
    }
  }
}
