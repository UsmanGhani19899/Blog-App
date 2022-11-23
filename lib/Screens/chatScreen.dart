import 'package:blogspot/widgets/customeFields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  String? image;
  String? name;
  String? chatRoomId;
  ChatScreen({super.key, this.image, this.name, this.chatRoomId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

TextEditingController _controller = TextEditingController();

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    var _enteredMessage = '';

    void _sendMessage() async {
      FocusScope.of(context).unfocus();

      FirebaseFirestore.instance
          .collection("appointchatroom")
          .doc(widget.chatRoomId)
          .collection("chat")
          .add({
        'isSeen': false,
        'message': _enteredMessage,
        'createdAt': Timestamp.now(),
        'sendBy': FirebaseAuth.instance.currentUser!.uid,
        // 'recievedBy': sharedPreferences.getString('lawwwid'),
      }).catchError((e) {
        print(e.toString());
      });

      _controller.clear();
    }

    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(),
        title: Text(
          '${widget.name}',
          style: GoogleFonts.roboto(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: Get.height * 0.8,
              color: Colors.white,
            ),
            Row(
              children: [
                Container(
                    width: Get.width * 0.8,
                    child: TextFormField(
                      style: GoogleFonts.roboto(color: Colors.white),
                      controller: _controller,
                      onChanged: (value) {
                        setState(() {
                          _enteredMessage = value;
                        });
                      },
                    )),
                IconButton(
                    onPressed: () {
                      _enteredMessage.isEmpty ? null : _sendMessage;
                    },
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
