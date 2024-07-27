import 'package:celar_app/utils/colors_util.dart';
import 'package:celar_app/utils/responsive_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveUtil.hp(100, context),
      width: ResponsiveUtil.wp(100, context),
      child: Stack(children: [
        Container(
          height: ResponsiveUtil.hp(100, context),
          width: ResponsiveUtil.wp(100, context),
          color: Colors.black,
        ),
        Column(
          children: [
            SizedBox(
              height: ResponsiveUtil.hp(10, context),
            ),
            SizedBox(
              height: ResponsiveUtil.hp(20, context),
              width: ResponsiveUtil.wp(100, context),
              child: Center(
                child: Text(
                  'Control app',
                  style: TextStyle(
                      fontSize: ResponsiveUtil.px(70),
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: ResponsiveUtil.hp(30, context),
              width: ResponsiveUtil.wp(100, context),
              child: Center(
                child: Image.asset('assets/images/logoCelar.png'),
              ),
            ),
            SizedBox(
              height: ResponsiveUtil.hp(5, context),
            ),
            SizedBox(
              height: ResponsiveUtil.hp(35, context),
              width: ResponsiveUtil.wp(100, context),
              child: Column(
                children: [
                  SizedBox(
                    height: ResponsiveUtil.hp(7, context),
                    width: ResponsiveUtil.wp(50, context),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsUtil.defaultCelarColorPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        'INGRESAR',
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
                  SizedBox(
                    height: ResponsiveUtil.hp(7, context),
                    width: ResponsiveUtil.wp(50, context),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsUtil.defaultCelarColorPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
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
      ]),
    );
  }
}
