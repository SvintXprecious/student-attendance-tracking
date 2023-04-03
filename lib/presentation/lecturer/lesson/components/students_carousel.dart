import 'package:flutter/material.dart';
import 'package:student_attendance/presentation/lecturer/lesson/components/student_card.dart';

class StudentsCarousel extends StatelessWidget {
  const StudentsCarousel({Key? key,required this.attendees}) : super(key: key);

  final List<Map<String,dynamic>> attendees;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: attendees.length,
          itemBuilder:(BuildContext context,int index){
            //print(attendees.elementAt(index));
            var attendee=attendees.elementAt(index);
            return StudentCard(attendee: attendee,);

          }),
    );
  }
}
