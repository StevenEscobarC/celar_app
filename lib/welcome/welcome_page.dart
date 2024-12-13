import 'package:celar_app/utils/colors_util.dart';
import 'package:celar_app/utils/responsive_util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late SharedPreferences prefs;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveUtil.hp(100, context),
      width: ResponsiveUtil.wp(100, context),
      child: Stack(children: [
        Container(
          height: ResponsiveUtil.hp(100, context),
          width: ResponsiveUtil.wp(100, context),
          color: Colors.white,
        ),
        Column(
          children: [
            SizedBox(
              height: ResponsiveUtil.hp(10, context),
            ),
            SizedBox(
              height: ResponsiveUtil.hp(30, context),
              width: ResponsiveUtil.wp(100, context),
              child: Center(
                child: Image.asset('assets/images/indeseg.png'),
              ),
            ),
            SizedBox(
              height: ResponsiveUtil.hp(25, context),
            ),
            SizedBox(
              height: ResponsiveUtil.hp(35, context),
              width: ResponsiveUtil.wp(100, context),
              child: Column(
                children: [
                  SizedBox(
                    height: ResponsiveUtil.hp(7, context),
                    width: ResponsiveUtil.wp(60, context),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsUtil.defaultIndesegColorPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
                        // prefs = await SharedPreferences.getInstance();
                        // prefs.setString('cedula', "72041474");
                        // Navigator.pushNamed(context, '/home');
                        Navigator.pushNamed(context, '/login');
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
                  SizedBox(
                    height: ResponsiveUtil.hp(7, context),
                    width: ResponsiveUtil.wp(60, context),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsUtil.defaultIndesegColorPrimary,
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
                    'Desarrollado por Indeseg LDTA',
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
      ]),
    );
  }
}
