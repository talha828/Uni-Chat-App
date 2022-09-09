
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_chat_app/screens/login_screen/view.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 2),()=>Get.to(() =>LoginScreen()));
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
            Text("Chat App", textAlign: TextAlign.center,
                style: GoogleFonts.lato(textStyle: TextStyle(
                    fontSize: width * 0.13, fontWeight: FontWeight.bold),)),
            SizedBox(height: width * 0.02,),
          ],
        ),
      ),
    );
  }
}

