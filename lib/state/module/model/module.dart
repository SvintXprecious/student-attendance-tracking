import 'package:flutter/foundation.dart' show immutable;
import 'package:student_attendance/state/module/model/module_key.dart';


@immutable
class Module{
  const Module({
    required this.name,
    required this.description,
    required this.lecturer,
    required this.code,
    required this.programCode});

  final String name;
  final String description;
  final Map<String,dynamic> lecturer;
  final String code;
  final List<dynamic> programCode;

  factory Module.fromJson(Map<String,dynamic> json){
    final name = json[ModuleKey.name];
    final description = json[ModuleKey.description];
    final lecturer = json[ModuleKey.lecturer];
    final code = json[ModuleKey.code].toString();
    final programCode = json[ModuleKey.programCode];

    return Module(
        name: name,
        description: description,
        lecturer: lecturer,
        code: code,
        programCode: programCode);

  }

  static Set<dynamic> extractProgramCodes(Iterable<Module> modules) {
    return modules.expand((module) => module.programCode).toSet();
  }







}