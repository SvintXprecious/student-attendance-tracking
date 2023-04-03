import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:student_attendance/state/constants/firebase_collection_name.dart';
import 'package:student_attendance/state/registrations/model/registration_key.dart';
import 'package:student_attendance/state/registrations/model/registration_payload.dart';

part 'registrations.g.dart';

@riverpod
class Registrations extends _$Registrations{
  @override
  FutureOr<bool> build() {
    return false;
  }

  Future<bool> addAssessment({
    required String title,
    required Map<String,dynamic> lecturer,
    required String date,
    required List<dynamic> programCodes,
    required Map<String,dynamic> module,
    required List<dynamic> attendees,
    required String type,
  }) async {
    var firebaseFirestore =
    FirebaseFirestore.instance.collection(FirebaseCollectionName.registrations);
    var docRef = firebaseFirestore.doc();

    final payload = RegistrationPayload(
        assessmentID: docRef.id,
        type: type,
        title: title,
        lecturer: lecturer,
        date: date,
        programCodes: programCodes,
        module: module,
        attendees:attendees);


    try {
      // await docRef.set(payload);
      await firebaseFirestore.add(payload);
      return true;
    } catch (_) {
      return false;
    } finally {}
  }

  Future<bool> addStudent({
    required String assessmentID,
    required List<dynamic> attendees,
  }) async {
    try {
      // first check if we have the session
      final session = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.registrations)
          .where(RegistrationKey.assessmentID, isEqualTo: assessmentID)
          .limit(1)
          .get();

      if (session.docs.isNotEmpty) {
        // we already have this session, save the new data instead
        await session.docs.first.reference.update({RegistrationKey.attendees: attendees});
        return true;
      }
      return true;
    } catch (_) {
      return false;
    }
  }



  Future<bool> deleteAssessment({
    required String documentID,
  }) async {
    try {
      final postInCollection = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.registrations)
          .where(
        RegistrationKey.assessmentID,
        isEqualTo: documentID,
      )
          .limit(1)
          .get();

      for (final post in postInCollection.docs) {
        await post.reference.delete();
      }

      return true;
    } catch (_) {
      return false;
    } finally {}
  }
}
