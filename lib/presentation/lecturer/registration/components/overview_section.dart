import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/widgets/widgets.dart';

class OverViewSection extends StatelessWidget {
  const OverViewSection({Key? key,required this.registered,required this.programs}) : super(key: key);
  final int registered;
  final int programs;

  @override
  Widget build(BuildContext context) {
    var dimension = Dimensions(context: context);
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            width: 150,
            margin: EdgeInsets.only(right: dimension.horizontalPadding20),
            padding: EdgeInsets.only(left: dimension.horizontalPadding10,right: dimension.horizontalPadding10,top: dimension.verticalPadding10,bottom: dimension.verticalPadding14),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: StudlyColors.backgroundColorLightGray,),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(Iconsax.people,size: dimension.containerHeight20),
                    SizedBox(
                      width: dimension.sizedBoxWidth10,
                    ),
                    StudlyTypography(
                      text: 'Registered',
                      fontSize: dimension.font13,

                    ),
                  ],
                ),

                Center(child: StudlyTypography(text: registered.toString(), color: StudlyColors.backgroundColorBlueAccent,fontSize: dimension.font22,))
              ],
            ),
          ),
          Container(
            width: 150,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: StudlyColors.backgroundColorLightGray,),
            padding: EdgeInsets.only(left: dimension.horizontalPadding10,right: dimension.horizontalPadding10,top: dimension.verticalPadding10,bottom: dimension.verticalPadding14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(Iconsax.teacher),
                    SizedBox(
                      width: dimension.sizedBoxWidth10,
                    ),
                    StudlyTypography(
                      text: 'Programs',
                      fontSize: dimension.font13,
                    ),
                  ],
                ),
                Center(child: StudlyTypography(text: programs.toString(), color: StudlyColors.backgroundColorBlueAccent,fontSize: dimension.font22,))
              ],
            ),
          )
        ],
      ),
    );
  }
}
