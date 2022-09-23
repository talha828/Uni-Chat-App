import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_chat_app/constant/constant.dart';
import 'package:uni_chat_app/model/chat_message_model.dart';
import 'package:uni_chat_app/model/user_model.dart';
import 'package:uni_chat_app/screens/chat_room_screen/view.dart';
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
  TextEditingController search = TextEditingController();
  final userDetails = Get.find<UserDetails>();
  final chatUserDetails = Get.put(ChatUserDetails());
  bool isLoading = false;
  String name = "talha";
  String msg = "kuch v";
  String time = "10:00 PM";
  int selectedIndex = 0;
  List<String> list = ["Private Chat", "Academic Chat", "Activity Chat"];
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          title: Center(
              child: Text(
            "Chats",
            style: TextStyle(color: themeColor1),
          )),
          actions: [
            Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ],
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: width * 0.04, horizontal: width * 0.04),
                    child: TextField(
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
                            borderRadius: BorderRadius.circular(width * 0.01)),
                        hintText: "Search",
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: width * 0.09, top: width * 0.02),
                      child: Container(
                        height: width * 0.1,
                        child: ListView.separated(
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: width * 0.02,
                              );
                            },
                            shrinkWrap: true,
                            itemCount: 3,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return ChatTypeButton(
                                width: width,
                                selectedIndex: selectedIndex,
                                index: index,
                                title: list[index],
                                onTap: () => setState(
                                  () => selectedIndex = index,
                                ),
                              );
                            }),
                      )),
                  Expanded(
                    child: ListView.builder(
                        itemCount: userDetails.chatUsers.length,
                        itemBuilder: (context, index) {
                          return StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("chat")
                                  .doc(userDetails.chatUsers[index].toString())
                                  .collection(
                                      userDetails.chatUsers[index].toString())
                                  .orderBy("timestamp", descending: true)
                                  .limit(1)
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                List<ChatMessage> msg = snapshot.data!.docs
                                    .map(
                                      (doc) => ChatMessage(
                                        myName: doc['my_name'],
                                        friendName: doc["friend_name"],
                                        msgOwner: doc['msg_owner'],
                                        myUid: doc['uid'],
                                        seen: doc['seen'],
                                        image: doc["image"],
                                        timestamp: doc["timestamp"].toString(),
                                        friendUid: doc['friend_uid'],
                                        isDocument: doc['is_document'],
                                        document: doc['document'],
                                        isImage: doc['is_image'],
                                        message: doc['message'],
                                      ),
                                    )
                                    .toList();
                                return ChatTiles(
                                  name: msg[index].friendName,
                                  width: width,
                                  msg: msg[index].message.toString(),
                                  time: readTimestamp(
                                      int.parse(msg[index].timestamp)),
                                  onTap: ()async {
                                    chatUserDetails.name.value=msg[index].friendName;
                                   chatUserDetails.uid.value=msg[index].friendUid;
                                   Get.to(ChatRoomScreen());
                                  },
                                );
                                // return ListView.separated(
                                //     shrinkWrap: true,
                                //     itemBuilder: (context,index){
                                //   return ChatTiles(name: name, width: width, msg: msg, time: time,onTap: ()=>Get.to(ChatRoomScreen()),);
                                // }, separatorBuilder: (context,index){
                                //   return Container(
                                //       margin: EdgeInsets.symmetric(horizontal: width * 0.04),
                                //       child: Divider());
                                // }, itemCount: 15);
                              });
                        }),
                  ),
                ],
              ),
            ),
            isLoading
                ? const Positioned.fill(child: ChatProgressIndicator())
                : Container()
          ],
        ),
      ),
    );
  }

  String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('HH:mm a');
    var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = date.difference(now);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + 'DAY AGO';
      } else {
        time = diff.inDays.toString() + 'DAYS AGO';
      }
    }

    return time;
  }
}

class ChatTypeButton extends StatelessWidget {
  ChatTypeButton(
      {Key? key,
      required this.width,
      required this.title,
      required this.index,
      required this.selectedIndex,
      required this.onTap})
      : super(key: key);

  final double width;
  final String title;
  int selectedIndex;
  int index;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: width * 0.025, horizontal: width * 0.025),
        decoration: BoxDecoration(
            color: selectedIndex == index ? themeColor1 : Colors.white,
            border: Border.all(color: themeColor1),
            borderRadius: BorderRadius.circular(width * 0.01)),
        child: Text(
          title,
          style: TextStyle(
              color: selectedIndex == index ? Colors.white : themeColor1),
        ),
      ),
    );
  }
}
