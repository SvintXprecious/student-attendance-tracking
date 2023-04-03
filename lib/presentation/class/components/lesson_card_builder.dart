import 'package:flutter/material.dart';
import 'package:student_attendance/presentation/class/components/lesson_card.dart';
import 'package:student_attendance/state/sessions/model/session.dart';

class LessonCardBuilder extends StatelessWidget {
  const LessonCardBuilder({Key? key,required this.sessions}) : super(key: key);
  final Iterable<Session> sessions;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount: sessions.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context,int index){
          final session=sessions.elementAt(index);
          return LessonCard(session: session,);


        });
  }
}
