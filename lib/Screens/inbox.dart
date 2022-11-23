import 'package:blogspot/Screens/chatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Inbox extends StatefulWidget {
  const Inbox({super.key});

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  @override
  Widget build(BuildContext context) {
    Future<void> createAppointChatRoom() async {
      List<String?> users = [
        "omLoExbq14RvemgHueQPuU7ifQF3",
        FirebaseAuth.instance.currentUser!.uid
      ];
      FirebaseFirestore.instance
          .collection('appointchatroom')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "users": users,
        "chatRoomId": FirebaseAuth.instance.currentUser!.uid
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) => ChatScreen(
                    chatRoomId: FirebaseAuth.instance.currentUser!.uid,
                    name: "Admin",
                  )));
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          margin: EdgeInsets.only(top: 30),
          child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("Users").snapshots(),
              builder: (context, snapshot) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> user = snapshot.data!.docs[index]
                          .data() as Map<String, dynamic>;
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: GestureDetector(
                          onTap: () {
                            createAppointChatRoom();
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    NetworkImage('${user['photo']}'),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${user['name']}',
                                    style: GoogleFonts.roboto(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  Text(
                                    'Usman Ghani',
                                    style: GoogleFonts.roboto(
                                        color: Colors.grey, fontSize: 15),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }),
        ),
      ),
    );
  }
}
