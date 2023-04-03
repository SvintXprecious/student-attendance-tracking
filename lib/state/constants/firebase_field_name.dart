import 'package:flutter/foundation.dart' show immutable;

@immutable
class FirebaseFieldName {
  static const uid = 'uid';
  static const studentId = 'student_id';
  static const program = 'program_';
  static const displayName = 'name';
  static const email = 'email';
  static const photo='photoUrl';
  static const year='year';
  static const code='code';
  const FirebaseFieldName._();
}
