import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_attendance/config/config.dart';

class StudlyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StudlyAppBar({
    Key? key,
    required this.title,
    this.leadingLabel='.',
    this.leadingLabelSize=25,
    this.icon,
    this.onPressed,
    this.actions}) : super(key: key);

  final String title;
  final String leadingLabel;
  final double leadingLabelSize;
  final IconData? icon;
  final void Function()? onPressed;
  final List<Widget>? actions;


  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    var dimension = Dimensions(context: context);
    return AppBar(
      elevation: 0,
      backgroundColor: StudlyColors.backgroundColor,
      automaticallyImplyLeading: true,
      toolbarHeight: dimension.toolbarHeight65,
      centerTitle: true,
      leading: Padding(
        padding: EdgeInsets.only(left: dimension.horizontalPadding10,
            top: dimension.verticalPadding10),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: dimension.font24,
            color: StudlyColors.iconColorBlack,),
        ),
      ),

      title: Padding(
        padding: EdgeInsets.only(top: dimension.verticalPadding10),
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
                text: title,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontSize: dimension.font19,
                        fontWeight: FontWeight.w500,
                        color: StudlyColors.typographyDefaultColor))),

            TextSpan(
                text: leadingLabel,
                style: TextStyle(fontSize: leadingLabelSize,
                    color: StudlyColors.backgroundColorBlueAccent))
          ]),
        ),
      ),
      actions: actions

    );
  }

}