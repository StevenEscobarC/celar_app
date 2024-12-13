import 'dart:io';

import 'package:celar_app/utils/responsive_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CampusPage extends StatefulWidget {
  @override
  _CampusPageState createState() => _CampusPageState();
}

class _CampusPageState extends State<CampusPage> {
  // Future<void> _downloadQRCode() async {
  //   try {
  //     // Verificar y solicitar permisos de almacenamiento
  //     if (Platform.isAndroid) {
  //       var status = await Permission.storage.request();
  //       if (!status.isGranted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Permiso de almacenamiento denegado')),
  //         );
  //         return;
  //       }
  //     }

  //     // Obtener imagen desde los assets
  //     final byteData = await rootBundle.load('assets/images/QR.jpeg');

  //     // Guardar la imagen en el almacenamiento local
  //     final directory = await getApplicationDocumentsDirectory();
  //     final filePath = '${directory.path}/QR.jpeg';
  //     final file = File(filePath);
  //     await file.writeAsBytes(byteData.buffer.asUint8List());

  //     // Mostrar mensaje de éxito
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Imagen descargada: $filePath')),
  //     );
  //   } catch (e) {
  //     // Manejar errores
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error al descargar la imagen: $e')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campus Page'),
      ),
      body: Container(
        width: double.infinity,
        color: Color.fromARGB(255, 18, 44, 131),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              SizedBox(height: ResponsiveUtil.hp(4, context)),
              Container(
                width: ResponsiveUtil.wp(90, context),
                height: ResponsiveUtil.hp(50, context),
                child: FittedBox(
                  child: Image.asset('assets/images/QR.jpeg'),
                ),
              ),
              SizedBox(height: ResponsiveUtil.hp(2, context)),
              const Center(
                child: Text(
                  'Escanea el código QR para acceder a la plataforma',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: ResponsiveUtil.hp(4, context)),
              Center(
                child: ElevatedButton(
                  onPressed: (() async {
                    await _requestPermission(context);
                  }),
                  child: Text('Descargar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    textStyle: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> _downloadQRCode(BuildContext context) async {
  //   // Solicitar permisos de almacenamiento
  //   if (Platform.isAndroid) {
  //     var status = await Permission.storage.request();

  //     if (status.isGranted) {
  //       // Si se otorgan los permisos, guardar la imagen
  //       _saveImage(context);
  //     } else if (status.isDenied) {
  //       // Si el usuario niega el permiso
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //             content:
  //                 Text('Permiso denegado. No se puede guardar la imagen.')),
  //       );
  //     } else if (status.isPermanentlyDenied) {
  //       // Si el usuario niega permanentemente el permiso
  //       openAppSettings(); // Abre la configuración de la aplicación
  //     }
  //   } else {
  //     // Para iOS o plataformas donde no se necesita este permiso
  //     _saveImage(context);
  //   }
  // }

  Future<void> _requestPermission(BuildContext context) async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.request().isGranted) {
        // Permiso concedido
        _saveImage(context);
      } else if (await Permission.manageExternalStorage.isDenied) {
        // Permiso denegado
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Permiso denegado. No se puede guardar la imagen.')),
        );
      } else if (await Permission.manageExternalStorage.isPermanentlyDenied) {
        // Permiso denegado permanentemente
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Permiso denegado permanentemente. Ve a configuración.')),
        );
        openAppSettings(); // Abre la configuración de la aplicación
      }
    } else {
      // iOS no requiere permisos de almacenamiento explícitos
      _saveImage(context);
    }
  }

  Future<void> _saveImage(BuildContext context) async {
    try {
      // Obtener imagen desde los assets
      final byteData = await rootBundle.load('assets/images/QR.jpeg');

      // Guardar la imagen en el almacenamiento local
      final directory = await getExternalStorageDirectory();
      final filePath = '${directory!.path}/QR.jpeg';
      final file = File(filePath);
      await file.writeAsBytes(byteData.buffer.asUint8List());

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Imagen guardada exitosamente en: $filePath')),
      );
    } catch (e) {
      // Manejar errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar la imagen: $e')),
      );
    }
  }
}

  // final campusController = CampusController();
  // List<dynamic> dataCourses = [];
  // List<dynamic> dataCourseContent = [];
  // @override
  // void initState() {
  //   super.initState();
  //   campusController.fetchData(
  //     'a3900d06506414067f463c09ba03b5bc',
  //     'core_enrol_get_users_courses',
  //     {'userid': '115'},
  //   ).then((value) {
  //     setState(() {});
  //     dataCourses = value;
  //   });
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  // appBar: AppBar(
  //   title: Text('Campus Page'),
  // ),
  //     body: ListView.builder(
  //       itemCount: dataCourses.length,
  //       itemBuilder: (context, index) {
  //         return Card(
  //           color: Colors.grey[200],
  //           margin: EdgeInsets.all(8.0),
  //           child: InkWell(
  //             onTap: () async {
  //               dataCourseContent = await campusController.fetchData(
  //                 '2bcf49c1df4fc0b92f07c219973d667f',
  //                 'core_course_get_contents',
  //                 {'courseid': '${dataCourses[index]['id']}'},
  //               );

  //               setState(() {});

  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) =>
  //                       CourseContentPage(courseDataContent: dataCourseContent, index: dataCourses[index]['id']),
  //                 ),
  //               );
  //             },
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Container(
  //                     height: ResponsiveUtil.hp(25, context),
  //                     width: ResponsiveUtil.wp(90, context),
  //                     child: FittedBox(
  //                         fit: BoxFit.fill,
  //                         child: Image.network(
  //                             dataCourses[index]['courseimage']))),
  //                 Text(
  //                   dataCourses[index]['fullname'],
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 SizedBox(height: 8),
  //                 Center(
  //                   child: Text(
  //                     "${dataCourses[index]['progress']}% completado",
  //                     style: TextStyle(fontSize: 14),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
// }
