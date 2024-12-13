// ignore_for_file: use_build_context_synchronously

import 'package:celar_app/common/custom_app_bar.dart';
import 'package:celar_app/models/courses.dart';
import 'package:celar_app/utils/responsive_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MatriculaPage extends StatefulWidget {
  const MatriculaPage({super.key});

  @override
  _MatriculaPageState createState() => _MatriculaPageState();
}

class _MatriculaPageState extends State<MatriculaPage> {
  String cedula = '';
  final TextEditingController codigoController = TextEditingController();
  // final TextEditingController cuotasController = TextEditingController();
  bool autorizaDescuento = false;
  String dropdownValue = 'Correo electrónico';
  int cuotas = 1;
  @override
  void initState() {
    _loadCedula();
    super.initState();
  }

  @override
  void dispose() {
    codigoController.dispose();
    super.dispose();
  }

  Future<void> _loadCedula() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cedula = prefs.getString('cedula') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final CourseData course =
        ModalRoute.of(context)?.settings.arguments as CourseData;
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Tienes una preinscripción en progreso, ingresa el código que te llegó al medio seleccionado (correo electrónico o SMS) para finalizar el proceso. La preinscripción fue realizada por la empresa CELAR LIMITADA, para completar la inscripción indique en la sección "Autorización libranza", el número de cuotas en los cuales desea realizar el pago.',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const Text(
                    'Con el presente escrito manifiesto que he tomado la decisión libre y voluntaria de AUTORIZAR a la empresa CELAR LIMITADA con NIT 800169799, para que me descuente por nómina por el concepto de préstamo el valor correspondiente de \$0 para el pago del curso a preinscribir. Así mismo, manifiesto que si a la terminación del contrato de trabajo existen saldos por concepto del presente descuento, autorizo a que esos saldos sean descontados de mi liquidación.',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Curso: ${course.courseName}',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  // Campo de texto para Código con botón de Reenviar
                  const Text(
                    'Validar a través de',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Row(
                    children: [
                      // box para seleccionar el medio de validación
                      DropdownButton<String>(
                        value: dropdownValue,
                        dropdownColor: Colors.blueGrey,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;                          
                          });
                        },
                        items: <String>['Correo electrónico', 'SMS']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                  color: Colors
                                      .white), // Cambia el color del texto
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(width: 38),
                      ElevatedButton(
                        onPressed: () async {
                          var headers = {
                            'Content-Type': 'application/json',
                            'Cookie':
                                'frontend_lang=es_CO; session_id=8526f38b3effa2671a33290c13357b49ab87fbc4'
                          };
                          var request = http.Request(
                              'POST',
                              Uri.parse(
                                  'https://indeseg.edu.co/app/v1/course/validate/resend_code'));
                          request.body = json.encode({
                            "token":
                                "ueJwwRZYqi72GMCZRPhfPTTVk0okeDRFS6H3sb5Dcc6SL8aQzSUi3GakVjbdxDGV",
                            "ref_student": cedula,
                            "course_id": course.courseId,
                            "canal": dropdownValue == 'Correo electrónico'
                              ? 'email'
                              : 'sms'
                          });
                          request.headers.addAll(headers);

                          http.StreamedResponse response = await request.send();

                          if (response.statusCode == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Código reenviado exitosamente!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Error al reenviar el código. Código de error: ${response.statusCode}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text('Reenviar código'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: codigoController,
                    decoration: const InputDecoration(
                      labelText: 'Código',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  // Campo numérico para Número de cuotas
                  const Text(
                    'Autorización libranza',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  // dropdown para seleccionar el número de cuotas de 1 a 6
                  DropdownButton<int>(
                    value: cuotas,
                    dropdownColor: Colors.blueGrey,
                    onChanged: (int? newValue) {
                      setState(() {
                        cuotas = newValue!;
                      });
                    },
                    items: <int>[1, 2, 3, 4, 5, 6]
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          value.toString(),
                          style: const TextStyle(
                              color: Colors
                                  .white), // Cambia el color del texto
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),
                  // Checkbox para Autoriza el descuento de nómina
                  Row(
                    children: [
                      Checkbox(
                        value: autorizaDescuento,
                        onChanged: (value) {
                          setState(() {
                            autorizaDescuento = value ?? false;
                          });
                        },
                      ),
                      SizedBox(
                        width: ResponsiveUtil.wp(70, context),
                        child: const Text(
                          '¿Acepto las condiciones establecidas en la libranza?',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      var headers = {
                        'Content-Type': 'application/json',
                        'Cookie':
                            'frontend_lang=es_CO; session_id=8526f38b3effa2671a33290c13357b49ab87fbc4'
                      };
                      var request = http.Request(
                          'POST',
                          Uri.parse(
                              'https://indeseg.edu.co/app/v1/course/validate'));
                      request.body = json.encode({
                        "token":
                            "ueJwwRZYqi72GMCZRPhfPTTVk0okeDRFS6H3sb5Dcc6SL8aQzSUi3GakVjbdxDGV",
                        "ref_student": cedula,
                        "course_id": course.courseId,
                        "otp_code": codigoController.text,
                        "cuotas": cuotas,
                        "auth_deduction": autorizaDescuento
                      });
                      request.headers.addAll(headers);

                      http.StreamedResponse response = await request.send();

                      if (response.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Código reenviado exitosamente!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pushNamed(context, '/courses');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Error al reenviar el código. Código de error: ${response.statusCode}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Text('Matricular'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
