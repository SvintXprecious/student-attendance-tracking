import 'package:flutter/material.dart';
import 'package:student_attendance/presentation/lecturer/module/module_attendance_body.dart';
import 'package:student_attendance/state/module/model/module.dart';

class ModuleAttendanceUI extends StatelessWidget {
  static const String routeName='/moduleAttendance';
  static Route route({required Module module}){
    return MaterialPageRoute(
      settings:const RouteSettings(name: routeName),
      builder: (_) => ModuleAttendanceUI(module: module,),);
  }
  const ModuleAttendanceUI({Key? key,required this.module}) : super(key: key);
  final Module module;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModuleAttendanceBody(module: module,),
    );
  }
}
