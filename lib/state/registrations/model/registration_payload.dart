import 'dart:collection';

import 'package:flutter/foundation.dart' show immutable;
import 'package:student_attendance/state/registrations/model/registration_key.dart';

@immutable
class RegistrationPayload extends MapView<String, dynamic> {
  RegistrationPayload({
    required String assessmentID,
    required String title,
    required Map<String, dynamic> lecturer,
    required String date,
    required List<dynamic> programCodes,
    required Map<String, dynamic> module,
    required List<dynamic> attendees,
    required String type,
  }) : super({
          RegistrationKey.assessmentID: assessmentID,
          RegistrationKey.title: title,
          RegistrationKey.lecturer: lecturer,
          RegistrationKey.date: date,
          RegistrationKey.programCode: programCodes,
          RegistrationKey.module: module,
          RegistrationKey.attendees: attendees,
          RegistrationKey.type: type
        });
}
