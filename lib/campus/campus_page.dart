import 'dart:io';

import 'package:celar_app/utils/responsive_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// Página principal del campus que muestra un código QR para acceder a la plataforma.
class CampusPage extends StatefulWidget {
  @override
  _CampusPageState createState() => _CampusPageState();
}

class _CampusPageState extends State<CampusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Page'),
      ),
      body: Container(
        width: double.infinity,
        color: const Color.fromARGB(255, 18, 44, 131),
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
                  child: const Text('Descargar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    textStyle: const TextStyle(
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

  Future<void> _requestPermission(BuildContext context) async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.request().isGranted) {
        // Permiso concedido
        _saveImage(context);
      } else if (await Permission.manageExternalStorage.isDenied) {
        // Permiso denegado
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Permiso denegado. No se puede guardar la imagen.')),
        );
      } else if (await Permission.manageExternalStorage.isPermanentlyDenied) {
        // Permiso denegado permanentemente
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
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
