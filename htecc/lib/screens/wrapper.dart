import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htecc/providers/signed_in_provider.dart';
import 'package:htecc/screens/authentication/authentication_root.dart';
import 'package:htecc/screens/home/home.dart';

class Wrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final user = ref.watch(signedInStateProvider);

    if(user == null)
      return AuthenticationRoot();
    return Home();
  }

}
