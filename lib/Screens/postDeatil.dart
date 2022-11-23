import 'package:blogspot/Core/database.dart';
import 'package:blogspot/Models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../Core/userProvider.dart';

class PostDetail extends StatefulWidget {
  String? image;
  String? postName;
  String? postDes;
  String? postUser;
  String? postUserPic;
  String? postUid;
  final postId;

  PostDetail(
      {super.key,
      this.image,
      this.postId,
      this.postDes,
      this.postName,
      this.postUser,
      this.postUserPic,
      this.postUid});

  @override
  State<PostDetail> createState() => _PostDetailState();
}

int commentLen = 0;
final TextEditingController commentEditingController = TextEditingController();
bool following = false;
User? currentUser = FirebaseAuth.instance.currentUser;
UserModel user = UserModel();

class _PostDetailState extends State<PostDetail> {
  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await Database().postComment(
        context,
        widget.postId['postId'],
        commentEditingController.text,
        uid,
        name,
        profilePic,
      );

      if (res != 'success') {
        // showSnackBar(context, res);
      }
      setState(() {
        commentLen++;
        commentEditingController.text = "";
      });
    } catch (err) {
      // showSnackBar(
      //   context,
      //   err.toString(),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final UserModel user = Provider.of<UserProvider>(context).getUser;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SingleChildScrollView(
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Container(
                  margin: EdgeInsets.only(bottom: 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Image(
                            image: NetworkImage('${widget.image}'),
                            // image: AssetImage(
                            // 'assets/images/adapt-frame-NeeuOmVsDDs-unsplash.jpg'),
                            fit: BoxFit.cover,
                            height: Get.height * 0.35,
                            width: Get.width,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.black,
                                  child: Icon(
                                    FeatherIcons.heart,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.black,
                                  child: Icon(
                                    FeatherIcons.bookmark,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        height: Get.height * 0.12,
                        width: Get.width,
                        color: Colors.grey.shade900.withOpacity(0.4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage('${widget.postUserPic}'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${widget.postUser}',
                              style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800),
                              // overflow: TextOverflow.clip,
                            ),
                            Spacer(),
                            Container(
                              height: Get.height * 0.04,
                              width: Get.width * 0.25,
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("Users")
                                      .where('uid',
                                          isNotEqualTo: currentUser!.uid)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    return ListView.builder(
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          Map<String, dynamic> userFollow =
                                              snapshot.data!.docs[index].data()
                                                  as Map<String, dynamic>;
                                          return GestureDetector(
                                            onTap: () {
                                              Database().followOther(
                                                  userFollow['userId'],
                                                  currentUser!.uid,
                                                  userFollow['followings']);
                                            },
                                            child: userFollow['followings']
                                                    .contains(currentUser!.uid)
                                                ? Container(
                                                    alignment: Alignment.center,
                                                    height: Get.height * 0.04,
                                                    width: Get.width * 0.2,
                                                    margin: EdgeInsets.only(
                                                        right: 15),
                                                    child: Text(
                                                      'Follow',
                                                      style: GoogleFonts.roboto(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 12),
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            HexColor('#68fe9a'),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                  )
                                                : Container(
                                                    alignment: Alignment.center,
                                                    height: Get.height * 0.04,
                                                    width: Get.width * 0.25,
                                                    margin: EdgeInsets.only(
                                                        right: 15),
                                                    child: Text(
                                                      'Following',
                                                      style: GoogleFonts.roboto(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 12),
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.transparent,
                                                        border: Border.all(
                                                          color: HexColor(
                                                              '#68fe9a'),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                  ),
                                          );
                                        });
                                  }),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.postName}',
                              style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800),
                              overflow: TextOverflow.clip,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${widget.postDes}',
                              style: GoogleFonts.openSans(
                                  color: Colors.grey.shade400,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400),
                              overflow: TextOverflow.clip,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return Container(
                          padding: MediaQuery.of(context).viewInsets,
                          // height: Get.height * 0.8,
                          color: Colors.grey.shade900,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: Get.height * 0.4,
                                color: Colors.grey.shade900,
                                child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('Posts')
                                        .doc(widget.postId['postId'])
                                        .collection('Comments')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasData) {
                                        return ListView.builder(
                                            itemCount:
                                                snapshot.data!.docs.length,
                                            itemBuilder: (context, index) {
                                              Map<String, dynamic> commentUser =
                                                  snapshot.data!.docs[index]
                                                          .data()
                                                      as Map<String, dynamic>;
                                              return Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 10),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage: NetworkImage(
                                                          '${commentUser['profilePic']}'),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${commentUser['name']}',
                                                          style: GoogleFonts
                                                              .openSans(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                          // overflow: TextOverflow.clip,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Container(
                                                          width:
                                                              Get.width * 0.45,
                                                          child: Text(
                                                            '${commentUser['text']}',
                                                            style: GoogleFonts
                                                                .openSans(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      } else {
                                        return Container();
                                      }
                                    }),
                              ),
                              Container(
                                color: Colors.black,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(top: 12),
                                        // color: Colors.white,
                                        height: Get.height * 0.1,
                                        width: Get.width * 0.8,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide())),
                                          controller: commentEditingController,
                                        )),
                                    Container(
                                      padding: EdgeInsets.only(top: 15),
                                      alignment: Alignment.center,
                                      height: Get.height * 0.08,
                                      width: Get.width * 0.08,
                                      child: StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('Users')
                                              .where('uid',
                                                  isEqualTo: currentUser!.uid)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            return ListView.builder(
                                                itemCount:
                                                    snapshot.data!.docs.length,
                                                itemBuilder: (context, index) {
                                                  Map<String, dynamic>
                                                      userDetail = snapshot
                                                              .data!.docs[index]
                                                              .data()
                                                          as Map<String,
                                                              dynamic>;
                                                  return GestureDetector(
                                                    onTap: () {
                                                      postComment(
                                                        userDetail['uid'],
                                                        userDetail['name'],
                                                        userDetail['photo'],
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons.send,
                                                      color:
                                                          HexColor('#68fe9a'),
                                                    ),
                                                  );
                                                });
                                          }),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                    });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                width: Get.width,
                height: Get.height * 0.08,
                color: Colors.grey.shade900,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Comments',
                      style: GoogleFonts.openSans(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800),
                      // overflow: TextOverflow.clip,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.keyboard_arrow_up,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
