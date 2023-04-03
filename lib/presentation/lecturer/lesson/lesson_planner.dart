import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/lecturer/lesson/lesson_planner_body.dart';
import 'package:student_attendance/widgets/widgets.dart';


class LessonPlannerUI extends StatelessWidget {

  static const String routeName='/lessonPlanner';

  static Route route(){
    return MaterialPageRoute(
      settings:const RouteSettings(name: routeName),
      builder: (_) => const LessonPlannerUI(),);
  }
  const LessonPlannerUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dimension=Dimensions(context: context);
    return SafeArea(
        child: Scaffold(
          appBar: StudlyAppBar(
              title: 'Lesson Planner',
              icon: Iconsax.arrow_left_1,
              onPressed:(){Navigator.pop(context);
              }),
            body: LessonPlannerBody(),
        )
    );
  }
}
