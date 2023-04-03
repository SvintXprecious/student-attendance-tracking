import 'package:flutter/material.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/widgets/widgets.dart';

class Section extends StatelessWidget {
  const Section({
    Key? key,
    required this.section,
    this.badgeLabel='See all',
    this.badgeBorderColor=StudlyColors.borderColorGrey,required this.onTap}) : super(key: key);


  final String section;
  final String badgeLabel;
  final Color badgeBorderColor;
  final void Function()? onTap;


  @override
  Widget build(BuildContext context) {
    var dimension=Dimensions(context: context);
    return Container(
      padding: EdgeInsets.only(bottom: dimension.verticalPadding20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StudlyTypography(text: section,fontSize: dimension.font19,fontWeight: FontWeight.bold,),
          InkWell(
            onTap:onTap ,
            child: Container(
              width: dimension.containerWidth80,
              height: dimension.containerHeight35,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: badgeBorderColor,width: 1.5
                  ),
                  borderRadius: BorderRadius.circular(30)
              ),
              child: Center(child: StudlyTypography(text: badgeLabel,fontSize: dimension.font14,)),
            ),
          )
        ],
      ),
    );
  }
}
