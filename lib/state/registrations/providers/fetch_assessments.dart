import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_attendance/state/constants/firebase_collection_name.dart';
import 'package:student_attendance/state/registrations/model/registration.dart';
import 'package:student_attendance/state/registrations/model/registration_key.dart';



final fetchAssessmentsProvider=StreamProvider
    .autoDispose
    .family<Iterable<Registration>,String>(
        (ref,uid) {
      final controller=StreamController<Iterable<Registration>>();

      controller.onListen=(){controller.sink.add([]);};

      final streamSubscription=FirebaseFirestore.instance
          .collection(FirebaseCollectionName.registrations)
          .where('${RegistrationKey.lecturer}.uid',isEqualTo: uid)
          .snapshots()
          .listen((snapshot) {
        final documents=snapshot.docs;
        final registrations=documents.map((doc) => Registration.fromJson(doc.data()));
        controller.sink.add(registrations);
      });

      ref.onDispose(() {
        streamSubscription.cancel();
        controller.close();

      });

      return controller.stream;
    }
);