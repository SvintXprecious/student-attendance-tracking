import 'package:flutter/material.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/widgets/widgets.dart';

class StatisticsCard extends StatelessWidget {
  const StatisticsCard({
    Key? key,
    required this.label,
    required this.value,
    required this.backgroundColor,
    required this.width,
    required this.height,
    this.borderRadius=30,
  }) : super(key: key);


  final String label;
  final String value;
  final Color backgroundColor;
  final double width;
  final double height;

  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    var dimension=Dimensions(context: context);
    return Container(
      width:width,
      height:height,
      decoration: BoxDecoration(
        color:backgroundColor  ,
        borderRadius:BorderRadius.circular(borderRadius),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: dimension.verticalPadding20),
            child: StudlyTypography(text: label),
          ),
          SizedBox(height: dimension.sizedBox10,),
          Center(child: StudlyTypography(
            text: value,
            fontSize: dimension.font36,))

        ],
      ),
    );
  }
}
