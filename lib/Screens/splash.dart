import 'dart:async';

import 'package:blogspot/Core/auth.dart';
import 'package:blogspot/Screens/bottombar.dart';
import 'package:blogspot/Screens/home.dart';
import 'package:blogspot/Screens/signIn.dart';
import 'package:blogspot/Screens/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () {
      // if (user!.uid.isNotEmpty) {
      //   Get.off(SignIn());
      // } else {
      //   Get.off(BottomBar());
      // }
      User? users = FirebaseAuth.instance.currentUser;
      if (users != null) {
        Get.off(BottomBar());
      } else {
        Get.off(SignIn());
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.7), BlendMode.darken),
                image: AssetImage(
                    'assets/images/alexey-turenkov-NEwe0UGsTfY-unsplash.jpg'),
                fit: BoxFit.cover)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Blog',
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                  color: HexColor('#68fe9a')),
            ),
            Text(
              'Spot',
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w900,
                  fontSize: 45,
                  color: HexColor('#ffffff')),
            ),
            // ElevatedButton(
            //     onPressed: () {
            //       Auth().logout();
            //     },
            //     child: Text('data'))
          ],
        ),
      ),
    );
  }
}
