import 'dart:collection';

import 'package:flutter/foundation.dart' show immutable;
import 'package:student_attendance/state/constants/firebase_field_name.dart';
import 'package:student_attendance/state/typedefs.dart';

@immutable
class User extends MapView<String, String> {
  final UserId uid;
  final String studentId;
  final String name;
  final String email;
  final String photoUrl;
  final String program;
  final String year;
  final String code;

  User({
    required this.studentId,
    required this.program,
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.year,
    required this.code
  }) : super(
          {
            FirebaseFieldName.uid: uid,
            FirebaseFieldName.displayName: name,
            FirebaseFieldName.email: email,
            FirebaseFieldName.photo:photoUrl,
            FirebaseFieldName.studentId:studentId,
            FirebaseFieldName.program:program,
            FirebaseFieldName.code:code,
          },
        );

  User.fromJson(
    Map<String, dynamic> json, {
    required UserId userId,
  }) : this(
    uid: userId,
    name: json[FirebaseFieldName.displayName] ?? '',
    email: json[FirebaseFieldName.email],
    photoUrl: json[FirebaseFieldName.photo],
    program: json[FirebaseFieldName.program],
    studentId: json[FirebaseFieldName.studentId],
    year: json[FirebaseFieldName.year],
    code: json[FirebaseFieldName.code]
  );

  User.fromJsonDocument({required Map<String, dynamic> json}) : this(
    uid: json[FirebaseFieldName.uid],
    name: json[FirebaseFieldName.displayName],
    email: json[FirebaseFieldName.email],
    photoUrl: json[FirebaseFieldName.photo],
    program: json[FirebaseFieldName.program],
    studentId: json[FirebaseFieldName.studentId],
    year: json[FirebaseFieldName.year],
    code: json[FirebaseFieldName.code]
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          name == other.name &&
          email == other.email &&
          photoUrl == other.photoUrl &&
          studentId == other.studentId &&
          year ==other.year &&
          code ==other.code &&
          program == other.program;


  @override
  int get hashCode => Object.hashAll(
        [
          uid,
          name,
          email,
          photoUrl,
          program,
          studentId,
          year,
          code
        ],
      );
}
