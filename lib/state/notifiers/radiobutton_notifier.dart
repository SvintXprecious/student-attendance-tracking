import 'package:riverpod_annotation/riverpod_annotation.dart';


class Radio extends Notifier<String>{

  @override
  String build() {
    return '';
  }

  void onChangeOption(String option){
    state=option;
  }


}