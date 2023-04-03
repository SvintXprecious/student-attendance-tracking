import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_attendance/state/auth/models/auth_state.dart';
import 'package:student_attendance/state/auth/notifiers/auth_state_notifier.dart';
import 'package:student_attendance/state/constants/firebase_collection_name.dart';
import 'package:student_attendance/state/sessions/model/session.dart';
import 'package:student_attendance/state/sessions/model/session_key.dart';



final fetchLecturerSessionsProvider=StreamProvider
    .autoDispose
    .family<Iterable<Session>,StateNotifierProvider<AuthStateNotifier, AuthState>>(
        (ref,authState) {
          final uid=ref.watch(authState).userId;
          final controller=StreamController<Iterable<Session>>();

          controller.onListen=(){controller.sink.add([]);};

          final streamSubscription=FirebaseFirestore.instance
              .collection(FirebaseCollectionName.sessions)
              .where('${SessionKey.lecturer}.uid',isEqualTo: uid)
              .snapshots()
              .listen((snapshot) {
                final documents=snapshot.docs;
                final sessions=documents
                    .where(
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