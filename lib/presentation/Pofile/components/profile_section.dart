import 'package:flutter/material.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/widgets/typography.dart';


class ProfileSection extends StatelessWidget {
  const ProfileSection({
    Key? key,
    required this.icon,
    required this.label,
    required this.placeholder,
    this.labelSize=15,
    this.placeholderSize=14}) : super(key: key);

  final IconData icon;
  final String label;
  final String placeholder;
  final double labelSize;
  final double placeholderSize;

  @override
  Widget build(BuildContext context) {
    var dimension=Dimensions(context: context);
    return Container(
      margin: EdgeInsets.only(top: dimension.verticalPadding20,),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          SizedBox(width: dimension.sizedBoxWidth15,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StudlyTypography(text: label,fontSize: labelSize,fontWeight: FontWeight.bold,),
                SizedBox(height: dimension.sizedBox10,),
                StudlyTypography(
                  text: placeholder,
                  textOverflow: TextOverflow.visible,
                  maxLines: null,
                  fontSize: placeholderSize,
                  fontWeight: FontWeight.normal,)
              ],
            ),
          )
        ],
      ),
    );
  }
}
