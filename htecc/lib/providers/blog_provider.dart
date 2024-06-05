import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htecc/models/blog.dart';

class BlogNotifier extends Notifier<Blog?> {
  @override
  Blog? build() {
    // TODO: implement build
    return null;
  }

  void updateBlog(Blog blog) {
    state = blog;
  }
}

final blogProvider = NotifierProvider<BlogNotifier, Blog?>(
    () => BlogNotifier()
);