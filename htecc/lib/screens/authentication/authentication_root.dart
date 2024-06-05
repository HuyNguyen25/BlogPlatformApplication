import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htecc/providers/show_sign_in_provider.dart';
import 'package:htecc/screens/authentication/sign_in.dart';
import 'package:htecc/screens/authentication/sign_up.dart';

class AuthenticationRoot extends ConsumerWidget {
  const AuthenticationRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showSignIn = ref.watch(showSignInProvider);
    if(showSignIn)
      return SignInScreen();
    return SignUpScreen();
  }
}
