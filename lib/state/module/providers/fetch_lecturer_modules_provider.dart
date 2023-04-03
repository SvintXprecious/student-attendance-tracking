import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_attendance/state/auth/models/auth_state.dart';
import 'package:student_attendance/state/auth/notifiers/auth_state_notifier.dart';
import 'package:student_attendance/state/constants/firebase_collection_name.dart';
import 'package:student_attendance/state/module/model/module.dart';
import 'package:student_attendance/state/module/model/module_key.dart';


final fetchLecturerModulesProvider=StreamProvider
    .autoDispose
    .family<Iterable<Module>,StateNotifierProvider<AuthStateNotifier, AuthState>>(
        (ref,authState){
          final uid=ref.watch(authState).userId;
          final controller=StreamController<Iterable<Module>>();
          controller.onListen=(){controller.sink.add([]);};
          final streamSubscription=FirebaseFirestore.instance
              .collection(FirebaseCollectionName.modules)
              .where('${ModuleKey.lecturer}.uid',isEqualTo:uid)
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


