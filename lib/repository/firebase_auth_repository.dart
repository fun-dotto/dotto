import 'package:dotto/importer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final class FirebaseAuthRepository {
  factory FirebaseAuthRepository() {
    return _instance;
  }
  FirebaseAuthRepository._internal();
  static final FirebaseAuthRepository _instance =
      FirebaseAuthRepository._internal();

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return null;
    }
    // Obtain the auth details from the request
    final googleAuth = await googleUser.authentication;

    try {
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'internal-error') {
        return null;
      }
      return null;
    } on Exception {
      return null;
    }
  }

  Future<User?> signIn() async {
    final userCredential = await signInWithGoogle();
    if (userCredential == null) {
      return null;
    }
    final user = userCredential.user;
    if (user == null) {
      return null;
    }
    debugPrint(user.uid);
    if (user.email != null) {
      return user;
    }
    await user.delete();
    return null;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}
