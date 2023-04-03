import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_attendance/state/constants/firebase_collection_name.dart';
import 'package:student_attendance/state/sessions/model/session.dart';
import 'package:student_attendance/state/sessions/model/session_key.dart';
import 'package:student_attendance/state/users/models/user.dart';

final fetchStudentSessionsProvider=StreamProvider
    .autoDispose
    .family<Iterable<Session>,AutoDisposeStreamProvider<User>>(
        (ref,studentInfo){
          String code='';
          var programCode=ref.watch(studentInfo);
          programCode.when(data: (student) => code=student.code , error: (error,stack) => null, loading: () => null);
          final controller=StreamController<Iterable<Session>>();
          controller.onListen=(){controller.sink.add([]);};

          final streamSubscription=FirebaseFirestore.instance
              .collection(FirebaseCollectionName.sessions)
              .where(SessionKey.programCode,arrayContains: code)
              .snapshots()
              .listen((snapshot) {
                final documents=snapshot.docs;
                final sessions=documents.where(
                      (doc) => !doc.metadata.hasPendingWrites,)
                    .map((doc) => Session.fromJson(doc.data()));
                controller.sink.add(sessions);
              });
          ref.onDispose(() {
            streamSubscription.cancel();
            controller.close();
          });

          return controller.stream;



    }
);