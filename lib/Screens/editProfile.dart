import 'dart:io';

import 'package:blogspot/Core/auth.dart';
import 'package:blogspot/widgets/customeFields.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  String? image;
  String? id;
  EditProfile({super.key, this.image, this.id});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

TextEditingController nameController = TextEditingController();

class _EditProfileState extends State<EditProfile> {
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
    return Scaffold(
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              getImage();
            },
            child: imageFile == null
                ? CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('${widget.image}'))
                : CircleAvatar(
                    radius: 50, backgroundImage: FileImage(imageFile!)),
          ),
          CustomeField(
            controller: nameController,
            fieldName: 'Name',
            maxLine: 1,
          ),
          ElevatedButton(
              onPressed: () {
                Auth().updateProfile(
                    context: context,
                    id: widget.id,
                    name: nameController.text,
                    profilePic: url);
              },
              child: Text('Update Profile'))
        ],
      ),
    );
  }
}
