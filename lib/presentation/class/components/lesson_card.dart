import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/state/sessions/model/session.dart';
import 'package:student_attendance/widgets/widgets.dart';

class LessonCard extends StatelessWidget {
  const LessonCard({Key? key,required this.session}) : super(key: key);
  final Session session;

  @override
  Widget build(BuildContext context) {
    var dimension=Dimensions(context: context);
    return Container(
      margin: EdgeInsets.only(top: dimension.verticalPadding10,bottom: dimension.verticalPadding10),
      padding:EdgeInsets.all(dimension.verticalPadding20),
      decoration: BoxDecoration(
          color: StudlyColors.backgroundColorLightGray,
          border: Border.all(color: StudlyColors.backgroundColorLightGray),
          borderRadius: BorderRadius.circular(20)
      ),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StudlyTypography(text: session.title,fontSize: dimension.font18,),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color:StudlyColors.borderColorBlack),
                    borderRadius: BorderRadius.circular(20)),
                child: IconButton(
                    onPressed: (){Navigator.pushNamed(context, '/Class',arguments: session);},
                    icon:  const Icon(Iconsax.arrow_right,
                      color: StudlyColors.iconColorGrey,)),),

            ],
          ),
          SizedBox(height: dimension.sizedBox5,),
          IconWithText(
              icon: Iconsax.verify5,
              label: session.module['name']!,iconColor: StudlyColors.backgroundColorBlueAccent,
            labelColor: StudlyColors.typographyDefaultColor,),
          SizedBox(height: dimension.sizedBox15,),
          IconWithText(
            icon: Iconsax.clock,
            label: '${session.start} - ${session.end}',
            iconColor: StudlyColors.backgroundColorBlueAccent,
            labelColor: StudlyColors.typographyDefaultColor,),
          SizedBox(height: dimension.sizedBox15,),
          const Divider(color: StudlyColors.borderColorGrey,),
          SizedBox(height: dimension.sizedBox15,),
          PictureLabel(
              imageUrl: session.lecturer['photoUrl'],
              imageHeight: dimension.containerHeight30,
              imageWidth: dimension.containerWidth30,
              fontWeight: FontWeight.w500,
              labelColor: StudlyColors.typographyDefaultColor,
              label: session.lecturer['name']),
        ],
      ),
    );
  }
}
