import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowSignIn extends Notifier<bool> {
  @override
  bool build() {
    // TODO: implement build
    return true;
  }

  void showSignIn() {
    state = true;
  }

  void showSignUp() {
    state = false;
  }
}

final showSignInProvider = NotifierProvider<ShowSignIn, bool>(
    () => ShowSignIn()
);