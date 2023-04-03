import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_attendance/state/constants/firebase_collection_name.dart';
import 'package:student_attendance/state/users/models/user.dart';

final fetchStudentEnrolmentProvider=StreamProvider
    .autoDispose<Iterable<User>>((ref){
      final controller=StreamController<Iterable<User>>();
      controller.onListen=(){controller.sink.add([]);};
      final streamSubscription=FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .snapshots()
          .listen((snapshot) {
        final documents=snapshot.docs;
        final userInfo=documents
            .map((doc) => User.fromJsonDocument(json: doc.data()));
        controller.sink.add(userInfo);
      });
      ref.onDispose(() {
        streamSubscription.cancel();
        controller.close();
      });

      return controller.stream;



    }
);