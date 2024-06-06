import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htecc/models/blog.dart';
import 'package:htecc/providers/signed_in_provider.dart';
import 'package:htecc/services/resources_service.dart';

class BlogsListNotifier extends AsyncNotifier<List<Blog>> {
  @override
  FutureOr<List<Blog>> build() async {
    final user = ref.watch(signedInStateProvider);
    if (user == null)
        return [];
    return await ResourcesService(user: user!).getOthersBlogs();
  }

  Future<void> updateBlogs() async {
    final user = ref.read(signedInStateProvider.notifier).state;
    if (user == null)
      return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ResourcesService(user: user!).getOthersBlogs());
  }
}

final blogsListProvider = AsyncNotifierProvider<BlogsListNotifier, List<Blog>> (
    () => BlogsListNotifier()
);