import 'package:flutter/material.dart';
import 'package:student_attendance/presentation/lecturer/lesson/lesson_statistics/pie_chart_attendance.dart';
import 'package:student_attendance/state/sessions/model/session.dart';

class PieChartAttendanceRateUI extends StatelessWidget {
  static const String routeName='/sessionAttendanceRate';

  static Route route({required Session session}){
    return MaterialPageRoute(
      settings:const RouteSettings(name: routeName),
      builder: (_) => PieChartAttendanceRateUI (session: session,),);
  }

  const PieChartAttendanceRateUI({Key? key,required this.session}) : super(key: key);

  final Session session;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: session.attendees.isEmpty? Container():PieChartAttendanceRateBody(session: session,),
    );
  }
}
