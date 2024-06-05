import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:htecc/models/blog.dart';
import 'package:htecc/models/user.dart';
import 'package:pocketbase/pocketbase.dart';

class ResourcesService {
  final dio = Dio();
  User user;
  ResourcesService({required this.user});

  String getAvatarUrl() {
    return 'http://10.0.2.2:8090/api/files/users/${user.id}/${user.avatar}';
  }

  String getBlogAuthorAvatarUrl({required Blog blog}) {
    return 'http://10.0.2.2:8090/api/files/users/${blog.userId}/${blog.userAvatar}';
  }

  Future<Blog> postBlog({required String field, required String title, required String content}) async {
    final response = await dio.post(
      'http://10.0.2.2:8090/api/collections/blogs/records',
      data: {
        "field": field,
        "title": title,
        "content": content,
        "likes": 0,
        "user_id": user.id,
        "username": user.username,
        "userAvatar": user.avatar
      }
    );

    return Blog(
      blogId: response.data["id"],
      field: response.data["field"],
      title: response.data["title"],
      content: response.data["content"],
      likes: response.data["likes"],
      updatedDate: _dateTimeFromString(response.data["created"]),
      userId: response.data["user_id"],
      username: user.username,
      userAvatar: user.avatar
    );
  }

  Future<Blog> updateBlog({required String blogId, required String field, required String title, required String content}) async {
    final response = await dio.patch(
        'http://10.0.2.2:8090/api/collections/blogs/records/$blogId',
        data: {
          "field": field,
          "title": title,
          "content": content
        }
    );

    return Blog(
        blogId: response.data["id"],
        field: response.data["field"],
        title: response.data["title"],
        content: response.data["content"],
        likes: response.data["likes"],
        updatedDate: _dateTimeFromString(response.data["created"]),
        userId: response.data["user_id"],
        username: user.username,
        userAvatar: user.avatar
    );
  }

  Future<void> updateLikeBlog({required String blogId, required int likes}) async {
    final response = await dio.patch(
        'http://10.0.2.2:8090/api/collections/blogs/records/$blogId',
        data: {
          "likes": likes
        }
    );
  }

  Future<void> deleteBlog({required String blogId}) async {
    await dio.delete('http://10.0.2.2:8090/api/collections/blogs/records/$blogId');
  }

  Future<List<Blog>> getMyBlogs() async {
    final result = <Blog>[];
    final response = await PocketBase('http://10.0.2.2:8090').collection('blogs').getFullList(expand: "user_id");
    for(final item in response) {
      if(item.getDataValue("user_id") == user.id) {
        result.add(
            Blog(
                blogId: item.id,
                field: item.getDataValue("field"),
                title: item.getDataValue("title"),
                content: item.getDataValue("content"),
                likes: item.getDataValue("likes"),
                updatedDate: _dateTimeFromString(item.created),
                userId: item.getDataValue("user_id"),
                username: item.expand["user_id"]![0].getDataValue('username'),
                userAvatar: item.expand["user_id"]![0].getDataValue('avatar')
            )
        );
      }
    }
    return result.reversed.toList(); // show recent posts prior to old posts
  }

  Future<List<Blog>> getOthersBlogs() async {
    final result = <Blog>[];
    final response = await PocketBase('http://10.0.2.2:8090').collection('blogs').getFullList(expand: "user_id");
    for(final item in response) {
      if(item.getDataValue("user_id") != user.id) {
        result.add(
            Blog(
                blogId: item.id,
                field: item.getDataValue("field"),
                title: item.getDataValue("title"),
                content: item.getDataValue("content"),
                likes: item.getDataValue("likes"),
                updatedDate: _dateTimeFromString(item.created),
                userId: item.getDataValue("user_id"),
                username: item.expand["user_id"]![0].getDataValue('username'),
                userAvatar: item.expand["user_id"]![0].getDataValue('avatar')
            )
        );
      }
    }
    return result.reversed.toList(); // show recent posts prior to old posts
  }

  DateTime _dateTimeFromString(String dateString) {
    DateTime parsedDate = DateTime.parse(dateString);
    return parsedDate;
  }
}