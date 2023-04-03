import 'package:flutter/material.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/lecturer/registration/components/assessment_formfields.dart';

class AssessmentPlanner extends StatelessWidget {
  const AssessmentPlanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dimension = Dimensions(context: context);
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
            left: dimension.horizontalPadding20,
            right: dimension.horizontalPadding20),
        child: const AssessmentFormFields(),
      ),
    );
  }
}
