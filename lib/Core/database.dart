import 'package:blogspot/Models/mySaved.dart';
import 'package:blogspot/Models/postModel.dart';
import 'package:blogspot/Models/storyModel.dart';
import 'package:blogspot/Screens/splash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:uuid/uuid.dart';

class Database {
  User? user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  createPostDatabase(
    CreatePostModel postModel,
  ) async {
    await db.collection('Posts').add(postModel.toMap());
  }

  createStoryDatabase(
    StoryPost storyModel,
  ) async {
    await db.collection('Story').add(storyModel.toMap());
  }

  uploadPost({
    String? userPhoto,
    String? userName,
    String? photo,
    String? title,
    String? post,
    BuildContext? context,
  }) async {
    try {
      String postId = Uuid().v1();
      CreatePostModel createPost = CreatePostModel(
          post: post,
          postTitle: title,
          photo: photo,
          uid: user!.uid,
          userName: userName,
          userPhoto: userPhoto,
          likes: [],
          postId: postId);
      await db.collection('Posts').doc(postId).set(createPost.toMap());
    } catch (e) {
      ScaffoldMessenger.of(context!)
          .showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  savePost({
    String? id,
    String? userPhoto,
    String? userName,
    String? photo,
    String? title,
    String? post,
    BuildContext? context,
  }) async {
    try {
      String postId = Uuid().v1();
      SavePost mySave = SavePost(
        post: post,
        postTitle: title,
        photo: photo,
        uid: user!.uid,
        userName: userName,
        userPhoto: userPhoto,
        likes: [],
        postId: postId,
      );
      await db
          .collection('Users')
          .doc(id)
          .collection("MySaved")
          .doc(postId)
          .set(mySave.toMap());
    } catch (e) {
      ScaffoldMessenger.of(context!)
          .showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  updatePost(
      {BuildContext? context, String? title, String? post, String? id}) async {
    try {
      await db
          .collection('Posts')
          .doc(id)
          .update({'postTitle': title, 'post': post});
    } catch (e) {
      ScaffoldMessenger.of(context!)
          .showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  deletePost(
    String? id,
  ) async {
    await db.collection('Posts').doc(id).delete();
  }

  // uploadStory({
  //   String? userPhoto,
  //   String? userName,
  //   String? story,
  //   BuildContext? context,
  // }) async {
  //   try {
  //     String storyId = Uuid().v1();
  //     StoryPost storyPost = StoryPost(
  //         likes: [],
  //         seenBy: [],
  //         postId: storyId,
  //         story: story,
  //         uid: user!.uid,
  //         userName: userName,
  //         userPhoto: userPhoto);
  //     await db.collection('Story').doc(storyId).set(storyPost.toMap());
  //   } catch (e) {
  //     ScaffoldMessenger.of(context!)
  //         .showSnackBar(SnackBar(content: Text('$e')));
  //   }
  // }

  searchResult(String? querySearch, context) {
    return FirebaseFirestore.instance
        .collection("Posts")
        .where("postTitle", isLessThanOrEqualTo: querySearch)
        .get();
  }

  uploadStory({
    String? userPhoto,
    String? userName,
    String? story,
    String? id,
    BuildContext? context,
  }) async {
    try {
      String storyId = Uuid().v1();
      StoryPost storyPost = StoryPost(
          likes: [],
          seenBy: [],
          postId: storyId,
          story: story,
          uid: user!.uid,
          userName: userName,
          userPhoto: userPhoto);
      await db
          .collection('Users')
          .doc(id)
          .collection('Story')
          .add(storyPost.toMap());
    } catch (e) {
      ScaffoldMessenger.of(context!)
          .showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        db.collection('Posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        db.collection('Posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> postComment(BuildContext context, String postId, String text,
      String uid, String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        db
            .collection('Posts')
            .doc(postId)
            .collection('Comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        }).then((value) => Navigator.pop(context));

        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Future<String> savePost(String postId, String uid, List saved) async {
  //   String res = 'error';
  //   try {
  //     if (saved.contains(uid)) {
  //       db.collection('Users').doc(postId).update({
  //         'savedPosts': FieldValue.arrayRemove([uid])
  //       });
  //     } else {
  //       db.collection('Users').doc(postId).update({
  //         'savedPosts': FieldValue.arrayUnion([uid])
  //       });
  //     }
  //     res = '  done';
  //   } catch (e) {
  //     res = e.toString();
  //   }
  //   return res;
  // }

  Future<String> followOther(String userId, String uid, List followers) async {
    String res = "Some error occurred";
    try {
      if (followers.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        db.collection('Users').doc(userId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        db.collection('Users').doc(userId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
