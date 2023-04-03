import 'package:flutter/material.dart';
import 'package:student_attendance/state/sessions/model/session.dart';

import 'class_card_minimal.dart';

class Sessions extends StatelessWidget {
  const Sessions({Key? key, required this.sessions}) : super(key: key);
  final Iterable<Session> sessions;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sessions.length,
        itemBuilder: (BuildContext context,int index){
          final session=sessions.elementAt(index);
          return ClassCardMinimal(session: session,);
        }
);
  }
}
