import 'package:blogspot/Core/auth.dart';
import 'package:blogspot/Screens/editPost.dart';
import 'package:blogspot/Screens/editProfile.dart';
import 'package:blogspot/Screens/postDeatil.dart';
import 'package:blogspot/widgets/custometext.dart';
import 'package:blogspot/widgets/more.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../Core/database.dart';
import '../Core/userProvider.dart';
import '../Models/userModel.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // User? userProfile = FirebaseAuth.instance.currentUser;
    // final UserModel userProvider = Provider.of<UserProvider>(context).getUser;
    TabController? _tabController;
    User? userLike = FirebaseAuth.instance.currentUser;
    return SafeArea(
        child: Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> profile = snapshot.data!.docs[index]
                        .data() as Map<String, dynamic>;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.black,
                          // margin: EdgeInsets.symmetric(vertical: 20),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    NetworkImage('${profile['photo']}'),
                              ),
                              Container(
                                // alignment: Alignment.center,
                                // height: Get.height * 0.15,
                                // color: Colors.black.withOpacity(0.3),
                                padding: EdgeInsets.only(left: 12, right: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  // alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      // alignment: Alignment.centerLeft,

                                      child: Text("${profile['name']}",
                                          style: GoogleFonts.openSans(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 25)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            // padding: EdgeInsets.symmetric(vertical: 10),
                                            height: Get.height * 0.04,
                                            width: Get.width * 0.45,
                                            margin: EdgeInsets.only(right: 15),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Get.to(EditProfile(
                                                  image: '${profile['photo']}',
                                                  id: snapshot
                                                      .data!.docs[index].id,
                                                ));
                                              },
                                              child: Text(
                                                'Edit Profile',
                                                style: GoogleFonts.roboto(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      HexColor('#68fe9a'),
                                                  shape: RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: HexColor(
                                                              '#68fe9a')),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20))),
                                            )),
                                        GestureDetector(
                                          onTap: () {
                                            Auth().logout();
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                border: Border.all(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Icon(
                                              Icons.logout,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            height: Get.height * 0.1,
                            width: Get.width,
                            color: Colors.black,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('Posts')
                                        .where('uid',
                                            isEqualTo: FirebaseAuth
                                                .instance.currentUser!.uid)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Container();
                                      } else if (snapshot.hasData) {
                                        return CustomeText(
                                          des: '${snapshot.data!.docs.length}',
                                          title: 'Posts',
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }),
                                CustomeText(
                                  des: '${profile['followers'].length}',
                                  title: 'Followers',
                                ),
                                CustomeText(
                                  des: '${profile['followings'].length}',
                                  title: 'Following',
                                ),
                              ],
                            )),
                        // SizedBox(
                        //   height: 40,
                        // ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 12),
                          height: Get.height * 3,
                          child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Posts')
                                  .where('uid',
                                      isEqualTo: FirebaseAuth
                                          .instance.currentUser!.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                } else if (snapshot.hasData) {
                                  return ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
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
                                              postUserPic:
                                                  '${posts['userPhoto']}',
                                              postUid: '${posts['uid']}',
                                            ));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                bottom: 10, top: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            // height: Get.height * 0.4,
                                            width: Get.width - 20,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12),
                                                  child: Row(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                                '${posts['userPhoto']}'),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        '${posts['userName']}',
                                                        style:
                                                            GoogleFonts.roboto(
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                      Spacer(),
                                                      GestureDetector(
                                                        onTap: () {
                                                          showModalBottomSheet(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          12,
                                                                      vertical:
                                                                          12),
                                                                  height:
                                                                      Get.height *
                                                                          0.2,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade900,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      MoreOptions(
                                                                        icons: FeatherIcons
                                                                            .edit2,
                                                                        onPressed:
                                                                            () {
                                                                          Get.to(
                                                                              EditPost(
                                                                            image:
                                                                                '${posts['photo']}',
                                                                            id: snapshot.data!.docs[index].id,
                                                                          ));
                                                                        },
                                                                      ),
                                                                      MoreOptions(
                                                                        icons: Icons
                                                                            .delete,
                                                                        onPressed:
                                                                            () {
                                                                          Database().deletePost(snapshot
                                                                              .data!
                                                                              .docs[index]
                                                                              .id);
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      ),
                                                                      MoreOptions(
                                                                        icons: FeatherIcons
                                                                            .bookmark,
                                                                        onPressed:
                                                                            () {},
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              });
                                                        },
                                                        child: Icon(
                                                          FeatherIcons
                                                              .moreVertical,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Image(
                                                  image: NetworkImage(
                                                      '${posts['photo']}'),
                                                  fit: BoxFit.cover,
                                                  height: Get.height * 0.2,
                                                  width: Get.width,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 10, right: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        // height: Get.height * 0.07,
                                                        child: Text(
                                                          '${posts['postTitle']}',
                                                          style: GoogleFonts
                                                              .openSans(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 19,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800),
                                                          overflow:
                                                              TextOverflow.clip,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        height:
                                                            Get.height * 0.05,
                                                        child: Text(
                                                          '${posts['post']}',
                                                          style: GoogleFonts
                                                              .openSans(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                          overflow:
                                                              TextOverflow.clip,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                '${posts['likes'].length}',
                                                                style: GoogleFonts.roboto(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              GestureDetector(
                                                                child: posts[
                                                                            'likes']
                                                                        .contains(
                                                                            userLike!.uid)
                                                                    ? Icon(
                                                                        Icons
                                                                            .favorite,
                                                                        size:
                                                                            25,
                                                                        color: Colors
                                                                            .red,
                                                                      )
                                                                    : Icon(
                                                                        Icons
                                                                            .favorite_border,
                                                                        size:
                                                                            25,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                onTap: () {
                                                                  Database().likePost(
                                                                      posts['postId']
                                                                          .toString(),
                                                                      userLike
                                                                          .uid
                                                                          .toString(),
                                                                      posts[
                                                                          'likes']);
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              Database()
                                                                  .savePost(
                                                                id: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                    .id,
                                                                context:
                                                                    context,
                                                                photo:
                                                                    '${posts['photo']}',
                                                                post:
                                                                    '${posts['post']}',
                                                                title:
                                                                    '${posts['postTitle']}',
                                                                userName:
                                                                    '${posts['userName']}',
                                                                userPhoto:
                                                                    '${posts['userPhoto']}',
                                                              );
                                                            },
                                                            child: currentUser!
                                                                        .uid ==
                                                                    posts['uid']
                                                                ? Icon(
                                                                    FeatherIcons
                                                                        .bookmark,
                                                                    size: 20,
                                                                    color: Colors
                                                                        .blue,
                                                                  )
                                                                : Icon(
                                                                    FeatherIcons
                                                                        .bookmark,
                                                                    size: 20,
                                                                    color: Colors
                                                                        .white,
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
                              }),
                        ),
                      ],
                    );
                  });
            } else {
              return Container();
            }
          }),
    ));
  }
}
