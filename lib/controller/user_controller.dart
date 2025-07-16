import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = NotifierProvider<UserNotifier, User?>(UserNotifier.new);

final class UserNotifier extends Notifier<User?> {
  @override
  User? build() {
    return FirebaseAuth.instance.currentUser;
  }

  User? get user => state;

  set user(User? user) {
    state = user;
  }

  void logout() {
    state = null;
  }

  bool get isLoggedin {
    return state != null;
  }
}
