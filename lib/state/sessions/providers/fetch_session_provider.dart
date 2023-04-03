import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_attendance/state/constants/firebase_collection_name.dart';
import 'package:student_attendance/state/sessions/model/session.dart';
import 'package:student_attendance/state/sessions/model/session_key.dart';



final fetchSessionProvider=StreamProvider.autoDispose.family<Session,String>(
        (ref,String id) {
      final controller=StreamController<Session>();
      controller.onListen=(){};

      final streamSubscription=FirebaseFirestore.instance
          .collection(FirebaseCollectionName.sessions)
          .where(SessionKey.sessionID,isEqualTo: id)
          .snapshots()
          .listen((snapshot) {
        final documents=snapshot.docs.first;
        controller.sink.add(Session.fromJson(documents.data()));

      });

      ref.onDispose(() {
        streamSubscription.cancel();
        controller.close();
      });

      return controller.stream;



    }
);