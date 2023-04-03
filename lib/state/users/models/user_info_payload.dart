import 'dart:collection' show MapView;

import 'package:flutter/foundation.dart' show immutable;
import 'package:student_attendance/state/constants/firebase_field_name.dart';
import 'package:student_attendance/state/typedefs.dart';

@immutable
class UserInfoPayload extends MapView<String, String> {
  UserInfoPayload({
    required UserId userId,
    required String? name,
    required String? email,
    required String? photoUrl,
    required String programCode,
    required String studentId,
    required String year,
    required String code,
  }) : super(
          {
            FirebaseFieldName.uid: userId,
            FirebaseFieldName.displayName: name ?? '',
            FirebaseFieldName.email: email ?? '',
            FirebaseFieldName.photo:photoUrl?? '',
            FirebaseFieldName.program:programCode,
            FirebaseFieldName.year:year,
            FirebaseFieldName.studentId:studentId,
            FirebaseFieldName.code:code
          },
        );
}
