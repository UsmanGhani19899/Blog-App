import 'package:blogspot/Core/userProvider.dart';
import 'package:blogspot/Screens/bottombar.dart';
import 'package:blogspot/Screens/createpost.dart';
import 'package:blogspot/Screens/home.dart';
import 'package:blogspot/Screens/postDeatil.dart';
import 'package:blogspot/Screens/profile.dart';
import 'package:blogspot/Screens/signIn.dart';
import 'package:blogspot/Screens/splash.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'Models/userModel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  // final cameras = await availableCameras();

  // // Get a specific camera from the list of available cameras.
  // final firstCamera = cameras.first;
  await Firebase.initializeApp();
  runApp(const BlogSpot());
}

class BlogSpot extends StatelessWidget {
  const BlogSpot({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final UserModel userProvider = Provider.of<UserProvider>(context).getUser;
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: GetMaterialApp(
        title: 'BlogSpot',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey.shade900.withOpacity(0.2),
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
