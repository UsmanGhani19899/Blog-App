import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class StoryDetail extends StatefulWidget {
  String? username;
  String? userPhoto;
  String? story;
  StoryDetail({super.key, this.story, this.userPhoto, this.username});

  @override
  State<StoryDetail> createState() => _StoryDetailState();
}

class _StoryDetailState extends State<StoryDetail> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          alignment: Alignment.topLeft,
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage('${widget.story}'), fit: BoxFit.cover)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage('${widget.userPhoto}'),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '${widget.username}',
                style: GoogleFonts.roboto(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
