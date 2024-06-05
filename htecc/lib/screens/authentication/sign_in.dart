import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htecc/providers/show_sign_in_provider.dart';
import 'package:htecc/providers/signed_in_provider.dart';
import 'package:htecc/services/auth_service.dart';
import 'package:htecc/shared_customized_resources/constants.dart';
import 'package:htecc/shared_customized_resources/loading.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  String _username = "";
  String _password = "";

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading? loadingScreen : SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Sign In",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold
            )
          ),
          backgroundColor: Colors.black54,
          actions:[
            TextButton.icon(
              onPressed: () { ref.read(showSignInProvider.notifier).showSignUp(); },
              icon: Icon(Icons.app_registration, color: Colors.white),
              label: Text(
                "Sign Up",
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
                colors:[Colors.amber, Colors.red]
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
                        child: Text("Enter your username and password", style: TextStyle(fontSize: 16))
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
                          "Sign In",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                          )
                        ),
          
                        onPressed: () async {
                          if(_formKey.currentState!.validate()){
                            final result = await AuthService().signIn(username: _username, password: _password);
                            if(result != null) {
                              setState(() {
                                loading = true;
                              });
                              ref.read(signedInStateProvider.notifier).changeToSignedIn(user: result);
                            }
                            else {
                              _showCanNotSignInDialog();
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

  Future<void> _showCanNotSignInDialog() {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text("Username or Password is incorrect, please try again"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text("Ensure that you are entering the valid username and password")
            ],
          )
        )
      )
    );
  }
}
