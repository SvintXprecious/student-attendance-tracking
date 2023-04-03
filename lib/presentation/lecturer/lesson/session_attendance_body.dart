import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/lecturer/lesson/lesson_statistics/components/charts_carousel.dart';
import 'package:student_attendance/state/providers/session_attendance_option_provider.dart';
import 'package:student_attendance/state/sessions/model/session.dart';
import 'package:student_attendance/widgets/widgets.dart';

class SessionAttendanceBody extends ConsumerWidget{
  const SessionAttendanceBody({Key? key,required this.session}) : super(key: key);


  final Session session;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var dimension=Dimensions(context: context);
    var option=ref.watch(sessionAttendanceOptionProvider);
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
                  height: 220,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        width: 370,
                        height: 80,
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
                        child: StudlyTypography(text: session.title,fontSize: dimension.font18,),

                      ),
                      Expanded(
                        child: Container(
                          width: 370,
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
                                  StudlyTypography(text: "Session ID: "),
                                  StudlyTypography(
                                    text: session.sessionID,
                                    fontWeight: FontWeight.w400,
                                    fontSize: dimension.font14,)

                                ],
                              ),
                              SizedBox(height: dimension.verticalPadding10,),
                              Row(
                                children: [
                                  StudlyTypography(text: "Module: "),
                                  StudlyTypography(
                                    text: session.module['name'],
                                    fontWeight: FontWeight.w400,
                                    fontSize: dimension.font14,)

                                ],
                              ),
                              SizedBox(height: dimension.verticalPadding10,),
                              Row(
                                children: [
                                  StudlyTypography(text: "Date: "),
                                  StudlyTypography(
                                    text: DateFormat.yMMMMd().format(DateTime.parse(session.date)),
                                    fontWeight: FontWeight.w400,
                                    fontSize: dimension.font14,)

                                ],
                              )

                            ],
                          ),
                        ),
                      )

                    ],
                  ),
                )
            ),

            //module code
            //time and venue

            Positioned(
              top: 300,
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
                child: ChartCarousel(session: session,),
              ),
            )
          ],
        ),
      ),
    );
  }
}
