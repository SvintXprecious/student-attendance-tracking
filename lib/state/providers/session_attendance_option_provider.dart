import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_attendance/state/notifiers/session_attendance_option.dart';

final sessionAttendanceOptionProvider=NotifierProvider<SessionAttendanceOption,String>(SessionAttendanceOption.new);