import 'package:flutter/material.dart';
import 'package:student_attendance/presentation/lecturer/lesson/session_attendance_body.dart';
import 'package:student_attendance/state/sessions/model/session.dart';

class SessionAttendanceUI extends StatelessWidget {
  static const String routeName='/sessionAttendance';
  static Route route({required Session session}){
    return MaterialPageRoute(
      settings:const RouteSettings(name: routeName),
      builder: (_) => SessionAttendanceUI(session: session,),);
  }
  const SessionAttendanceUI({Key? key,required this.session}) : super(key: key);

  final Session session;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SessionAttendanceBody(session:session),
    );
  }
}
