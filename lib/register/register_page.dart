import 'dart:typed_data';

import 'package:celar_app/utils/colors_util.dart';
import 'package:celar_app/utils/responsive_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hand_signature/signature.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  HandSignatureControl control = HandSignatureControl(
    threshold: 0.01,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );

  ValueNotifier<String?> svg = ValueNotifier<String?>(null);

  ValueNotifier<ByteData?> rawImage = ValueNotifier<ByteData?>(null);

  ValueNotifier<ByteData?> rawImageFit = ValueNotifier<ByteData?>(null);

  bool isChecked = false;
  bool isDrawing = false; // Add a flag to check if drawing is active
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(context),
    );
  }

  Stack body(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: ResponsiveUtil.hp(100, context),
          width: ResponsiveUtil.wp(100, context),
          color: Colors.black,
        ),
        Center(
          child: SizedBox(
            width: ResponsiveUtil.wp(80, context),
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                if (isDrawing) {
                  overscroll.disallowGlow();
                }
                return false;
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: isDrawing
                    ? NeverScrollableScrollPhysics()
                    : AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: ResponsiveUtil.hp(10, context),
                    ),
                    SizedBox(
                      height: ResponsiveUtil.hp(20, context),
                      width: ResponsiveUtil.wp(100, context),
                      child: Image.asset('assets/images/logoCelar.png'),
                    ),
                    SizedBox(
                      height: ResponsiveUtil.hp(5, context),
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
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(
                            height: ResponsiveUtil.hp(2, context),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(60),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(60),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            style: TextStyle(color: Colors.black),
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
                              Text('FIRMA :',
                                  style: TextStyle(
                                      fontSize: ResponsiveUtil.px(30),
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(
                            height: ResponsiveUtil.hp(2, context),
                          ),
                          GestureDetector(
                            onPanStart: (_) {
                              setState(() {
                                isDrawing = true;
                              });
                            },
                            onPanEnd: (_) {
                              setState(() {
                                isDrawing = false;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white),
                              height: ResponsiveUtil.hp(15, context),
                              width: ResponsiveUtil.wp(100, context),
                              child: HandSignature(
                                control: control,
                                type: SignatureDrawType.shape,
                              ),
                            ),
                          ),
                          CustomPaint(
                            painter: DebugSignaturePainterCP(
                              control: control,
                              cp: false,
                              cpStart: false,
                              cpEnd: false,
                            ),
                          ),
                          SizedBox(
                            width: ResponsiveUtil.wp(60, context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        ColorsUtil.defaultCelarColorPrimary,
                                  ),
                                  onPressed: () {
                                    control.clear();
                                    svg.value = null;
                                    rawImage.value = null;
                                    rawImageFit.value = null;
                                  },
                                  child: Text('Limpiar'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    svg.value = control.toSvg(
                                      color: Colors.blueGrey,
                                      type: SignatureDrawType.shape,
                                      fit: true,
                                    );

                                    rawImage.value = await control.toImage(
                                      color: Colors.blueAccent,
                                      background: Colors.greenAccent,
                                      fit: false,
                                    );

                                    rawImageFit.value = await control.toImage(
                                      color: Colors.black,
                                      //background: Colors.greenAccent,
                                      fit: true,
                                    );
                                  },
                                  child: Text('Exportar'),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveUtil.hp(2, context),
                          ),
                          Row(
                            children: [
                              Text(
                                'MÉTODO DE APAGADO:',
                                style: TextStyle(
                                    fontSize: ResponsiveUtil.px(30),
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                activeColor:
                                    ColorsUtil.defaultCelarColorPrimary,
                                side: BorderSide(color: Colors.white),
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                },
                              ),
                              Text(
                                'Huella',
                                style: TextStyle(
                                    fontSize: ResponsiveUtil.px(30),
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Checkbox(
                                checkColor: Colors.white,
                                activeColor:
                                    ColorsUtil.defaultCelarColorPrimary,
                                side: BorderSide(color: Colors.white),
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                },
                              ),
                              Text(
                                'Cámara',
                                style: TextStyle(
                                    fontSize: ResponsiveUtil.px(30),
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                activeColor:
                                    ColorsUtil.defaultCelarColorPrimary,
                                side: BorderSide(color: Colors.white),
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                },
                              ),
                              SizedBox(
                                width: ResponsiveUtil.wp(50, context),
                                child: Text(
                                  'Acepto los términos y condiciones de la política de protección de datos y uso del sistema',
                                  style: TextStyle(
                                      fontSize: ResponsiveUtil.px(25),
                                      color: Colors.white,
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
                            width: ResponsiveUtil.wp(50, context),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    ColorsUtil.defaultCelarColorPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/home');
                              },
                              child: Text(
                                'REGISTRAR',
                                style: TextStyle(
                                    fontSize: ResponsiveUtil.px(50),
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
                              color: Colors.white,
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
