// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:celar_app/utils/colors_util.dart';
import 'package:celar_app/utils/values.dart';
import 'package:celar_app/utils/responsive_util.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hand_signature/signature.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController cedulaController = TextEditingController();
  HandSignatureControl control = HandSignatureControl(
    threshold: 0.01,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );

  late SharedPreferences prefs;
  ValueNotifier<String?> svg = ValueNotifier<String?>(null);

  ValueNotifier<ByteData?> rawImage = ValueNotifier<ByteData?>(null);

  ValueNotifier<ByteData?> rawImageFit = ValueNotifier<ByteData?>(null);

  bool isChecked = false;
  bool isDrawing = false;
  final ScrollController _scrollController = ScrollController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(context),
    );
  }

  Future<void> _takePhoto() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadPhoto() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes añadir una foto'),
        ),
      );
    }

    if (formKey.currentState!.validate()) {
      if (isChecked) {
        var request = http.MultipartRequest('POST',
            Uri.parse('${Values.baseUrl}/register'));
        request.fields.addAll({
          'username': cedulaController.text,
          'password': cedulaController.text
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
          // guardar la cedula en el storage
          prefs = await SharedPreferences.getInstance();
          prefs.setString('cedula', cedulaController.text);
          Navigator.pushNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(body['error'] ?? 'Error desconocido'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Debes aceptar los términos y condiciones'),
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
        Center(
          child: SizedBox(
            width: ResponsiveUtil.wp(100, context),
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                if (isDrawing) {
                  // overscroll.disallowGlow();
                }
                return false;
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: isDrawing
                    ? const NeverScrollableScrollPhysics()
                    : const AlwaysScrollableScrollPhysics(),
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
                      height: ResponsiveUtil.hp(5, context),
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            width: ResponsiveUtil.wp(70, context),
                            child: Row(
                              children: [
                                Text('CÉDULA :',
                                    style: TextStyle(
                                        fontSize: ResponsiveUtil.px(30),
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveUtil.hp(2, context),
                          ),
                          SizedBox(
                            width: ResponsiveUtil.wp(70, context),
                            child: TextFormField(
                              controller: cedulaController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
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
                          ),
                          SizedBox(
                            height: ResponsiveUtil.hp(2, context),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _imageFile != null
                                  ? Image.file(
                                      _imageFile!,
                                      height: 200,
                                      width: 200,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(
                                      Icons.camera_alt,
                                      size: 200,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: ResponsiveUtil.wp(20, context),
                                child: Checkbox(
                                  checkColor: Colors.black,
                                  activeColor:
                                      ColorsUtil.defaultIndesegColorPrimary,
                                  side: const BorderSide(color: Colors.black),
                                  value: isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: ResponsiveUtil.wp(75, context),
                                child: Text(
                                  'Acepto los términos y condiciones de la política de protección de datos y uso del sistema',
                                  style: TextStyle(
                                      fontSize: ResponsiveUtil.px(25),
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
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
                                _uploadPhoto();
                              },
                              child: Text(
                                'REGISTRAR',
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
          ),
        )
      ],
    );
  }
}
