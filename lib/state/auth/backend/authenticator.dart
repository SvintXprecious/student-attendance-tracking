import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student_attendance/state/auth/constants/constants.dart';
import 'package:student_attendance/state/auth/models/auth_result.dart';
import 'package:student_attendance/state/typedefs.dart';



class Authenticator {
  const Authenticator();

  // getters

  bool get isAlreadyLoggedIn => uid != null;
  UserId? get uid => FirebaseAuth.instance.currentUser?.uid;
  String get displayName => FirebaseAuth.instance.currentUser?.displayName?? '';
  String? get email => FirebaseAuth.instance.currentUser?.email;
  String? get photoUrl => FirebaseAuth.instance.currentUser?.photoURL;

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }


  Future<AuthResult> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        Constants.emailScope,
      ],
    );
    final signInAccount = await googleSignIn.signIn();
    if (signInAccount == null) {
      return AuthResult.aborted;
    }

    final googleAuth = await signInAccount.authentication;
    final oauthCredentials = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(
        oauthCredentials,
      );
      return AuthResult.success;
    } catch (e) {
      return AuthResult.failure;
    }
  }
}
