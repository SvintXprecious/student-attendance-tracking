import 'package:flutter/material.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/lecturer/module/dashboard/minimal/average_attendance_progress.dart';
import 'package:student_attendance/presentation/lecturer/module/dashboard/minimal/top_attendance_table.dart';
import 'package:student_attendance/state/module/model/module.dart';

class ModuleChartCarousel extends StatelessWidget {
  const ModuleChartCarousel({Key? key,required this.module,required this.sessions,required this.enrolled}) : super(key: key);
  final Module module;
  final int sessions;
  final int enrolled;

  @override
  Widget build(BuildContext context) {
    var dimension=Dimensions(context: context);
    if(sessions==0){
      return Container();
    }
    else{return Container(
      margin: EdgeInsets.only(
          left: dimension.horizontalPadding20,right: dimension.horizontalPadding20,bottom: dimension.verticalPadding10),
      child: GridView.count(
        crossAxisCount: 1,
        children: [
          AttendanceTableMinimal(module:module),
          AverageAttendanceProgressMinimal(module: module,totalSessions: sessions,totalEnrolled:enrolled),
          //AttendanceBySessionBarChart()
         // AttendanceTableMinimal(),

          //PieChartUI(session: session,),

          ///PieChartUI(session: session,)
        ],
      ),
    );}
  }
}
