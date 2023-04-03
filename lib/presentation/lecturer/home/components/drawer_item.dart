import 'package:flutter/material.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/widgets/widgets.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({Key? key, required this.name, required this.icon, required this.onPressed}) : super(key: key);

  final String name;
  final IconData icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    var dimension=Dimensions(context: context);
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        height: dimension.sizedBox40,
        child: Row(
          children: [
            Icon(icon, size: dimension.containerHeight20, color: StudlyColors.backgroundColor),
            SizedBox(width: dimension.sizedBoxWidth40,),
            StudlyTypography(text: name, fontSize: dimension.font13,color: StudlyColors.backgroundColor,)
          ],
        ),
      ),
    );
  }
}