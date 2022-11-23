import 'dart:io';

import 'package:blogspot/Core/database.dart';
import 'package:blogspot/widgets/customeFields.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../Core/userProvider.dart';
import '../Models/userModel.dart';

class CreatePost extends StatefulWidget {
  String? blogUser;
  String? userImage;

  CreatePost({super.key, this.blogUser, this.userImage});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

final formKey = GlobalKey<FormState>();
TextEditingController titleController = TextEditingController();
TextEditingController postController = TextEditingController();

class _CreatePostState extends State<CreatePost> {
  FirebaseStorage storage = FirebaseStorage.instance;
  var url = '';
  File? imageFile;
  var selectedImagePath = '';
  var selectedImageSize = '';
  Future getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        selectedImagePath = pickedFile.path;
        selectedImageSize =
            ((File(selectedImagePath)).lengthSync() / 1024 / 1024)
                    .toStringAsFixed(2) +
                " Mb";
      });

      uploadImageToFirebase();
    } else {
      Get.snackbar("Error !", "No Photo Selected",
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white);
    }
  }

  Future uploadImageToFirebase() async {
    // showLoadingIndicator();
    Reference firebaseStorageRef =
        storage.ref().child('uploads/${selectedImagePath}');
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile!);
    uploadTask.then((res) async {
      url = await res.ref.getDownloadURL();
      print(url);

      //hideLoadingIndicator();
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserModel userProvider = Provider.of<UserProvider>(context).getUser;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                getImage();
              },
              child: imageFile == null
                  ? Container(
                      margin: EdgeInsets.only(
                          top: 20, left: 12, right: 12, bottom: 20),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      height: Get.height * 0.3,
                      width: Get.width,
                      child: Icon(
                        FeatherIcons.plus,
                        color: Colors.white,
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(
                          top: 20, left: 12, right: 12, bottom: 20),
                      height: Get.height * 0.3,
                      width: Get.width,
                      child: Image(
                        image: FileImage(imageFile!),
                        fit: BoxFit.cover,
                      )),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  CustomeField(
                    maxLine: 1,
                    fieldName: 'Title',
                    controller: titleController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomeField(
                    maxLine: 15,
                    fieldName: 'Post',
                    controller: postController,
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Database().uploadPost(
                        photo: url,
                        post: postController.text,
                        title: titleController.text,
                        userName: widget.blogUser,
                        userPhoto: widget.userImage,
                        context: context);
                  } else {}
                },
                child: Text('Post'))
          ],
        ),
      ),
    );
  }
}
