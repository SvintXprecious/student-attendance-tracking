import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/lecturer/module/module_planner_body.dart';
import 'package:student_attendance/widgets/widgets.dart';



class ModulePlannerUI extends StatelessWidget {
  static const String routeName='/modulePlanner';

  static Route route(){
    return MaterialPageRoute(
      settings:const RouteSettings(name: routeName),
      builder: (_) => const ModulePlannerUI(),);
  }
  const ModulePlannerUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dimension=Dimensions(context: context);
    return SafeArea(
        child: Scaffold(
          appBar: StudlyAppBar(
              title: 'Module',
              icon: Iconsax.arrow_left_1,
              onPressed: (){
                Navigator.pop(context);

          }),
            body: const ModulePlannerBody()
        )
    );
  }
}
