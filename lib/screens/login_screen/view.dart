import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_chat_app/screens/signup_screen/view.dart';
import 'package:uni_chat_app/widgets/chat_button.dart';
import 'package:uni_chat_app/widgets/chat_create_account.dart';
import 'package:uni_chat_app/widgets/chat_progress_indicator.dart';
import 'package:uni_chat_app/widgets/chat_text_field.dart';

import '../../firebase/database.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey=GlobalKey<FormState>();
  bool isLoading = false;
  bool value = true;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  height: height,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        "assets/png_images/logic.png",
                        height: width * 0.6,
                      ),
                      Text(
                        "Login",
                        style: TextStyle(fontSize: width * 0.098),
                      ),
                      LoginTextField(
                        width: width,
                        maxLine: 1,
                        controller: email,
                        hintText: "Email",
                        obscureText: false,
                      ),
                      LoginTextField(
                        width: width,
                        maxLine: 1,
                        controller: password,
                        hintText: "Password",
                        obscureText: true,
                      ),
                      ForgetPasswordAndRememberMe(),
                      ChatButton(
                        width: width,
                        name: "Login",
                        onTap: ()async {
                          setLoading(true);
                          if(_formKey.currentState!.validate()){
                            await Database.login(email.text, password.text.toString()).then((value)async {
                              final prefs = await SharedPreferences.getInstance();
                              prefs.setString("email", value?email.text.trim():"null");
                              prefs.setString("password", value?password.text.trim():"null");
                              setLoading(false);}).catchError((e){
                              setLoading(false);
                              Fluttertoast.showToast(msg: "something went wrong");
                            });
                          }
                        },
                      ),
                      CreateAccount(
                        onTap: () => Get.to(SignUpScreen()),
                      ),
                    ],
                  ),
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

  Container ForgetPasswordAndRememberMe() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                  value: value,
                  onChanged: (val) {
                    setState(() {
                      value = val!;
                    });
                  }),
              Text(
                "Remember Me?",
              ),
            ],
          ),
          InkWell(
              child: Text(
            "Forget Password?",
            style: TextStyle(
                color: Colors.blue, decoration: TextDecoration.underline),
          )),
        ],
      ),
    );
  }
  setLoading(bool value){
    setState(() {
      isLoading=value;
    });
  }
}
