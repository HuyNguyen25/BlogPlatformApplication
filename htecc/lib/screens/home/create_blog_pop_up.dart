import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htecc/models/blog.dart';
import 'package:htecc/models/user.dart';
import 'package:htecc/services/resources_service.dart';
import 'package:htecc/shared_customized_resources/constants.dart';

class CreateBlogPopUp extends ConsumerStatefulWidget {
  const CreateBlogPopUp({super.key, required this.user});
  final User user;
  @override
  ConsumerState createState() => _CreateBlogPopUpState();
}
const availableFields = ["UI/UX", "Data Science", "AI","Mobile Development", "DevOps","Web Development" ,"Cybersecurity","IoT","Others"];

class _CreateBlogPopUpState extends ConsumerState<CreateBlogPopUp> {
  String _field = availableFields.first;
  String _title = "";
  String _content = "";
  final _formKey = GlobalKey<FormState>();
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.brown.shade200,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Form(
        key: _formKey,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            controller: _controller,
            child: Padding(
              padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: MediaQuery.of(context).viewInsets.bottom + 5.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("New Post", style: popUpTextStyle.copyWith(fontSize: 28, fontWeight: FontWeight.bold)),
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Field", style: popUpTextStyle),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.black26),
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                    ),
                    child: DropdownButton(
                      style: TextStyle(
                        color: Colors.black
                      ),
                      value: _field,
                      items: availableFields.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) { setState(() {
                        _field = value!;
                      }); },

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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding:EdgeInsets.only(right: 15),
                        child: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red.shade200,
                            shape: RoundedRectangleBorder(side: BorderSide(width: 1.0, color: Colors.black), borderRadius: BorderRadius.circular(15))
                          ),
                          icon: Icon(Icons.send),
                          onPressed: () async {
                           Blog blog = await ResourcesService(user: widget.user)
                               .postBlog(field: _field, title: _title, content: _content);
                           Navigator.of(context).pop();
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
      );
  }
}
