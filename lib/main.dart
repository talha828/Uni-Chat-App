import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_chat_app/screens/main_screen/view.dart';
import 'package:uni_chat_app/screens/signup_screen/view.dart';
import 'package:uni_chat_app/screens/splash_screen/view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryTextTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme
        ),
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme
        )
      ),
      home: SplashScreen()
    );
  }
}

