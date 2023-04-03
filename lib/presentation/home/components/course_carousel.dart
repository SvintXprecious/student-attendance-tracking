import 'package:flutter/material.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/home/components/course_card.dart';
import 'package:student_attendance/state/module/model/module.dart';

class CourseCarousel extends StatelessWidget {
  const CourseCarousel({Key? key,required this.modules}) : super(key: key);
  final Iterable<Module> modules;

  @override
  Widget build(BuildContext context) {
    var dimension=Dimensions(context: context);
    return  SizedBox(
      height:dimension.sizedBox260,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: modules.length,
          itemBuilder: (BuildContext context,int index){
            final module=modules.elementAt(index);
            return CourseCard(module: module,);

          }),
    );
  }
}
