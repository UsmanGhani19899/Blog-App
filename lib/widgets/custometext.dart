import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomeText extends StatelessWidget {
  String? title;
  String? des;
  CustomeText({super.key, this.des, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$title',
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          '$des',
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w900,
              fontSize: 17,
              color: HexColor('#ffffff')),
        ),
      ],
    );
  }
}
