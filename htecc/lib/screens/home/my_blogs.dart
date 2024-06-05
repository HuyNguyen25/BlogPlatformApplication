import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htecc/models/blog.dart';
import 'package:htecc/providers/blog_provider.dart';
import 'package:htecc/providers/home_state_provider.dart';
import 'package:htecc/providers/signed_in_provider.dart';
import 'package:htecc/services/resources_service.dart';
import 'package:htecc/shared_customized_resources/loading.dart';

class MyBlogs extends ConsumerWidget {
  const MyBlogs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(signedInStateProvider.notifier).state!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Blogs",
          style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.black54,
        actions: [
          TextButton.icon(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            label: Text("Back", style: TextStyle(color: Colors.white)),
            onPressed: () async {
              ref.read(homeStateProvider.notifier).switchToNewsFeed();
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: ResourcesService(user: user).getMyBlogs(),
        builder: (context, projectSnap) {
          if(projectSnap.data == null) {
            return loadingScreen;
          }

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: ListView.builder(
              itemCount: projectSnap.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return BlogCard(
                  blog: projectSnap.data![index]
                );
              },

            ),
          );
        },

      )
    );
  }
}

class BlogCard extends ConsumerWidget {
  const BlogCard({super.key, required this.blog});

  final Blog blog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(signedInStateProvider.notifier).state!;

    return GestureDetector(
      onTap: () {
        ref.read(blogProvider.notifier).updateBlog(blog);
        ref.read(homeStateProvider.notifier).switchToBlogView();
      },
      child: Card(
        elevation: 10.0,
        color: Colors.lightBlueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.black,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundImage: NetworkImage(ResourcesService(user: user).getBlogAuthorAvatarUrl(blog: blog)),
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Expanded(
                      flex: 1,
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        blog.username,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.black
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        blog.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.black
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        blog.updatedDate.toString(),
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10.0,),
                Text(
                  "Field: ${blog.field}",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                      color: Colors.black
                  ),
                ),
                SizedBox(height: 10.0,),
                Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.redAccent,),
                    SizedBox(width: 15.0,),
                    Text(
                      blog.likes.toString(),
                      style: TextStyle(
                        color: Colors.blue
                      ),
                    )
                  ],
                )
              ],
          ),
        ),
      )
    );
  }
}
