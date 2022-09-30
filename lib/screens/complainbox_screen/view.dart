import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uni_chat_app/constant/constant.dart';
import 'package:uni_chat_app/widgets/chat_button.dart';
import 'package:uni_chat_app/widgets/chat_text_field.dart';

class ComplainBoxScreen extends StatefulWidget{
  const ComplainBoxScreen({Key? key}) : super(key: key);

  @override
  State<ComplainBoxScreen> createState() => _ComplainBoxScreenState();
}

class _ComplainBoxScreenState extends State<ComplainBoxScreen> {
  TextEditingController title=TextEditingController();
  TextEditingController desc=TextEditingController();
  @override
  Widget build(BuildContext context) {
    var width =MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: ()=>Navigator.pop(context),
          icon:Icon(Icons.arrow_back_ios_new),
        ),
        title: Center(
            child: Text(
              "Complain Box",
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
        padding: EdgeInsets.symmetric(horizontal:width * 0.04,vertical: width *0.04 ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            EditTextField(width: width, controller: title, hintText: "Subject", obscureText: false, enabled: true, title: "Title"),
            EditTextField(width: width, maxLine: 10,controller: desc, hintText: "Share your problem", obscureText: false, enabled: true, title: "Details"),
            ChatButton(
              width: width,
              name: "Complain Now",
              onTap: ()async {
                await FirebaseFirestore.instance.collection("complainBox").doc().set({
                  "title":title.text,
                  "problem":desc.text,
                });
                await Fluttertoast.showToast(msg: "Complain successfully send");
              },
            ),
          ],
        ),
      ),
    ));
  }
}
