import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_attendance/state/constants/firebase_collection_name.dart';
import 'package:student_attendance/state/constants/firebase_field_name.dart';
import 'package:student_attendance/state/users/models/user.dart';

final fetchStudentInfoProvider=StreamProvider
    .autoDispose
    .family<User,String>(
        (ref,studentID){
      final controller=StreamController<User>();
      controller.onListen=(){};

      final streamSubscription=FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .where(FirebaseFieldName.uid,isEqualTo: studentID)
          .snapshots()
          .listen((snapshot) {
        final documents=snapshot.docs.first;
        controller.sink.add(User.fromJsonDocument(json: documents.data()));
      });
      ref.onDispose(() {
        streamSubscription.cancel();
        controller.close();
      });

      return controller.stream;



    }
);