import 'package:flutter/material.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/widgets/widgets.dart';

class IconWithText extends StatelessWidget {
  const IconWithText({Key? key,
    required this.icon,
    required this.label,
    this.iconColor=StudlyColors.backgroundColorGrey,
    this.labelColor=StudlyColors.backgroundColorGrey, this.labelFontSize=13,
  }) : super(key: key);

  final IconData icon;
  final String label;
  final Color iconColor;
  final Color labelColor;
  final double labelFontSize;

  @override
  Widget build(BuildContext context) {
    var dimension=Dimensions(context: context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: dimension.verticalPadding1),
          child: Icon(icon,size: dimension.containerHeight20,color: iconColor,),
        ),
        SizedBox(width: dimension.sizedBoxWidth10,),
        StudlyTypography(
          text: label,
          textOverflow: TextOverflow.visible,
          maxLines: null,
          fontSize: labelFontSize,
          color: labelColor,)
      ],
    );
  }
}
