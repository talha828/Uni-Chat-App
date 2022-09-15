import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:uni_chat_app/constant/constant.dart';
import 'package:uni_chat_app/widgets/chat_progress_indicator.dart';
import 'package:uni_chat_app/widgets/chat_tile.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController search=TextEditingController();
  bool isLoading=false;
  String name="talha";
  String msg="kuch v";
  String  time="10:00 PM";
  @override
  Widget build(BuildContext context) {
    var width =MediaQuery.of(context).size.width;
    var height =MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back_ios_new,color: Colors.white,),
          title: Center(child: Text("Chats",style: TextStyle(color: themeColor1),)),
          actions: [
            Icon(Icons.arrow_back_ios_new,color: Colors.white,),
          ],
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
             Container(
               child: Column(
                 children: [
                   Container(
                     margin: EdgeInsets.symmetric(vertical: width * 0.04,horizontal: width * 0.04),
                     child:TextField(
                        controller: search,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: width * 0.04),
                          border: InputBorder.none,
                          hintText: "Search",
                        ),
                      ),
                    ),
                   Expanded(
                     child: ListView.separated(
                         shrinkWrap: true,
                         itemBuilder: (context,index){
                       return ChatTiles(name: name, width: width, msg: msg, time: time,onTap: (){},);
                     }, separatorBuilder: (context,index){
                       return Container(
                           margin: EdgeInsets.symmetric(horizontal: width * 0.04),
                           child: Divider());
                     }, itemCount: 15),
                   ),
                 ],
               ),
             ),
            isLoading?const Positioned.fill(child: ChatProgressIndicator()):Container()
          ],
        ),
      ),
    );
  }
}

