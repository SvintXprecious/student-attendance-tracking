import 'package:flutter/material.dart';
import 'package:student_attendance/presentation/lecturer/registration/components/asssessment_card.dart';
import 'package:student_attendance/state/registrations/model/registration.dart';

class AssessmentCarousel extends StatelessWidget {
  const AssessmentCarousel({Key? key, required this.assessments})
      : super(key: key);
  final Iterable<Registration> assessments;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: assessments.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return  AssessmentCard(assessment: assessments.elementAt(index),);
        });
  }
}
