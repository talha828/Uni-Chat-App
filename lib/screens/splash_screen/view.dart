
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_chat_app/firebase/database.dart';
import 'package:uni_chat_app/screens/login_screen/view.dart';
import 'package:uni_chat_app/screens/main_screen/view.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  getStart() async {
    final prefs = await SharedPreferences.getInstance();
    var email = prefs.getString("email");
    var password = prefs.getString("password");
    if (email.toString() != "null" && password.toString() != "null") {
      await Database.login(email.toString(), password.toString())
          .then((value) => Get.to(() => const MainScreen()))
          .catchError(
            (e) {
          Fluttertoast.showToast(msg: "something went wrong");
        },
      );
    } else {
      Timer(const Duration(seconds: 2), () => Get.to(LoginScreen()));
    }
  }
  @override
  void initState() {
    getStart();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo/logo.png", scale: 1.5,),
            Text("UTAS-A-SC", textAlign: TextAlign.center,
                style: GoogleFonts.lato(textStyle: TextStyle(
                    fontSize: width * 0.13, fontWeight: FontWeight.bold),)),
            SizedBox(height: width * 0.02,),
          ],
        ),
      ),
    );
  }
}

