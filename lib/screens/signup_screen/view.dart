import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:uni_chat_app/firebase/database.dart';
import 'package:uni_chat_app/screens/main_screen/view.dart';
import 'package:uni_chat_app/widgets/chat_button.dart';
import 'package:uni_chat_app/widgets/chat_progress_indicator.dart';
import 'package:uni_chat_app/widgets/chat_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController specialization = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
                      LoginTextField(
                        width: width,
                        controller: name,
                        hintText: "Name",
                        obscureText: false,
                      ),
                      LoginTextField(
                        width: width,
                        controller: email,
                        hintText: "Email",
                        obscureText: false,
                      ),
                      LoginTextField(
                        width: width,
                        controller: specialization,
                        hintText: "Specialization (teacher, student, etc)",
                        obscureText: false,
                      ),
                      LoginTextField(
                        width: width,
                        controller: password,
                        hintText: "Password",
                        obscureText: true,
                      ),
                      LoginTextField(
                        width: width,
                        controller: confirmPassword,
                        hintText: "Confirm Password",
                        obscureText: true,
                      ),
                      ChatButton(
                        width: width,
                        name: "SignUp",
                        onTap: () async {
                          setLoading(true);
                          if (_formKey.currentState!.validate()) {
                            if (password.text == confirmPassword.text) {
                              await Database.signUp(
                                name.text,
                                email.text,
                                password.text.toString(),
                                specialization.text,
                              ).then(
                                (value) {
                                  setLoading(false);
                                },
                              );
                            } else {
                              Fluttertoast.showToast(
                                      msg: "Your Password not match")
                                  .then((value) => setLoading(false));
                            }
                          } else {
                            setLoading(false);
                          }
                        },
                      )
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

  setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }
}
