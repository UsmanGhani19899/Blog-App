import 'dart:io';
import 'dart:async';

import 'package:blogspot/Core/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:blogspot/widgets/customeFields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get_core/get_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/passswordField.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

final formkey = GlobalKey<FormState>();
TextEditingController emailController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class _SignUpState extends State<SignUp> {
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
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: Get.height * 0.95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container(
                //   margin: EdgeInsets.symmetric(vertical: 20),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         'SINGIN',
                //         style: GoogleFonts.roboto(
                //             fontWeight: FontWeight.w700,
                //             fontSize: 45,
                //             color: Colors.white),
                //       ),
                //       Text(
                //         'WELCOME BACK',
                //         style: GoogleFonts.roboto(
                //             fontWeight: FontWeight.w300,
                //             fontSize: 25,
                //             color: Colors.grey.shade400),
                //       ),
                //     ],
                //   ),
                // )

                Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'B',
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w900,
                            fontSize: 30,
                            color: HexColor('#68fe9a')),
                      ),
                      Text(
                        'Spot',
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w900,
                            fontSize: 45,
                            color: HexColor('#ffffff')),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: imageFile == null
                      ? Container(
                          height: Get.height * 0.15,
                          width: Get.width * 0.3,
                          color: Colors.grey.shade800.withOpacity(0.25),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 50,
                          ),
                        )
                      : Container(
                          height: Get.height * 0.15,
                          width: Get.width * 0.3,
                          color: Colors.grey.shade800.withOpacity(0.25),
                          child: Image(
                            image: FileImage(imageFile!),
                            fit: BoxFit.cover,
                          )),
                ),
                SizedBox(
                  height: 10,
                ),
                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      CustomeField(
                        maxLine: 1,
                        fieldName: 'Name',
                        controller: nameController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomeField(
                        maxLine: 1,
                        fieldName: 'Email',
                        controller: emailController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomePasswordField(
                        fieldName: 'Password',
                        controller: passwordController,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // Container(
                //   width: MediaQuery.of(context).size.width * 0.8,
                //   alignment: Alignment.centerRight,
                //   child: Text(
                //     'Forgot Password?',
                //     style: GoogleFonts.roboto(
                //         fontWeight: FontWeight.w600,
                //         fontSize: 14,
                //         color: Colors.grey.shade500),
                //   ),
                // ),

                Container(
                  margin: EdgeInsets.symmetric(vertical: 40),
                  width: Get.width * 0.8,
                  height: Get.height * 0.07,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(),
                        backgroundColor: HexColor('#68fe9a')),
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        Auth().signUp(
                          context,
                          emailController.text,
                          passwordController.text,
                          url,
                          nameController,
                        );
                      } else {}
                    },
                    child: Text(
                      'SignUp',
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have account?",
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: HexColor('#ffffff')),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'SignIn',
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          color: HexColor('#68fe9a')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
