import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htecc/models/user.dart';

class SignInNotifier extends Notifier<User?> {
  @override
  User? build() {
    // TODO: implement build
    return null;
  }

  void changeToSignedIn({required User user}) {
    state = user;
  }

  void changeToSignedOut() {
    state = null;
  }

  void changeUser({required User user}) {
    state = user;
  }
}

final signedInStateProvider = NotifierProvider<SignInNotifier, User?>(
    () => SignInNotifier()
);