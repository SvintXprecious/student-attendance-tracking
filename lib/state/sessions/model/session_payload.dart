import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:student_attendance/state/sessions/model/session_key.dart';

@immutable
class SessionPayload  extends MapView<String,dynamic> {
  SessionPayload({
    required String title,
    required String description,
    required String room,
    required String date,
    required String startTime,
    required String endTime,
    required String sessionID,
    required Map<String,dynamic> lecturer,
    required List<Map<String,dynamic>> attendees,
    required Map<String,dynamic> module,
    required List<dynamic> programCodes,


  }):super(
      {

        SessionKey.title:title,
        SessionKey.room:room,
        SessionKey.lecturer:lecturer,
        SessionKey.startTime:startTime,
        SessionKey.endTime:endTime,
        SessionKey.sessionID:sessionID,
        SessionKey.description:description,
        SessionKey.attendees:attendees,
        SessionKey.date:date,
        SessionKey.module:module,
        SessionKey.programCode:programCodes,
        SessionKey.createdAt:FieldValue.serverTimestamp()

      }

  );



}