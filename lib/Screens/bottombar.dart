import 'package:blogspot/Screens/createpost.dart';
import 'package:blogspot/Screens/home.dart';
import 'package:blogspot/Screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../Core/userProvider.dart';
import '../Models/userModel.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

int currentIndex = 0;

final screens = [
  Home(),
  Container(
    height: 900,
    child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> user =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return Flexible(
                  child: CreatePost(
                    blogUser: '${user['name']}',
                    userImage: '${user['photo']}',
                  ),
                );
              });
        }),
  ),
  // CreatePost(),
  Profile()
];
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class _BottomBarState extends State<BottomBar> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final UserModel userProvider = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      key: _scaffoldKey,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => currentIndex = index);
        },
        children: <Widget>[
          Home(),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .where('uid',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> user = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        if (!snapshot.hasData) {
                          return Text(
                            'No data',
                            style: GoogleFonts.roboto(color: Colors.white),
                          );
                        } else if (snapshot.hasData) {
                          return CreatePost(
                            blogUser: '${user['name']}',
                            userImage: '${user['photo']}',
                          );
                        } else {
                          return Container();
                        }
                      });
                } else {
                  return Container();
                }
              }),
          // CreatePost(),
          Profile()
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.black,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: HexColor('#68fe9a'),
            unselectedItemColor: Colors.grey,
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              setState(() => currentIndex = index);
              _pageController.jumpToPage(index);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(FeatherIcons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(FeatherIcons.plusSquare), label: 'Post'),
              BottomNavigationBarItem(
                  icon: Icon(FeatherIcons.user), label: 'Profile'),
            ]),
      ),
      // body: screens[currentIndex],
    );
  }
}
