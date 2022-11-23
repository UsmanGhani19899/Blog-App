import 'package:blogspot/Core/auth.dart';
import 'package:blogspot/Core/database.dart';
import 'package:blogspot/Models/postModel.dart';
import 'package:blogspot/Models/userModel.dart';
import 'package:blogspot/Screens/cameraScreen.dart';
import 'package:blogspot/Screens/inbox.dart';
import 'package:blogspot/Screens/postDeatil.dart';
import 'package:blogspot/Screens/search.dart';
import 'package:blogspot/Screens/splash.dart';
import 'package:blogspot/Screens/storyDetail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../Core/userProvider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

// final firstCamera = cameras.first;
User? userLike = FirebaseAuth.instance.currentUser;

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final UserModel userProvider = Provider.of<UserProvider>(context).getUser;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            // centerTitle: true,
            toolbarHeight: 65,
            backgroundColor: Colors.black,
            // leading: StreamBuilder<QuerySnapshot>(
            //     stream: FirebaseFirestore.instance
            //         .collection("Users")
            //         .where('uid',
            //             isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            //         .snapshots(),
            //     builder: (context, snapshot) {
            //       return ListView.builder(
            //           itemCount: snapshot.data!.docs.length,
            //           itemBuilder: (context, index) {
            //             Map<String, dynamic> userStory =
            //                 snapshot.data!.docs[index].data()
            //                     as Map<String, dynamic>;
            //             return GestureDetector(
            //                 onTap: () async {
            //                   await availableCameras()
            //                       .then((value) => Get.to(TakePictureScreen(
            //                             id: snapshot.data!.docs[index].id,
            //                             camera: value.first,
            //                             userName: userStory['name'],
            //                             userPhoto: userStory['photo'],
            //                           )));
            //                 },
            //                 child: Icon(
            //                   FeatherIcons.camera,
            //                   color: Colors.white,
            //                 ));
            //           });
            //     }),

            title: RichText(
              // mainAxisAlignment: MainAxisAlignment.center,
              text: TextSpan(children: [
                TextSpan(
                  text: 'B',
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: HexColor('#68fe9a')),
                ),
                TextSpan(
                  text: 'Spot',
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w900,
                      fontSize: 25,
                      color: HexColor('#ffffff')),
                )
              ]),
            ),
            actions: [
              Container(
                  margin: EdgeInsets.only(right: 10),
                  child: GestureDetector(
                      onTap: () {
                        Get.to(SearchScreen());
                      },
                      child: Icon(FeatherIcons.search)))
            ],
          ),
          body: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('Posts').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                        // physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> posts =
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;
                          return GestureDetector(
                            onTap: () {
                              Get.to(PostDetail(
                                image: '${posts['photo']}',
                                postDes: '${posts['post']}',
                                postName: '${posts['postTitle']}',
                                postUser: '${posts['userName']}',
                                postUserPic: '${posts['userPhoto']}',
                                postUid: '${posts['uid']}',
                                postId: snapshot.data!.docs[index].data(),
                              ));
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                bottom: 10,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10)),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              // height: Get.height * 0.4,
                              width: Get.width - 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(
                                    placeholder: ((context, url) => Center(
                                        child: CircularProgressIndicator())),
                                    errorWidget: ((context, url, error) =>
                                        Icon(Icons.error)),
                                    imageUrl: '${posts['photo']}',
                                    fit: BoxFit.cover,
                                    height: Get.height * 0.2,
                                    width: Get.width,
                                  ),
                                  // Image(
                                  //   image: NetworkImage(
                                  //       '${posts['photo']}'),
                                  //   fit: BoxFit.cover,
                                  //   height: Get.height * 0.2,
                                  //   width: Get.width,
                                  // ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          // height: Get.height * 0.07,
                                          child: Text(
                                            '${posts['postTitle']}',
                                            style: GoogleFonts.openSans(
                                                color: Colors.white,
                                                fontSize: 19,
                                                fontWeight: FontWeight.w800),
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          height: Get.height * 0.05,
                                          child: Text(
                                            '${posts['post']}',
                                            style: GoogleFonts.openSans(
                                                color: Colors.grey.shade400,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  '${posts['userPhoto']}'),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '${posts['userName']}',
                                              style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w900),
                                              overflow: TextOverflow.clip,
                                            ),
                                            Spacer(),
                                            Text(
                                              '${posts['likes'].length}',
                                              style: GoogleFonts.roboto(
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            GestureDetector(
                                              child: posts['likes']
                                                      .contains(userLike!.uid)
                                                  ? Icon(
                                                      Icons.favorite,
                                                      size: 25,
                                                      color: Colors.red,
                                                    )
                                                  : Icon(
                                                      Icons.favorite_border,
                                                      size: 25,
                                                      color: Colors.white,
                                                    ),
                                              onTap: () {
                                                Database().likePost(
                                                    posts['postId'].toString(),
                                                    userLike!.uid.toString(),
                                                    posts['likes']);
                                              },
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            GestureDetector(
                                              onTap: () {},
                                              child: Icon(
                                                FeatherIcons.bookmark,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  } else {
                    return Container();
                  }
                });
          })),
    );
  }
}
