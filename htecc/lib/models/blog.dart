import 'dart:core';

class Blog {
  Blog({
   required this.blogId, required this.field,
   required this.title, required this.content,
   required this.likes, required this.updatedDate, required this.userId,
   required this.username, required this.userAvatar
  });

  String blogId;
  String field;
  String title;
  String content;
  int likes;
  DateTime updatedDate;
  String userId;
  String username;
  String userAvatar;
}