import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:student_attendance/state/constants/firebase_collection_name.dart';
import 'package:student_attendance/state/sessions/model/session_key.dart';
import 'package:student_attendance/state/sessions/model/session_payload.dart';

part 'sessions.g.dart';

@riverpod
class Sessions extends _$Sessions {
  @override
  FutureOr<bool> build() {
    return false;
  }

  Future<bool> addSession({
    required String title,
    required String description,
    required String room,
    required String date,
    required String startTime,
    required String endTime,
    required String sessionID,
    required Map<String, dynamic> lecturer,
    required Map<String, dynamic> module,
    required List<dynamic> programCodes,
    required List<Map<String, dynamic>> attendees,
  }) async {
    var firebaseFirestore =
        FirebaseFirestore.instance.collection(FirebaseCollectionName.sessions);
    var docRef = firebaseFirestore.doc();

    final payload = SessionPayload(
      title: title,
      description: description,
      room: room,
      date: date,
      startTime: startTime,
      endTime: endTime,
      sessionID: sessionID,
      lecturer: lecturer,
      module: module,
      programCodes: programCodes,
      attendees: attendees,
    );

    try {
      // await docRef.set(payload);
      await firebaseFirestore.add(payload);
      return true;
    } catch (_) {
      return false;
    } finally {}
  }

  Future<bool> addClockIn({
    required String sessionID,
    required int studentIndex,
    required List<Map<String, dynamic>> attendees,
  }) async {
    try {
      // first check if we have the session
      final session = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.sessions)
          .where(SessionKey.sessionID, isEqualTo: sessionID)
          .limit(1)
          .get();

      if (session.docs.isNotEmpty) {
        // we already have this session, save the new data instead
        var data = List<Map<String, dynamic>>.from(attendees);
        data[studentIndex]['clock_in'] = DateTime.now().toString();
        await session.docs.first.reference.update({SessionKey.attendees: data});
        return true;
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> addClockOut({
    required String sessionID,
    required int studentIndex,
    required List<Map<String, dynamic>> attendees,
  }) async {
    try {
      // first check if we have the session
      final session = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.sessions)
          .where(SessionKey.sessionID, isEqualTo: sessionID)
          .limit(1)
          .get();

      if (session.docs.isNotEmpty) {
        // we already have this session, save the new data instead
        var data = List<Map<String, dynamic>>.from(attendees);
        data[studentIndex]['clock_out'] = DateTime.now().toString();
        await session.docs.first.reference.update({SessionKey.attendees: data});
        return true;
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteSession({
    required String documentID,
  }) async {
    try {
      final postInCollection = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.sessions)
          .where(
            SessionKey.sessionID,
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
