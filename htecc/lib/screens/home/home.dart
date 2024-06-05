import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htecc/models/home_state.dart';
import 'package:htecc/models/user.dart';
import 'package:htecc/providers/blogs_list_provider.dart';
import 'package:htecc/providers/home_state_provider.dart';
import 'package:htecc/providers/signed_in_provider.dart';
import 'package:htecc/screens/home/blog_view.dart';
import 'package:htecc/screens/home/create_blog_pop_up.dart';
import 'package:htecc/screens/home/my_blogs.dart';
import 'package:htecc/screens/home/settings.dart';
import 'package:htecc/services/resources_service.dart';
import 'package:htecc/shared_customized_resources/loading.dart';
import 'package:pocketbase/pocketbase.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});
  @override
  ConsumerState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {

  @override
  Widget build(BuildContext context) {
    final user = ref.read(signedInStateProvider.notifier).state!!;
    final homeScreenState = ref.watch(homeStateProvider);
    final blogsList = ref.watch(blogsListProvider);
    PocketBase('http://10.0.2.2:8090').collection('blogs').subscribe('*', (e) async {
      await ref.read(blogsListProvider.notifier).updateBlogs();
    });
    switch(homeScreenState) {
      case HomeState.NEWS_FEED:
        return blogsList.value == null ? loadingScreen : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                    "News Feed",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white
                    )
                ),
                leading: Center(
                  child: GestureDetector(
                    child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          radius: 19,
                          backgroundImage: NetworkImage(ResourcesService(user: user).getAvatarUrl()),
                        )
                    ),
                    onTap: () => ref.read(homeStateProvider.notifier).switchToMyBlogs(),
                  )
                ),
                backgroundColor: Colors.black54,
                actions: [
                  TextButton.icon(
                      icon: Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                      label: Text("Settings", style: TextStyle(color: Colors.white)),
                      onPressed:() async {
                        ref.read(homeStateProvider.notifier).switchToSettings();
                      }
                  )
                ],
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: ListView.builder(
                itemCount: blogsList.value!.length,
                itemBuilder: (BuildContext context, int index) {
                  return BlogCard(
                    blog: blogsList.value![index]
                  );
                },
                ),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.grey,
                child: Icon(Icons.add, color: Colors.white,),
                onPressed: () async { _showCreateBlogPopUp(); }
              ),
            )
        );
      case HomeState.SETTINGS:
        return Settings(key: UniqueKey());
      case HomeState.MY_BLOG_VIEW:
        return MyBlogView();
      case HomeState.OTHER_BLOG_VIEW:
        return OtherBlogView();
      case HomeState.MY_BLOGS:
        return MyBlogs();
    }
  }

  Future _showCreateBlogPopUp() => showDialog(
    context: context,
    builder: (context) => Padding(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Align(alignment: Alignment.center, child:CreateBlogPopUp()),
    ),
    barrierDismissible: true
  );
}
