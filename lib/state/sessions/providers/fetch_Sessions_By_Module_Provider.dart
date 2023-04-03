import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_attendance/state/constants/firebase_collection_name.dart';
import 'package:student_attendance/state/sessions/model/session.dart';
import 'package:student_attendance/state/sessions/model/session_key.dart';



final fetchSessionsByModuleProvider=StreamProvider.family.autoDispose<int,String>(
        (ref,String code) {
          final controller=StreamController<int>();
          controller.onListen=(){controller.sink.add(0);};

          final streamSubscription=FirebaseFirestore.instance
              .collection(FirebaseCollectionName.sessions)
              .where('${SessionKey.module}.code',isEqualTo: code)
              .snapshots()
              .listen((snapshot) {
                final documents=snapshot.docs;
                final sessions=documents
                    .where(
                      (doc) => !doc.metadata.hasPendingWrites,)
                    .map((doc) => Session.fromJson(doc.data())).length;
                controller.sink.add(sessions);
              });

          ref.onDispose(() {
            streamSubscription.cancel();
            controller.close();
          });

          return controller.stream;



    }
);