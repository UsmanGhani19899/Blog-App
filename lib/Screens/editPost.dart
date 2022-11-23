import 'package:blogspot/Core/database.dart';
import 'package:blogspot/Screens/profile.dart';
import 'package:blogspot/widgets/customeFields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditPost extends StatefulWidget {
  String? image;
  // TextEditingController? titleController;
  // TextEditingController? postController;
  String? id;
  EditPost({super.key, this.image, this.id});

  @override
  State<EditPost> createState() => _EditPostState();
}

TextEditingController titleController = TextEditingController();

TextEditingController postController = TextEditingController();

class _EditPostState extends State<EditPost> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: Get.height * 0.4,
                width: Get.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage('${widget.image}'),
                        fit: BoxFit.cover)),
              ),
              SizedBox(
                height: 20,
              ),
              CustomeField(
                fieldName: 'Title',
                controller: titleController,
                maxLine: 1,
              ),
              SizedBox(
                height: 8,
              ),
              CustomeField(
                fieldName: 'Post',
                controller: postController,
                maxLine: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        postController.text.isNotEmpty) {
                      Database().updatePost(
                          id: widget.id,
                          context: context,
                          post: postController.text,
                          title: titleController.text);
                      // Get.off(Profile());
                    } else {}
                  },
                  child: Text('Update'))
            ],
          ),
        ),
      ),
    );
  }
}
