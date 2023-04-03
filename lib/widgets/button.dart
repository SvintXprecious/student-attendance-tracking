import 'package:flutter/material.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/widgets/widgets.dart';

class StudlyButton extends StatelessWidget {
  StudlyButton({
    Key? key,
    required this.label,
    required this.onPressed,
    }) : super(key: key);
  final String label;
  void Function()? onPressed;


  @override
  Widget build(BuildContext context) {
    var dimension=Dimensions(context: context);
    return Container(
        height: dimension.containerHeight55,
        margin: EdgeInsets.only(
            bottom: dimension.verticalPadding40,
            left: dimension.horizontalPadding20,
            right: dimension.horizontalPadding20),
        child: ElevatedButton(
          onPressed:onPressed,
          style:ElevatedButton.styleFrom(
            backgroundColor: StudlyColors.backgroundColorBlueAccent,
            shape: const StadiumBorder(),
          ), child: Center(
            child: StudlyTypography(
              text: label,
              fontSize: dimension.font17,
              color: StudlyColors.typographyWhite,)) ,)
    );
  }
}
