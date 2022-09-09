import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:uni_chat_app/screens/main_screen/view.dart';
import 'package:uni_chat_app/widgets/chat_button.dart';
import 'package:uni_chat_app/widgets/chat_progress_indicator.dart';
import 'package:uni_chat_app/widgets/chat_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;
  TextEditingController email=TextEditingController();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                height: height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SvgPicture.asset(
                      "assets/svg_images/sign_up.svg",
                      height: width * 0.4,
                    ),
                    Text(
                      "SignUp",
                      style: TextStyle(fontSize: width * 0.098),
                    ),
                    LoginTextField(width: width, email: email, name: "Name"),
                    LoginTextField(width: width, email: email, name: "Email"),
                    LoginTextField(width: width, email: email, name: "Password"),
                    LoginTextField(width: width, email: email, name: "Confirm Password"),
                    ChatButton(width: width, name: "SignUp",onTap: ()=>Get.to(MainScreen()),)
                  ],
                ),
              ),
            ),
            isLoading
                ? Positioned.fill(child: ChatProgressIndicator())
                : Container()
          ],
        ),
      ),
    );
  }
}
