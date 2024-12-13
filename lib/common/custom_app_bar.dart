import 'package:celar_app/utils/responsive_util.dart';
import 'package:flutter/material.dart';
import 'package:celar_app/utils/colors_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
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
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(ResponsiveUtil.px(350));
}

class _CustomAppBarState extends State<CustomAppBar> {
  String cedula = '';

  @override
  void initState() {
    super.initState();
    _loadCedula();
  }

  Future<void> _loadCedula() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cedula = prefs.getString('cedula') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
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
                    'assets/images/indeseg.png',
                    height: ResponsiveUtil.hp(15, context),
                  ),
                ),
                SizedBox(height: ResponsiveUtil.hp(2, context)),
                SizedBox(
                  width: ResponsiveUtil.wp(35, context),
                  child: Image.asset(
                    'assets/images/ayuda.png',
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
                    // backgroundImage: NetworkImage(widget.imageUrl),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        radius: ResponsiveUtil.hp(3, context),
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.edit,
                          size: ResponsiveUtil.px(40),
                          color: ColorsUtil.defaultIndesegColorPrimary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveUtil.hp(5, context)),
                  Text(
                    widget.name,
                    style: TextStyle(
                      color: ColorsUtil.defaultIndesegColorPrimary,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    cedula,
                    style: TextStyle(
                      color: ColorsUtil.defaultIndesegColorPrimary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
