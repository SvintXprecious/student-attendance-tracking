import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_attendance/state/constants/firebase_collection_name.dart';
import 'package:student_attendance/state/module/model/module.dart';
import 'package:student_attendance/state/module/model/module_key.dart';
import 'package:student_attendance/state/users/models/user.dart';

final fetchStudentModulesProvider=StreamProvider
    .autoDispose
    .family<Iterable<Module>,AutoDisposeStreamProvider<User>>(
        (ref,userInfo){
          String code='';
          var programCode=ref.watch(userInfo);
          programCode.when(data: (student) => code=student.code , error: (error,stack) => null, loading: () => null);
          final controller=StreamController<Iterable<Module>>();
          controller.onListen=(){controller.sink.add([]);};

          final streamSubscription=FirebaseFirestore
              .instance
              .collection(FirebaseCollectionName.modules)
              .where(ModuleKey.programCode,arrayContains: code)
              .snapshots()
              .listen((snapshot){
                final modules=snapshot.docs.map((doc) => Module.fromJson(doc.data()),);
                controller.sink.add(modules);
              });

          ref.onDispose(() {
            streamSubscription.cancel();
            controller.close();
          });

          return controller.stream;
        }

        );


