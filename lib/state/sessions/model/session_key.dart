import 'package:flutter/foundation.dart' show immutable;


@immutable
class SessionKey{
  static const sessionID='session_id';
  static const title='title';
  static const description='description';
  static const lecturer='lecturer';
  static const room='room';
  static const startTime='start_time';
  static const endTime='end_time';
  static const date='date';
  static const createdAt='created_at';
  static const programCode='program_code';
  static const module='module';
  static const attendees='attendees';
  const SessionKey._();
}