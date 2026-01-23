import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    try {
      final account = await GoogleSignIn.instance.authenticate();
      final credential = GoogleAuthProvider.credential(
        idToken: account.authentication.idToken,
      );
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
    await GoogleSignIn.instance.signOut();
  }
}
