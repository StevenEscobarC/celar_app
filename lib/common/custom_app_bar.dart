import 'package:celar_app/utils/responsive_util.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String id;
  final String imageUrl;

  const CustomAppBar({
    Key? key,
    required this.name,
    required this.id,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      flexibleSpace: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: ResponsiveUtil.wp(35, context),
                  child: Image.asset(
                    'assets/images/logoCelar.png', // Reemplaza esto con la ruta correcta de tu logo
                    height: ResponsiveUtil.hp(15, context),
                  ),
                ),
                SizedBox(height: ResponsiveUtil.hp(2, context)),
                SizedBox(
                  width: ResponsiveUtil.wp(35, context),
                  child: Image.asset(
                    'assets/images/alerta.png', // Reemplaza esto con la ruta correcta de tu logo
                    height: ResponsiveUtil.hp(8, context),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: ResponsiveUtil.hp(2, context)),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: ResponsiveUtil.hp(8, context),
                    backgroundImage: NetworkImage(imageUrl),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        radius: ResponsiveUtil.hp(3, context),
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.edit,
                          size: ResponsiveUtil.px(40),
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveUtil.hp(5, context)),
                  Text(
                    name,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    id,
                    style:
                        TextStyle(color: Colors.deepOrangeAccent, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(ResponsiveUtil.px(350));
}
