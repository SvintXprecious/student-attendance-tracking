import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/state/module/model/module.dart';
import 'package:student_attendance/state/sessions/providers/fetch_Sessions_By_Module_Provider.dart';
import 'package:student_attendance/widgets/widgets.dart';

class StudentModuleCard extends ConsumerWidget{
  const StudentModuleCard({Key? key,required this.module}) : super(key: key);
  final Module module;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var dimension=Dimensions(context: context);
    var sessions=ref.watch(fetchSessionsByModuleProvider(module.code));
    return Container(
      margin: EdgeInsets.only(top: dimension.verticalPadding10,bottom: dimension.verticalPadding10),
      padding:EdgeInsets.all(dimension.verticalPadding20),
      decoration: BoxDecoration(
          color: StudlyColors.backgroundColorBlueAccent,
          borderRadius: BorderRadius.circular(30)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconWithTextFlexed(
            icon: Iconsax.verify5,
            label: module.name,
            labelFontSize: dimension.font16,
            iconColor: StudlyColors.backgroundColorAqua,
            labelColor: StudlyColors.typographyWhite,),
          SizedBox(height: dimension.sizedBox10,),
          Padding(
            padding: EdgeInsets.only(left: dimension.horizontalPadding32),
            child: StudlyTypography(
              text: module.code,
              fontSize: dimension.font11,
              fontWeight: FontWeight.normal,
              color: StudlyColors.typographyWhite,),
          ),
          SizedBox(height: dimension.sizedBox10,),
          Padding(
            padding: EdgeInsets.only(left: dimension.horizontalPadding32),
            child: StudlyTypography(
              text: 'by ${module.lecturer['name']}',
              fontWeight: FontWeight.normal,
              fontSize: dimension.font11,
              color: StudlyColors.typographyWhite,),
          ),
          SizedBox(height: dimension.sizedBox15,),
          Container(
            margin: EdgeInsets.only(left: dimension.horizontalPadding32),
            padding: EdgeInsets.only(left:dimension.horizontalPadding10,right: dimension.horizontalPadding10),
            decoration: BoxDecoration(
              color:StudlyColors.backgroundColorAqua,
                borderRadius: BorderRadius.circular(30)),
            child: sessions.when(
                data: (sessions) =>  StudlyTypography(
                  text: sessions==1?'${sessions.toString()} lesson':'${sessions.toString()} lessons',
                  color: StudlyColors.typographyWhite,
                  fontSize: dimension.font13,),
                error: (error,stack) => Container(),
                loading: () => Container()),


          ),


        ],
      ),
    );
  }
}

