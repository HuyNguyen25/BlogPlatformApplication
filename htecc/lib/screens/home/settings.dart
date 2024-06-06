import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htecc/models/user.dart';
import 'package:htecc/providers/home_state_provider.dart';
import 'package:htecc/providers/signed_in_provider.dart';
import 'package:htecc/services/auth_service.dart';
import 'package:htecc/services/resources_service.dart';
import 'package:htecc/shared_customized_resources/constants.dart';
import 'package:image_picker/image_picker.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});
  @override
  ConsumerState createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {

  String _oldPassword = "", _newPassword = "";

  final _passwordChangeFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final user = ref.read(signedInStateProvider.notifier).state!!;

    Future<void> chooseAndChangeAvatar() async {
      final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(returnedImage == null)
        return;

      final selectedImage = File(returnedImage.path);
      User? result = await AuthService().changeAvatar(userId: user.id, selectedImage: selectedImage);
      ref.read(signedInStateProvider.notifier).changeUser(user: result!!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.black54,
        actions: [
          TextButton.icon(
            icon: Icon(Icons.feed, color: Colors.white),
            label: Text("News Feed", style: TextStyle(color: Colors.white)),
            onPressed: () async {
              ref.read(homeStateProvider.notifier).switchToNewsFeed();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              GestureDetector(
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 93,
                  child: CircleAvatar(radius: 90, backgroundImage: NetworkImage(ResourcesService(user: user).getAvatarUrl())),
                ),
                onTap: () async {
                  await chooseAndChangeAvatar();
                }
              ),
              const SizedBox(height: 16),
              const Text("Profile Picture", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black)),
              Form(
                key: _passwordChangeFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Change your password", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black)),
                    TextFormField(
                      key: UniqueKey(),
                      cursorColor: Colors.black,
                      decoration: inputDecoration.copyWith(hintText: "Old password"),
                      onChanged: (value) => _oldPassword = value,
                      validator: (value) {
                        if(value == null || value.length < 6)
                          return "Password must have at least 6 characters";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: UniqueKey(),
                      cursorColor: Colors.black,
                      decoration: inputDecoration.copyWith(hintText: "New password"),
                      onChanged: (value) => _newPassword = value,
                      validator: (value) {
                        if(value == null || value.length < 6)
                          return "Password must have at least 6 characters";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: Colors.white
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                        ),
                      ),
                      onPressed: () async {
                        if(_passwordChangeFormKey.currentState!.validate()) {
                          final result = await AuthService().changePassword(userId: user.id, oldPassword: _oldPassword, newPassword: _newPassword);
                          print(result!.avatar);
                          if(result == null)
                            _showCanNotChangePasswordDialog();
                          else {
                            await _showChangePasswordSuccessfullyDialog();
                            ref.read(signedInStateProvider.notifier).changeUser(user: result);
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        ),
                      ),
                      icon: Icon(Icons.logout, color: Colors.white,),
                      label: Text("Sign out", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),),
                      onPressed: () async {
                        ref.read(signedInStateProvider.notifier).changeToSignedOut();
                        ref.read(homeStateProvider.notifier).switchToNewsFeed();
                      },
                    )
                  ],
                ),
              )
            ]
          )
        ),
      )
    );
  }

  Future<void> _showCanNotChangePasswordDialog() => showDialog(context: context, barrierDismissible: true, builder: (context) {
    return AlertDialog(
      title: Text("Can not change your password"),
      content: Text("Ensure that the old password is correct"),
    );
  });

  Future<void> _showChangePasswordSuccessfullyDialog() => showDialog(context: context, barrierDismissible: true, builder: (context) {
    return AlertDialog(
      title: Text("Successfully!"),
      content: Text("Your password has already been changed"),
    );
  });
}
