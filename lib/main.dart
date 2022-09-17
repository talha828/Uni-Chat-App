import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_chat_app/constant/constant.dart';
import 'package:uni_chat_app/screens/chat_room/view.dart';
import 'package:uni_chat_app/screens/login_screen/view.dart';
import 'package:uni_chat_app/screens/main_screen/view.dart';
import 'package:uni_chat_app/screens/signup_screen/view.dart';
import 'package:uni_chat_app/screens/splash_screen/view.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: themeColor1,
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        primaryTextTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme
        ),
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme
        )
      ),
      home: SignUpScreen(),
    );
  }
}

