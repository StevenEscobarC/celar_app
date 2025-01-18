// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:celar_app/utils/values.dart';
import 'package:image_picker/image_picker.dart';
import 'package:celar_app/utils/colors_util.dart';
import 'package:celar_app/utils/responsive_util.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Página de inicio de sesión.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscured = true;

  ValueNotifier<String?> svg = ValueNotifier<String?>(null);

  ValueNotifier<ByteData?> rawImage = ValueNotifier<ByteData?>(null);

  ValueNotifier<ByteData?> rawImageFit = ValueNotifier<ByteData?>(null);

  late SharedPreferences prefs;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(context),
    );
  }

  /// Método para tomar una foto.
  Future<void> _takePhoto() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  /// Método para realizar el login.
  Future<void> _login() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes añadir una foto'),
        ),
      );
    }

    if (formKey.currentState!.validate()) {
      var request =
          http.MultipartRequest('POST', Uri.parse('${Values.baseUrl}/login'));
      request.fields.addAll({
        'username': cedulaController.text,
        'password': passwordController.text
      });
      request.files.add(_imageFile != null
          ? http.MultipartFile.fromBytes(
              'image',
              _imageFile!.readAsBytesSync(),
              filename: _imageFile!.path.split('/').last,
            )
          : http.MultipartFile.fromBytes('image', Uint8List(0)));
      http.StreamedResponse streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      var body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        prefs = await SharedPreferences.getInstance();
        prefs.setString('cedula', cedulaController.text);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${body['error']}'),
          ),
        );
      }
    }
  }

  Stack body(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: ResponsiveUtil.hp(100, context),
          width: ResponsiveUtil.wp(100, context),
          color: Colors.white,
        ),
        SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: ResponsiveUtil.wp(80, context),
              child: Column(
                children: [
                  SizedBox(
                    height: ResponsiveUtil.hp(5, context),
                  ),
                  SizedBox(
                    height: ResponsiveUtil.hp(20, context),
                    width: ResponsiveUtil.wp(100, context),
                    child: Image.asset('assets/images/indeseg.png'),
                  ),
                  SizedBox(
                    height: ResponsiveUtil.hp(3, context),
                  ),
                  Text(
                    'INICIAR SESIÓN',
                    style: TextStyle(
                      fontSize: ResponsiveUtil.px(50),
                      color: ColorsUtil.defaultIndesegColorPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('CÉDULA :',
                                style: TextStyle(
                                    fontSize: ResponsiveUtil.px(30),
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(
                          height: ResponsiveUtil.hp(2, context),
                        ),
                        TextFormField(
                          controller: cedulaController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            fillColor: Colors.grey,
                            filled: true,
                          ),
                          style: const TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'La cédula es requerida';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: ResponsiveUtil.hp(2, context),
                        ),
                        Row(
                          children: [
                            Text('CONTRASEÑA:',
                                style: TextStyle(
                                    fontSize: ResponsiveUtil.px(30),
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(
                          height: ResponsiveUtil.hp(2, context),
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _isObscured,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            fillColor: Colors.grey,
                            filled: true,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscured
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscured = !_isObscured;
                                });
                              },
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'La contraseña es requerida';
                            }
                            return null;
                          },
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _imageFile != null
                                ? Image.file(
                                    _imageFile!,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    Icons.camera_alt,
                                    size: 100,
                                    color: Colors.grey[300],
                                  ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.camera),
                              label: const Text("Tomar Foto"),
                              onPressed: _takePhoto,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrangeAccent,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                        SizedBox(
                          height: ResponsiveUtil.hp(5, context),
                        ),
                        SizedBox(
                          height: ResponsiveUtil.hp(7, context),
                          width: ResponsiveUtil.wp(60, context),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  ColorsUtil.defaultIndesegColorPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              _login();
                            },
                            child: Text(
                              'INGRESAR',
                              style: TextStyle(
                                  fontSize: ResponsiveUtil.px(40),
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveUtil.hp(5, context),
                        ),
                        Text(
                          'Desarrollado por indeseg',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ResponsiveUtil.px(30),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
