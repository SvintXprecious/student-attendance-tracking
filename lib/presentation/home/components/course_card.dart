import 'package:flutter/material.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/state/module/model/module.dart';
import 'package:student_attendance/widgets/widgets.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({Key? key,required this.module}) : super(key: key);
  final Module module;

  @override
  Widget build(BuildContext context) {
    var dimension=Dimensions(context: context);
    return Container(
      margin:EdgeInsets.only(right: dimension.horizontalPadding20),
      height:dimension.containerHeight250,
      width: dimension.containerWidth190,
      decoration: BoxDecoration(
          color: StudlyColors.backgroundColorBlueAccent,
          borderRadius: BorderRadius.circular(30)),
      child: Stack(children: [
        Positioned(
            bottom: dimension.verticalPadding120,
            left: dimension.horizontalPadding10,
            right: dimension.horizontalPadding10,
            child: StudlyTypography(
              text: module.name,
              textOverflow: TextOverflow.visible,
              maxLines: null,
              color: StudlyColors.typographyWhite,)),
        Positioned(
            bottom: dimension.verticalPadding80,
            left: dimension.horizontalPadding10,
            right: dimension.horizontalPadding10,
            child: StudlyTypography(
              text: module.code,
              textOverflow: TextOverflow.visible,
              maxLines: null,
              color: StudlyColors.typographyWhite,))
      ],),
    );
  }
}
