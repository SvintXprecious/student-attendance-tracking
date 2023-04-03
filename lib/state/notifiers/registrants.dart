import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'registrants.g.dart';

@riverpod
class Registrants extends _$Registrants{

  @override
  List<List<String>>  build(){
    return [];
  }

  void addRegistrant (List<String> registrant){
    state=[...state,registrant];
  }
}