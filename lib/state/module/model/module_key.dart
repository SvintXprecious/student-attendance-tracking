import 'package:flutter/foundation.dart' show immutable;

@immutable
class ModuleKey{
  static const name='name';
  static const description='description';
  static const lecturer='lecturer';
  static const code='code';
  static const programCode='program_code';

  const ModuleKey._();

}