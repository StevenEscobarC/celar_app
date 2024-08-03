import 'package:celar_app/common/custom_app_bar.dart';
import 'package:celar_app/utils/responsive_util.dart';
import 'package:flutter/material.dart';

class GenerateRegisterPage extends StatefulWidget {
  const GenerateRegisterPage({super.key});

  @override
  _GenerateRegisterPageState createState() => _GenerateRegisterPageState();
}

class _GenerateRegisterPageState extends State<GenerateRegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        name: 'Pepito Perez',
        id: '12345678',
        imageUrl:
            'https://caracol.com.co/resizer/v2/DL2VAS7H3RBVBK6R5PGRJBWSBQ.jpg?auth=aa8931566e7863085856b3febcca0b54915ec46705ba33b4a8ccba6d5d1161aa&width=650&height=488&quality=70&smart=true', // Reemplaza con la URL de la imagen correcta
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/escudo.png',
                height: ResponsiveUtil.hp(25, context),
              ),
              const Text(
                'Estás intentando generar el registro de control',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: ResponsiveUtil.hp(5, context)),
              Column(
                children: [
                  customButton('Reportar', () {}),
                  SizedBox(height: ResponsiveUtil.hp(1, context)),
                  customButton('Emergencia', () {}),
                ],
              ),
              SizedBox(height: ResponsiveUtil.hp(3, context)),
              const Text('Desarrollado por indeseq'),
            ],
          ),
        ),
      ),
    );
  }

  Widget customButton(String text, Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrangeAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.only(
          left: ResponsiveUtil.wp(5, context),
          right: ResponsiveUtil.wp(5, context),
          top: ResponsiveUtil.hp(2, context),
          bottom: ResponsiveUtil.hp(2, context),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: ResponsiveUtil.px(30)),
      ),
    );
  }
}
