import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htecc/models/blog.dart';
import 'package:htecc/providers/blog_provider.dart';
import 'package:htecc/providers/home_state_provider.dart';
import 'package:htecc/providers/signed_in_provider.dart';
import 'package:htecc/screens/home/create_blog_pop_up.dart';
import 'package:htecc/services/resources_service.dart';
import 'package:htecc/shared_customized_resources/constants.dart';
import 'package:htecc/shared_customized_resources/loading.dart';

class MyBlogView extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _MyBlogViewState();
  }
}

class _MyBlogViewState extends ConsumerState {
  late String _field;
  late String _title;
  late String _content;
  late int _likes;
  bool _readOnly = true;
  bool _init = true;


  final _formKey = GlobalKey<FormState>();
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    final blog = ref.watch(blogProvider);
    final user = ref.read(signedInStateProvider);

    //init states
    if(_init) {
      _field = blog!.field;
      _title = blog!.title;
      _content = blog!.content;
      _likes = blog!.likes;
      _init = false;
    }

    Future<void> _showDeleteConfirmationDialog() {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Do you want to delete this blog?"),
              actions: [
                TextButton(
                  onPressed: () async {
                    await ResourcesService(user: user!).deleteBlog(blogId: blog!.blogId);
                    Navigator.of(context).pop();
                    ref.read(homeStateProvider.notifier).switchToMyBlogs();
                  },
                  child: Text("Yes")
                ),
                TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: Text("No")
                ),
              ],
            );
          }
      );
    }

    if(blog == null)
      return loadingScreen;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Blog View",
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
              ref.read(homeStateProvider.notifier).switchToMyBlogs();
            },
          )
        ],
      ),
      body: GestureDetector(
        onLongPress: () => setState(() {
          _readOnly = !_readOnly;
        }),
        child: Card(
            color: Colors.brown.shade200,
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  controller: _controller,
                  child: Padding(
                    padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: MediaQuery.of(context).viewInsets.bottom + 5.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () async {await _showDeleteConfirmationDialog();},
                              icon: const Icon(Icons.delete, color: Colors.red)
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Field", style: popUpTextStyle),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.0, color: Colors.black26),
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white,
                          ),
                          child: DropdownButton(
                            style: const TextStyle(
                                color: Colors.black
                            ),
                            value: _field,
                            items: availableFields.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: _readOnly? null : (String? value) {
                              setState(() {
                                _field = value!;
                              });
                             },

                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Title", style: popUpTextStyle),
                          ],
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          readOnly: _readOnly,
                          initialValue: _title,
                          cursorColor: Colors.black,
                          decoration: inputDecoration.copyWith(hintText: "Title"),
                          onChanged: (value) async {
                            setState(() {
                              _title = value;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Content", style: popUpTextStyle),
                          ],
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          readOnly: _readOnly,
                          initialValue: _content,
                          maxLines: null,
                          cursorColor: Colors.black,
                          decoration: inputDecoration.copyWith(hintText: "Write something..."),
                          onChanged: (value) async {
                            setState(() {
                              _content = value;
                              _controller.animateTo(_controller.position.maxScrollExtent, duration: Duration(microseconds: 800), curve: Curves.bounceOut);
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Row(
                                  children: [
                                    const Icon(Icons.favorite, color: Colors.redAccent,),
                                    const SizedBox(width: 15.0,),
                                    Text(
                                      _likes.toString(),
                                      style: const TextStyle(
                                          color: Colors.blue
                                      ),
                                    )
                                  ],
                                )
                            ),
                            Padding(
                                padding:const EdgeInsets.only(right: 15),
                                child: IconButton(
                                  style: IconButton.styleFrom(
                                      backgroundColor: Colors.red.shade200,
                                      shape: RoundedRectangleBorder(side: BorderSide(width: 1.0, color: Colors.black), borderRadius: BorderRadius.circular(15))
                                  ),
                                  icon: const Icon(Icons.send),
                                  onPressed: _readOnly ? null : () async {
                                    Blog result = await ResourcesService(user: user!).updateBlog(blogId: blog.blogId, field: _field, title: _title, content: _content);
                                    ref.read(blogProvider.notifier).updateBlog(result);
                                    setState(() {
                                      _readOnly = true;
                                    });
                                  },
                                )
                            )
                          ],
                        )
                      ],
                    ),
                  )
              ),
            )
        ),
      ),
    );
  }

}

class OtherBlogView extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _OtherBlogViewState();
  }
}

class _OtherBlogViewState extends ConsumerState {
  late String _field;
  late String _title;
  late String _content;
  late int _likes;
  bool _readOnly = true;
  bool _init = true;

  final _formKey = GlobalKey<FormState>();
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    final blog = ref.watch(blogProvider);
    final user = ref.read(signedInStateProvider);

    //init states
    if(_init){
      _field = blog!.field;
      _title = blog!.title;
      _content = blog!.content;
      _likes = blog!.likes;
      _init = false;
    }

    if(blog == null)
      return loadingScreen;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Blog View",
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
      body: GestureDetector(
        onLongPress: () => setState(() {
          _readOnly = !_readOnly;
        }),
        child: Card(
            color: Colors.brown.shade200,
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  controller: _controller,
                  child: Padding(
                    padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: MediaQuery.of(context).viewInsets.bottom + 5.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Field", style: popUpTextStyle),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.0, color: Colors.black26),
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white,
                          ),
                          child: DropdownButton(
                            style: const TextStyle(
                                color: Colors.black
                            ),
                            value: _field,
                            items: availableFields.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: null,

                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Title", style: popUpTextStyle),
                          ],
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          readOnly: _readOnly,
                          initialValue: _title,
                          cursorColor: Colors.black,
                          decoration: inputDecoration.copyWith(hintText: "Title"),
                          onChanged: null,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Content", style: popUpTextStyle),
                          ],
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          readOnly: _readOnly,
                          initialValue: _content,
                          maxLines: null,
                          cursorColor: Colors.black,
                          decoration: inputDecoration.copyWith(hintText: "Write something..."),
                          onChanged: null,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        setState(() {
                                          _likes++;
                                        });
                                        await ResourcesService(user: user!).updateLikeBlog(blogId: blog.blogId, likes: _likes);
                                      },
                                      icon: const Icon(Icons.favorite, color: Colors.redAccent,)
                                    ),
                                    const SizedBox(width: 15.0,),
                                    Text(
                                      _likes.toString(),
                                      style: const TextStyle(
                                          color: Colors.blue
                                      ),
                                    )
                                  ],
                                )
                            ),
                          ],
                        )
                      ],
                    ),
                  )
              ),
            )
        ),
      ),
    );
  }

}