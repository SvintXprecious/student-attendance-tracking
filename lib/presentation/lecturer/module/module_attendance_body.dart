import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/lecturer/module/dashboard/components/module_charts_carousel.dart';
import 'package:student_attendance/state/module/model/module.dart';
import 'package:student_attendance/state/module/providers/fetch_all_sessions_provider.dart';
import 'package:student_attendance/state/module/providers/fetch_module_enrollment.dart';
import 'package:student_attendance/state/providers/session_attendance_option_provider.dart';
import 'package:student_attendance/widgets/widgets.dart';

class ModuleAttendanceBody extends ConsumerWidget{
  const ModuleAttendanceBody({Key? key,required this.module}) : super(key: key);
  final Module module;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var dimension=Dimensions(context: context);
    var option=ref.watch(sessionAttendanceOptionProvider);
    var sessions = ref.watch(fetchAllSessionsProvider(module.code));
    var enrollment=ref.watch(fetchModuleEnrollmentProvider(module.programCode));
    var totalSessions=0;
    var totalEnrolled=0;
    //var sessionAttendance=ref.watch(fetchSessionAttendance(session.sessionID));
    return SafeArea(
      child: SizedBox(
        height: double.maxFinite,
        //width: double.maxFinite,
        child: Stack(
          children: [
            Positioned(
                child: Container(
                  height: 400,
                  color: StudlyColors.backgroundColorLightGray,)
            ),

            Positioned(
                left: dimension.horizontalPadding20,
                right: dimension.horizontalPadding20,
                top: 30,
                child: Container(
                  height: 120,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        width: 370,
                        height: 70,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0)
                          ),
                          color: StudlyColors.backgroundColorBlueAccent,
                         // border: Border.all(color: StudlyColors.backgroundColor),

                      ),
                        child: StudlyTypography(text: module.name,fontSize: dimension.font18,),

                      ),
                      Expanded(
                        child: Container(
                          width: 370,
                          height: 100,
                          decoration:  const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30)
                            ),
                            color: StudlyColors.backgroundColor,
                           // border: Border.all(color: StudlyColors.backgroundColor),

                          ),
                          padding: EdgeInsets.only(
                            top: dimension.verticalPadding10,
                              left: dimension.horizontalPadding20,
                              right: dimension.horizontalPadding20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  StudlyTypography(text: "Module Code : "),
                                  StudlyTypography(
                                    text: module.code,
                                    fontWeight: FontWeight.w400,
                                    fontSize: dimension.font14,)

                                ],
                              ),
                              SizedBox(height: dimension.verticalPadding10,),


                            ],
                          ),
                        ),
                      )

                    ],
                  ),
                )
            ),
            Positioned(
              top: 190,
              child: Container(
                padding: EdgeInsets.only(left: dimension.horizontalPadding20,right: dimension.horizontalPadding20),
                margin: EdgeInsets.only(left: dimension.horizontalPadding20,right: dimension.horizontalPadding20),
                height:90,
                width: 370,
                decoration: BoxDecoration(
                    color: StudlyColors.backgroundColorBlueAccent,
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    enrollment.when(data: (enrolled){
                      var codes=module.programCode.map((element) => element.toString()).toList();
                      totalEnrolled=enrolled.where((user) => codes.contains(user.code)).length;
                      return Container(
                        padding: EdgeInsets.only(top: 10,bottom: 10),
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Iconsax.health,color: StudlyColors.typographyWhite,),
                                SizedBox(width: 10,),
                                StudlyTypography(text: "Enrolled",fontSize: dimension.font13,color: StudlyColors.typographyWhite,),
                              ],
                            ),
                            SizedBox(height: 10,),
                            StudlyTypography(text: totalEnrolled.toString(),color: StudlyColors.typographyWhite,)
                          ],
                        ),
                      );

                    }, error: (error,stack) => Container(), loading: () => Container()),

                    const VerticalDivider(
                      color: StudlyColors.backgroundColorSlate,
                      thickness: 2,indent: 10,endIndent: 10,
                    ),
                    sessions.when(data: (sessions){
                      totalSessions=sessions.where((element) => DateTime.now().difference(DateTime.parse(element.date)).inDays >= 0).length;

                      return  Container(
                        padding: EdgeInsets.only(top: 10,bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Iconsax.trend_up,color: StudlyColors.typographyWhite,),
                                SizedBox(width: 10,),
                                StudlyTypography(text: "Lessons",fontSize: dimension.font13,color: StudlyColors.typographyWhite,),
                              ],
                            ),
                            SizedBox(height: 10,),
                            StudlyTypography(text: sessions.length.toString(),color: StudlyColors.typographyWhite,)
                          ],
                        ),
                      );

                    }, error: (error,stack) => Container(), loading: () => Container()),

                    const VerticalDivider(
                      color: StudlyColors.backgroundColorSlate,
                      thickness: 2,indent: 10,endIndent: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10,bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Iconsax.trend_down,color: StudlyColors.typographyWhite,),
                              SizedBox(width: 10,),
                              StudlyTypography(text: "Programs",fontSize: dimension.font13,color: StudlyColors.typographyWhite,),
                            ],
                          ),
                          SizedBox(height: 10,),
                          StudlyTypography(text: module.programCode.length.toString(),color: StudlyColors.typographyWhite,)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            //module code
            //time and venue

            Positioned(
              top: 350,
              left:0,
              right:0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.only(
                  top: dimension.verticalPadding20,
                  left:dimension.horizontalPadding20,
                  right: dimension.horizontalPadding20,),
                decoration: const BoxDecoration(
                    color: StudlyColors.backgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))
                ),
                child: ModuleChartCarousel(module: module,sessions: totalSessions,enrolled:totalEnrolled)
              ),
            )
          ],
        ),
      ),
    );
  }
}
