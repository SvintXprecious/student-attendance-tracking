
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:student_attendance/state/constants/firebase_collection_name.dart';
import 'package:student_attendance/state/module/model/module_key.dart';
import 'package:student_attendance/state/module/model/module_payload.dart';

part 'modules.g.dart';

@riverpod
class Modules extends _$Modules{

  @override
  FutureOr<bool> build(){
    return false;
  }

  Future<bool> addModule({
    required String name,
    required String description,
    required Map<String,dynamic> lecturer,
    required String code,
    required List<String> programCode,}) async{

    final payload=ModulePayload(
        name: name,
        description: description,
        lecturer: lecturer,
        code: code.toUpperCase(),
        programCode: programCode,

    );
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.modules)
          .add(payload);
      return true;
    }
    catch (_) {
      return false;
    }
    finally {
    }
}

Future<bool> updateModule({
  required String moduleCode,
  required List<String>  programCode,
  required String description,
  required String name,}) async{

  try {
    // first check if we have the module from before
    final module = await FirebaseFirestore
        .instance
        .collection(FirebaseCollectionName.modules)
        .where(ModuleKey.code, isEqualTo: moduleCode)
        .limit(1)
        .get();

    if (module.docs.isNotEmpty) {
      // we already have this module, save the new data instead
      await module.docs.first.reference.update({
        ModuleKey.code: moduleCode,
        ModuleKey.description: description,
        ModuleKey.programCode:programCode,
        ModuleKey.name:name,
      });
      return true;
    }
    return true;

  }
  catch (_)
  {
    return false;
  }
}



  Future<bool> deleteModule({required String moduleID,}) async {
    try {


      final postInCollection = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.modules)
          .where(ModuleKey.code, isEqualTo: moduleID,)
          .limit(1)
          .get();

      for (final post in postInCollection.docs) {
        await post.reference.delete();
      }

      return true;
    }
    catch (_) {
      return false;
    }
    finally {
    }
  }

 
}