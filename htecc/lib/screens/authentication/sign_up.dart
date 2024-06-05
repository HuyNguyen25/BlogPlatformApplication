import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htecc/providers/show_sign_in_provider.dart';
import 'package:htecc/providers/signed_in_provider.dart';
import 'package:htecc/services/auth_service.dart';
import 'package:htecc/shared_customized_resources/constants.dart';
import 'package:htecc/shared_customized_resources/loading.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  String _username = "";
  String _password = "";
  String _email = "";

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading? loadingScreen : SafeArea(
      child: Scaffold(
          appBar: AppBar(
              title: Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                  )
              ),
              backgroundColor: Colors.black54,
              actions:[
                TextButton.icon(
                  onPressed: () { ref.read(showSignInProvider.notifier).showSignIn(); },
                  icon: Icon(Icons.login, color: Colors.white),
                  label: Text(
                      "Sign In",
                      style: TextStyle(
                          color:Colors.white
                      )
                  ),
                )
              ]
          ),
          body: SizedBox.expand(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.amber,
                    Colors.red
                  ]
                )
              ),
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24, horizontal: 36),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Center(
                                    child: Text(
                                        "Htecc",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 45,
                                        )
                                    )
                                )
                            ),
                            Center(
                                child: Text("Enter your username, email ,and password to create an account", style: TextStyle(fontSize: 14), textAlign: TextAlign.center,)
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              cursorColor: Colors.black,
                              decoration: inputDecoration.copyWith(hintText: "Username"),
                              onChanged: (value) => setState(() {
                                _username = value;
                              }),
                              validator: (value) {
                                if(value == null || value.length < 6)
                                  return "Username must have at least 6 characters";
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              cursorColor: Colors.black,
                              decoration: inputDecoration.copyWith(hintText: "Email"),
                              onChanged: (value) => setState(() {
                                _email = value;
                              }),
                              validator: (value) {
                                if(value == null || !_isValidEmail(value))
                                  return "Please enter a valid email";
                                return null;
                              },
                            ),
                            SizedBox(height: 16,),
                            TextFormField(
                                cursorColor: Colors.black,
                                decoration: inputDecoration.copyWith(hintText: "Password"),
                                onChanged: (value) => setState(() {
                                  _password = value;
                                }),
                                obscureText: true,
                                validator: (value) {
                                  if(value == null || value.length < 6)
                                    return "Password must have at least 6 characters";
                                  return null;
                                }
                            ),
                            SizedBox(height: 16,),
                            TextButton(
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0)
                                  ),
                                  backgroundColor: Colors.black
                              ),
                              child: Text(
                                  "Create an account",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white
                                  )
                              ),

                              onPressed: () async {
                                if(_formKey.currentState!.validate()){
                                  final result = await AuthService().signUp(username: _username, email: _email, password: _password);
                                  if(result != null) {
                                    setState(() {
                                      loading = true;
                                    });
                                    ref.read(signedInStateProvider.notifier).changeToSignedIn(user: result);
                                  }
                                  else {
                                    _showAccountAlreadyExistsDialog();
                                  }
                                }
                              },
                            )
                          ]
                      ),
                    ),
                  )
              ),
            ),
          )
      ),
    );
  }

  Future<void> _showAccountAlreadyExistsDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Can not create an account"),
            content: SingleChildScrollView (
              child: Column(
                children: [
                  Text("Username already exists, please enter an other username")
                ],
              )
            )
          );
        },
        barrierDismissible: true
    );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }
}
