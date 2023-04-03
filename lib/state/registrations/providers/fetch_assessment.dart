import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_attendance/state/constants/firebase_collection_name.dart';
import 'package:student_attendance/state/registrations/model/registration.dart';
import 'package:student_attendance/state/registrations/model/registration_key.dart';

final fetchAssessmentProvider = StreamProvider.autoDispose
    .family<Registration, String>((ref, String assessmentID) {
  final controller = StreamController<Registration>();
  controller.onListen = () {};

  final streamSubscription = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.registrations)
      .where(RegistrationKey.assessmentID, isEqualTo: assessmentID)
      .limit(1)
      .snapshots()
      .listen((snapshot) {
    final documents = snapshot.docs.first;
    controller.sink.add(Registration.fromJson(documents.data()));
  });

  ref.onDispose(() {
    streamSubscription.cancel();
    controller.close();
  });

  return controller.stream;
});
