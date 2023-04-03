import 'package:riverpod_annotation/riverpod_annotation.dart';

class SessionAttendanceOption extends Notifier<String>{

  @override
  String build() {
    return "Enrolled";
  }

  void onOptionSelected(String option){
    state=option;
  }


}