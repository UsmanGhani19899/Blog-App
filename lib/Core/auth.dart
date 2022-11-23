import 'package:blogspot/Models/userModel.dart';
import 'package:blogspot/Screens/bottombar.dart';
import 'package:blogspot/Screens/home.dart';
import 'package:blogspot/Screens/signIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class Auth {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<void> createDatabase(UserModel user, User firestoreUser) async {
    await _db.collection("Users").doc('${firestoreUser.uid}').set(user.toMap());
  }

  // get user details
  Future<UserModel> getUserDetails() async {
    User currentUser = auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _db.collection('Users').doc(currentUser.uid).get();

    return UserModel.fromMap(documentSnapshot);
  }

  signUp(
    BuildContext context,
    String email,
    String password,
    String url,
    // String uid,
    TextEditingController name,
  ) async {
    String userId = Uuid().v1();
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        UserModel userModel = UserModel(
            email: value.user!.email,
            name: name.text,
            uid: value.user!.uid,
            photo: url,
            savedPosts: [],
            followers: [],
            followings: [],
            userId: userId);
        await createDatabase(userModel, value.user!)
            .then((value) => Get.off(BottomBar()));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  signIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => Get.off(BottomBar()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  forgotPassword(
      BuildContext context, TextEditingController? controller) async {
    await auth.sendPasswordResetEmail(email: controller!.text);
  }

  logout() async {
    await auth.signOut().then((value) => Get.off(SignIn()));
  }

  updateProfile(
      {BuildContext? context,
      String? name,
      String? profilePic,
      String? id}) async {
    try {
      await db
          .collection('Users')
          .doc(id)
          .update({'name': name, 'photo': profilePic});
    } catch (e) {
      ScaffoldMessenger.of(context!)
          .showSnackBar(SnackBar(content: Text('$e')));
    }
  }
}
