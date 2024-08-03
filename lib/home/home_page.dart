import 'package:celar_app/common/custom_app_bar.dart';
import 'package:celar_app/utils/responsive_util.dart';
import 'package:flutter/material.dart';

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
        name: 'Pepito Perez',
        id: '12345678',
        imageUrl:
            'https://caracol.com.co/resizer/v2/DL2VAS7H3RBVBK6R5PGRJBWSBQ.jpg?auth=aa8931566e7863085856b3febcca0b54915ec46705ba33b4a8ccba6d5d1161aa&width=650&height=488&quality=70&smart=true', // Reemplaza con la URL de la imagen correcta
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: ResponsiveUtil.hp(5, context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconButton(Icons.calendar_today, 'PROGRAMACIÓN', () {
                  Navigator.pushNamed(context, '/generate-register');
                }),
                _buildIconButton(Icons.report, 'REPORTE', () {
                  Navigator.pushNamed(context, '/report');
                }),
                _buildIconButton(Icons.receipt, 'DESPRENDIBLE', () {
                  Navigator.pushNamed(context, '/registration-list');
                }),
              ],
            ),
            SizedBox(height: ResponsiveUtil.hp(5, context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconButton(
                    Icons.assignment, 'AUTORIZAR DESCUENTO', () {}),
                _buildIconButton(Icons.warning, 'NOVEDAD', () {}),
              ],
            ),
            SizedBox(height: ResponsiveUtil.hp(5, context)),
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
    );
  }

  Widget _buildIconButton(IconData icon, String label, void Function()? onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: ResponsiveUtil.hp(6, context),
            backgroundColor: Colors.deepOrangeAccent,
            child:
                Icon(icon, size: ResponsiveUtil.px(100), color: Colors.white),
          ),
        ),
        SizedBox(height: 8),
        Text(label, textAlign: TextAlign.center),
      ],
    );
  }
}
