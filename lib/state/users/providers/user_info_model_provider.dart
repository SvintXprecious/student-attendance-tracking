import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_attendance/state/auth/models/auth_state.dart';
import 'package:student_attendance/state/auth/notifiers/auth_state_notifier.dart';
import 'package:student_attendance/state/constants/firebase_collection_name.dart';
import 'package:student_attendance/state/constants/firebase_field_name.dart';
import 'package:student_attendance/state/users/models/user.dart';

final userInfoModelProvider =StreamProvider
    .autoDispose
    .family<User,StateNotifierProvider<AuthStateNotifier, AuthState>>(
      (ref,authState) {
        final controller = StreamController<User>();
        final uid=ref.watch(authState).userId!;

        final sub = FirebaseFirestore.instance
            .collection(
          FirebaseCollectionName.users,
        )
            .where(
          FirebaseFieldName.uid,isEqualTo: uid,)
            .limit(1)
            .snapshots()
            .listen((snapshot) {
              if (snapshot.docs.isNotEmpty) {
                final doc = snapshot.docs.first;
                final json = doc.data();
                final userInfoModel = User.fromJson(
                  json, userId: uid,
                );
                controller.add(userInfoModel);
              }

            });

        ref.onDispose(() {
          sub.cancel();
          controller.close();
        });

        return controller.stream;
  },
);
