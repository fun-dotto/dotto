import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

final class FirebaseAuthRepository {
  factory FirebaseAuthRepository() {
    return _instance;
  }
  FirebaseAuthRepository._internal();
  static final FirebaseAuthRepository _instance = FirebaseAuthRepository._internal();

  Future<UserCredential?> _authenticate() async {
    final account = await GoogleSignIn.instance.authenticate();
    final credential = GoogleAuthProvider.credential(idToken: account.authentication.idToken);
    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<User?> signIn() async {
    try {
      final credential = await _authenticate();
      final user = credential?.user;
      if (user?.email == null) {
        await user?.delete();
        return null;
      }
      return user;
    } on Exception catch (e) {
      debugPrint('Error during signing-in with Google: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn.instance.signOut();
  }
}
