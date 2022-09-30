import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:uni_chat_app/constant/constant.dart';
import 'package:uni_chat_app/model/user_model.dart';
import 'package:uni_chat_app/widgets/chat_button.dart';
import 'package:uni_chat_app/widgets/chat_text_field.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController name=TextEditingController();
  TextEditingController temp=TextEditingController();
  TextEditingController specialization=TextEditingController();
  final userDetails = Get.find<UserDetails>();

  @override
  Widget build(BuildContext context) {
    var width =MediaQuery.of(context).size.width;

    return SafeArea(child: Scaffold(
      appBar:AppBar(
        leading: IconButton(
          onPressed: ()=>Navigator.pop(context),
          icon:Icon(Icons.arrow_back_ios_new),
        ),
        title: Center(
            child: Text(
              "Edit Screen",
              style: TextStyle(color: themeColor1),
            )),
        actions: [
          Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04,vertical: width * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            EditTextField(
              enabled: true,
              width: width,
              maxLine: 1,
              controller: name,
              hintText: userDetails.name.toString(),
              title: "Name",
              obscureText: true,
            ),
            EditTextField(
              enabled: false,
              width: width,
              maxLine: 1,
              controller: temp,
              hintText: userDetails.email.toString(),
              title: "Email (Fixed)",
              obscureText: true,
            ),
            EditTextField(
              enabled: true,
              width: width,
              maxLine: 1,
              controller: specialization,
              hintText: userDetails.specialization.toString(),
              title: "Specialization",
              obscureText: true,
            ),
            EditTextField(
              enabled: false,
              width: width,
              maxLine: 1,
              controller: temp,
              hintText: userDetails.uid.toString(),
              title: "Unique ID (Fixed)",
              obscureText: true,
            ),
            ChatButton(
              width: width,
              name: "Done",
              onTap: ()async {
                await FirebaseFirestore.instance.collection("users").doc(userDetails.uid.toString()).update({
                  "name":name.text.toString()=="null"?userDetails.name:name.text.toString().trim(),
                  "specialization":specialization.text.toString()=="null"?userDetails.specialization.toString():specialization.text.trim()
                });
                await Fluttertoast.showToast(msg: "Bio Successfully edit");
              },
            ),
          ],
        )
      ),
    ));
  }
}
