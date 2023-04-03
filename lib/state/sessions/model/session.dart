import 'dart:core';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:student_attendance/state/sessions/model/session_key.dart';


@immutable
class Session {

  const Session({
    required this.sessionID,
    required this.title,
    required this.description,
    required this.lecturer,
    required this.room,
    required this.start,
    required this.end,
    required this.date,
    required this.createdAt,
    required this.module,
    required this.programCode,
    required this.attendees});

  final String sessionID;
  final String title;
  final String description;
  final Map<String, dynamic> lecturer;
  final String room;
  final String start;
  final String end;
  final String date;
  final DateTime createdAt;
  final Map<String, dynamic> module;
  final List<dynamic> programCode;
  final List<Map<String, dynamic>> attendees;



  factory Session.fromJson(Map<String, dynamic> json){
    final sessionID = json[SessionKey.sessionID];
    final title=json[SessionKey.title];
    final description=json[SessionKey.description];
    final lecturer=json[SessionKey.lecturer];
    final room=json[SessionKey.room];
    final start=json[SessionKey.startTime];
    final end=json[SessionKey.endTime];
    final date=json[SessionKey.date];
    final module=json[SessionKey.module];
    final attendees=(json[SessionKey.attendees] as List).map((e) => Map<String, dynamic>.from(e)).toList();
    final createdAt=(json[SessionKey.createdAt] as Timestamp).toDate();
    final programCode=json[SessionKey.programCode];

    return Session(
    sessionID: sessionID,
    title: title,
    description: description,
    lecturer: lecturer,
    room: room,
    start: start,
    end: end,
    date: date,
    createdAt: createdAt,
    module: module,
    programCode: programCode,
    attendees: attendees);

  }

  static String generateSessionID(
      {required String moduleCode, required String chars}) {
    Random rnd = Random();
    int length = (chars.length ~/ 2).toInt();
    return moduleCode + String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))))
        .toUpperCase();
  }

  static int checkPresent(List<Map<String, dynamic>> attendees) {
    var counter = 0;
    for (var attendee in attendees) {
      if (attendee['clock_in']
          .toString()
          .isNotEmpty && attendee['clock_out']
          .toString()
          .isNotEmpty) {
        counter += 1;
      }
    }
    return counter;
  }

  static String checkAbsent(List<Map<String, dynamic>> attendees) {
    var counter = 0;
    for (var attendee in attendees) {
      if (attendee['clock_in']
          .toString()
          .isNotEmpty && attendee['clock_out']
          .toString()
          .isNotEmpty) {
        counter += 1;
      }
    }
    return counter.toString();
  }

  static double generateSessionPercentage(
      {required int enrolled, required int statistic}) =>
      (statistic / enrolled) * 100;


}
