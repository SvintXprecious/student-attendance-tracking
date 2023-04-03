import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_attendance/state/constants/firebase_collection_name.dart';
import 'package:student_attendance/state/users/models/user.dart';



final fetchModuleEnrollmentProvider=StreamProvider.autoDispose.family<Iterable<User>,List<dynamic>>(
        (ref,programCode){
      final controller=StreamController<Iterable<User>>();

      controller.onListen=(){controller.sink.add([]);};

      final streamSubscription=FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .snapshots()
          .listen((snapshot) {
        final documents=snapshot.docs;
        final students=documents
            .where(
              (doc) => !doc.metadata.hasPendingWrites,)
            .map((doc) => User.fromJsonDocument(json: doc.data()));
        controller.sink.add(students);
      });

      ref.onDispose(() {
        streamSubscription.cancel();
        controller.close();

      });

      return controller.stream;
    }
);