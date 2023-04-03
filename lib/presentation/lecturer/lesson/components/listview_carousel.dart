
import 'package:flutter/material.dart';
import 'package:student_attendance/presentation/lecturer/lesson/components/session_card.dart';
import 'package:student_attendance/state/sessions/model/session.dart';


class ListViewSessionCarousel extends StatelessWidget {
  
  const ListViewSessionCarousel({Key? key,required this.sessions}) : super(key: key);
  final Iterable<Session> sessions;



  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: sessions.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context,int index) {
          var session=sessions.elementAt(index);
          return SessionCard(session: session,);
        });
  }
}
