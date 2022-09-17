
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_chat_app/constant/constant.dart';
import 'package:uni_chat_app/screens/chat_room/view.dart';
import 'package:uni_chat_app/widgets/chat_progress_indicator.dart';
import 'package:uni_chat_app/widgets/chat_tile.dart';

import 'package:flutter/material.dart';
import 'package:uni_chat_app/widgets/chat_progress_indicator.dart';


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
  int selectedIndex=0;
  List<String>list=["Private Chat","Academic Chat","Activity Chat"];
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
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: width * 0.04),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(width * 0.01)
                          ),
                          hintText: "Search",
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom:width * 0.09,top: width * 0.02),
                      child:Container(
                        height: width * 0.1,
                        child: ListView.separated(
                          separatorBuilder: (context,index){
                            return SizedBox(width: width * 0.02,);
                          },
                            shrinkWrap: true,
                            itemCount: 3,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context,index){
                          return ChatTypeButton(width: width,selectedIndex: selectedIndex,index: index,title:list[index],onTap: ()=>setState(()=>selectedIndex=index,),);

                        }),
                      )
                    ),
                   Expanded(
                     child: ListView.separated(
                         shrinkWrap: true,
                         itemBuilder: (context,index){
                       return ChatTiles(name: name, width: width, msg: msg, time: time,onTap: ()=>Get.to(()=>ChatRoomScreen()),);
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

class ChatTypeButton extends StatelessWidget {
   ChatTypeButton({
    Key? key,
    required this.width,
    required this.title,
    required this.index,
    required this.selectedIndex,
    required this.onTap
  }) : super(key: key);

  final double width;
  final String title;
   int selectedIndex;
   int index;
   Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap ,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: width * 0.025,horizontal: width * 0.025),
        decoration: BoxDecoration(
        color:selectedIndex==index? themeColor1:Colors.white,
          border: Border.all(color: themeColor1),
          borderRadius: BorderRadius.circular(width * 0.01)
        ),
        child:Text(title,style: TextStyle(color:selectedIndex==index?Colors.white:themeColor1),) ,
      ),
    );
  }
}
