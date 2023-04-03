import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_attendance/state/constants/firebase_collection_name.dart';
import 'package:student_attendance/state/constants/firebase_field_name.dart';
import 'package:student_attendance/state/typedefs.dart';
import 'package:student_attendance/state/users/models/user_info_payload.dart';

class Users {
  const Users();

  Future<bool> saveUserInfo({
    required UserId userId,
    required String name,
    required String? email,
    required String? photoUrl,
    required String studentId,
    required String program,
    required String year,
    required String code,
  }) async {
    try {
      // first check if we have this user's info from before
      final userInfo = await FirebaseFirestore.instance
          .collection(
        FirebaseCollectionName.users,
      )
          .where(
        FirebaseFieldName.uid,
        isEqualTo: userId,
      )
          .limit(1)
          .get();
      if (userInfo.docs.isNotEmpty) {
        // we already have this user's profile, save the new data instead
        await userInfo.docs.first.reference.update({
          FirebaseFieldName.displayName: name,
          FirebaseFieldName.email: email ?? '',
          FirebaseFieldName.photo: photoUrl,
          FirebaseFieldName.studentId: studentId,

        });
        return true;
      }

      final payload = UserInfoPayload(
          userId: userId,
          name: name,
          email: email,
          photoUrl: photoUrl,
          studentId: studentId,
          year: year,
          programCode: program,
          code: code);

      await FirebaseFirestore.instance
          .collection(
        FirebaseCollectionName.users,
      )
          .add(payload);
      return true;
    } catch (_) {
      return false;
    }
  }


  Future<bool> updateUser({
    required String uid,
    required String program,
    required String year,
    required String code,
  }) async {
    try {
      // first check if we have the module from before
      final user = await FirebaseFirestore
          .instance
          .collection(FirebaseCollectionName.users)
          .where(FirebaseFieldName.uid, isEqualTo: uid)
          .limit(1)
          .get();

      if (user.docs.isNotEmpty) {
        // we already have this user, save the new data instead
        await user.docs.first.reference.update({
          FirebaseFieldName.program:program,
          FirebaseFieldName.year:year,
          FirebaseFieldName.code:code
        });
        return true;
      }
      return true;
    }
    catch (_) {
      return false;
    }
  }

}
