import 'package:blogspot/Core/auth.dart';
import 'package:blogspot/Core/database.dart';
import 'package:blogspot/Screens/signUp.dart';
import 'package:blogspot/widgets/customeFields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get_core/get_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../widgets/passswordField.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

TextEditingController emailController = TextEditingController();

TextEditingController passwordController = TextEditingController();

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: Get.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container(
                //   margin: EdgeInsets.symmetric(vertical: 20),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         'SINGIN',
                //         style: GoogleFonts.roboto(
                //             fontWeight: FontWeight.w700,
                //             fontSize: 45,
                //             color: Colors.white),
                //       ),
                //       Text(
                //         'WELCOME BACK',
                //         style: GoogleFonts.roboto(
                //             fontWeight: FontWeight.w300,
                //             fontSize: 25,
                //             color: Colors.grey.shade400),
                //       ),
                //     ],
                //   ),
                // )

                Container(
                  margin: EdgeInsets.symmetric(vertical: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'B',
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w900,
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
                    ],
                  ),
                ),

                Column(
                  children: [
                    CustomeField(
                      maxLine: 1,
                      fieldName: 'Email',
                      controller: emailController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomePasswordField(
                      fieldName: 'Password',
                      controller: passwordController,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.grey.shade500),
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(vertical: 40),
                  width: Get.width * 0.8,
                  height: Get.height * 0.07,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(),
                        backgroundColor: HexColor('#68fe9a')),
                    onPressed: () {
                      Auth().signIn(context, emailController.text,
                          passwordController.text);
                    },
                    child: Text(
                      'SignIn',
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have account?",
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: HexColor('#ffffff')),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.off(SignUp());
                      },
                      child: Text(
                        'SignUp',
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            color: HexColor('#68fe9a')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
