import 'package:riverpod_annotation/riverpod_annotation.dart';

class TimeTableDateTime extends Notifier<DateTime>{

  @override
  DateTime build() {
    return DateTime.now();
  }

  void onDateSelected(DateTime? date){
    state=date!;
  }


}