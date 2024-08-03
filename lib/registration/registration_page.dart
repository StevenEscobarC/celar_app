import 'package:celar_app/common/custom_app_bar.dart';
import 'package:celar_app/utils/responsive_util.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
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
              SizedBox(height: ResponsiveUtil.hp(20, context)),
              const Text(
                'Sin registros pendientes',
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: ResponsiveUtil.hp(20, context)),
              ElevatedButton(
                onPressed: () {},
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
                  'Cerrar Sesión',
                  style: TextStyle(fontSize: ResponsiveUtil.px(30)),
                ),
              ),
              SizedBox(height: ResponsiveUtil.hp(3, context)),
              const Text('Desarrollado por indeseq'),
            ],
          ),
        ),
      ),
    );
  }
}
