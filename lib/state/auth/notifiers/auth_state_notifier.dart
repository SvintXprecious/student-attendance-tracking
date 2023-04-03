import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_attendance/state/auth/backend/authenticator.dart';
import 'package:student_attendance/state/auth/models/auth_result.dart';
import 'package:student_attendance/state/auth/models/auth_state.dart';
import 'package:student_attendance/state/typedefs.dart';
import 'package:student_attendance/state/users/backend/user_info_storage.dart';
import 'package:student_attendance/state/users/logic/user_info.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final _authenticator = const Authenticator();
  final _users = const Users();

  AuthStateNotifier() : super(const AuthState.unknown()) {
    if (_authenticator.isAlreadyLoggedIn) {
      state = AuthState(
        result: AuthResult.success,
        isLoading: false,
        userId: _authenticator.uid,
      );
    }
  }

  Future<void> logOut() async {
    state = state.copiedWithIsLoading(true);
    await _authenticator.logOut();
    state = const AuthState.unknown();
  }

  Future<void> loginWithGoogle() async {
    state = state.copiedWithIsLoading(true);
    final result = await _authenticator.loginWithGoogle();
    final userId = _authenticator.uid;
    if (result == AuthResult.success && userId != null) {
      await saveUserInfo(userId: userId);
    }
    state = AuthState(
      result: result,
      isLoading: false,
      userId: _authenticator.uid,
    );
  }

  Future<bool> updateUser({
    required String uid,
    required String program,
    required String year,
    required String code})
  {
    return _users.updateUser(
        uid: _authenticator.uid!,
        program: program,
        year: year,
        code: code);
  }

  Future<void> saveUserInfo({
    required UserId userId,
  }) {
    if (UserInformation.studentEmailValidation(_authenticator.email!)) {
      return _users.saveUserInfo(
        userId: userId,
        name: _authenticator.displayName,
        email: _authenticator.email,
        photoUrl: _authenticator.photoUrl,
        studentId: UserInformation.generateStudentID(_authenticator.email!),
        year: "",
        code: "",
        program: "",
      );
    } else {
      return _users.saveUserInfo(
        userId: userId,
        name: _authenticator.displayName,
        email: _authenticator.email,
        photoUrl: _authenticator.photoUrl,
        year: "",
        code: "",
        studentId: "",
        program: "",
      );
    }
  }
}
