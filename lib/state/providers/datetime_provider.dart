import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_attendance/state/notifiers/datetime_notifier.dart';

final dateTimeProvider=NotifierProvider<TimeTableDateTime,DateTime>(TimeTableDateTime.new);