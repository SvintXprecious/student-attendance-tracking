import 'package:flutter/material.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/module/components/student_module_card.dart';
import 'package:student_attendance/state/module/model/module.dart';


class StudentModuleCardBuilder extends StatelessWidget {
  const StudentModuleCardBuilder({Key? key,required this.modules}) : super(key: key);
  final Iterable<Module> modules;

  @override
  Widget build(BuildContext context) {
    var dimension=Dimensions(context: context);
    return SizedBox(
      height: dimension.sizedBox750,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: modules.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context,int index){
            final module=modules.elementAt(index);
            return StudentModuleCard(module: module,);

          }),
    );
  }
}