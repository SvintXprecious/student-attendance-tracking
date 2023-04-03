import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_attendance/state/notifiers/radiobutton_notifier.dart';

final radioProvider=NotifierProvider<Radio,String>(Radio.new);