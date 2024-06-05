import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:htecc/models/user.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';


//Service will handle all authentication problems
class AuthService {
  final dio = Dio();
  final pb = PocketBase('http://10.0.2.2:8090');

  //add account to the database and return the id when signing up successfully (or null)
  Future<User?> signUp({
    required String username, required String email, required String password
  }) async {
    if(await isExisting(username: username))
      return null;

    final response = await dio.post(
        'http://10.0.2.2:8090/api/collections/users/records',
        data: {
          "username": username,
          "email": email,
          "password": password
        }
    );
    final file = await getImageFileFromAssets('null_user_avatar.png');
    final result = await pb.collection('users').update(
      response.data["id"],
      files: [
        http.MultipartFile.fromBytes('avatar', await file.readAsBytes(), filename: 'avatar')
      ]
    );

    return User(id: response.data['id'], username: response.data['username'], password: response.data['password'], email: response.data['email'], avatar: result.getDataValue('avatar'));
  }

  //check if they are correct username and password and return the id if sign in successfully (or null)
  Future<User?> signIn({required String username, required String password}) async {
    final data = await pb.collection('users').getFullList();
    final accountList = data;

    for(final item in accountList) {
      if(item.getDataValue("username") == username && item.getDataValue("password")== password)
        return User(id: item.id, username: item.getDataValue('username'), password: item.getDataValue('password'), email: item.getDataValue('email'), avatar: item.getDataValue('avatar'));
    }
    return null;
  }

  Future<User?> changePassword({required String userId, required String oldPassword, required String newPassword}) async {
    final currentUserInfo = await dio.get('http://10.0.2.2:8090/api/collections/users/records/$userId');
    if(currentUserInfo.data['password'] != oldPassword)
      return null;
    final response = await dio.patch('http://10.0.2.2:8090/api/collections/users/records/$userId', data: {"password": newPassword});
    print(response.data['avatar']);
    return User(id: response.data['id'], username: response.data['username'], password: response.data['password'], email: response.data['email'], avatar: response.data['avatar']);
  }

  Future<User?> changeAvatar({required String userId, required File selectedImage}) async {
    final result = await pb.collection('users').update(
      userId,
      files:[
        http.MultipartFile.fromBytes('avatar', await selectedImage.readAsBytes(), filename: 'avatar')
      ]
    );

    return User(id: result.id, username: result.getDataValue('username'), password: result.getDataValue('password'), avatar: result.getDataValue('avatar'), email: result.getDataValue('email'));
  }

  //check if the username already existed
  Future<bool> isExisting({required String username}) async {
    final accountList = await pb.collection('users').getFullList();

    for(final item in accountList)
      if(item.getDataValue('username') == username)
        return true;
    return false;
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('asset/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}