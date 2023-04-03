import 'dart:collection';

import 'package:flutter/foundation.dart' show immutable;
import 'package:student_attendance/state/module/model/module_key.dart';

@immutable
class ModulePayload extends MapView<String,dynamic> {
  ModulePayload({
    required String name,
    required String description,
    required Map<String,dynamic> lecturer,
    required String code,
    required List<String> programCode,
}):super(
      {
        ModuleKey.programCode:programCode,
        ModuleKey.code:code,
        ModuleKey.description:description,
        ModuleKey.lecturer:lecturer,
        ModuleKey.name:name,

  }

  );

}