import 'package:celar_app/campus/campus_page.dart';
import 'package:celar_app/common/custom_app_bar.dart';
import 'package:celar_app/utils/responsive_util.dart';
import 'package:flutter/material.dart';
import 'package:celar_app/utils/colors_util.dart';

/// Página principal de la aplicación.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        name: '',
        id: '',
        imageUrl: '',
      ),
      body: Container(
        color: Color.fromARGB(255, 18, 44, 131),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: ResponsiveUtil.hp(2, context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildImageButton('assets/images/logo1.png', 'MATRÍCULA', () {
                    Navigator.pushNamed(context, '/courses');
                  }),
                  _buildImageButton('assets/images/logo2.png', 'CAMPUS', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CampusPage(),
                      ),
                    );
                  }),
                  _buildImageButton('assets/images/logo3.png', 'CERTIFICADO', () {
                    Navigator.pushNamed(context, '/generate-register');
                  }),
                ],
              ),
              SizedBox(height: ResponsiveUtil.hp(2, context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildImageButton('assets/images/logo4.jpg', 'EVALUACIÓN', () {}),
                  _buildImageButton(
                      'assets/images/logo5.png', 'RENOVAR INSCRIPICIÓN', () {}),
                  _buildImageButton(
                      'assets/images/logo6.jpg', 'PROGRAMA TU PRESENCIALIDAD', () {}),
                ],
              ),
              SizedBox(height: ResponsiveUtil.hp(2, context)),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsUtil.defaultIndesegColorPrimary,
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
                  style: TextStyle(
                    fontSize: ResponsiveUtil.px(30),
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: ResponsiveUtil.hp(3, context)),
              const Text('Desarrollado por Indeseg LDTA',
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  /// Método para construir los botones del home.
  Widget _buildImageButton(
      String imagePath, String label, void Function()? onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: ResponsiveUtil.hp(6, context),
            backgroundColor: ColorsUtil.defaultIndesegColorPrimary,
            child: ClipOval(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: ResponsiveUtil.hp(8, context), // Tamaño uniforme
                height: ResponsiveUtil.hp(8, context), // Tamaño uniforme
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: ResponsiveUtil.hp(5, context),
          width: ResponsiveUtil.wp(30, context),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveUtil.px(20),
            ),
          ),
        ),
      ],
    );
  }
}
