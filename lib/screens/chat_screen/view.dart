import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_chat_app/constant/constant.dart';
import 'package:uni_chat_app/model/Group_chat_model.dart';
import 'package:uni_chat_app/model/chat_message_model.dart';
import 'package:uni_chat_app/model/user_model.dart';
import 'package:uni_chat_app/screens/chat_room_screen/view.dart';
import 'package:uni_chat_app/screens/group_chat_room/view.dart';
import 'package:uni_chat_app/widgets/chat_progress_indicator.dart';
import 'package:uni_chat_app/widgets/chat_tile.dart';

import 'package:flutter/material.dart';
import 'package:uni_chat_app/widgets/chat_progress_indicator.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController search = TextEditingController();
  final userDetails = Get.find<UserDetails>();
  final chatUserDetails = Get.put(ChatUserDetails());
  final groupDetails = Get.put(GroupChatModel());
  late TabController _tabController;
  bool isLoading = false;
  String name = "talha";
  String msg = "kuch v";
  String time = "10:00 PM";
  int selectedIndex = 0;
  List<String> list = ["Private Chat", "Academic Chat", "Activity Chat"];
  @override
  getData(UserDetails userss) async {
    CollectionReference user = FirebaseFirestore.instance.collection("users");
    FirebaseAuth _auth = FirebaseAuth.instance;
    DocumentSnapshot<Object?> data =
        await user.doc(_auth.currentUser!.uid).get();
    if (data.exists) {
      final user = Get.put(UserDetails());
      var dd = data.data();
      user.name.value = data['name'].toString();
      user.email.value = data['email'].toString();
      user.uid.value = data['uid'].toString();
      user.specialization.value = data['specialization'].toString();
      user.password.value = data['password'].toString();
      // data['academic_chat_link'].printError();
      if (data['is_chat'] != false) {
        user.chatUsers.clear();
        for (var i in data['user_chat_link']) {
          user.chatUsers.add(i);
        }
      }
      if (data['is_activity'] != false) {
        user.activityGroup.clear();
        for (var i in data['activity_group_link']) {
          user.activityGroup.add(i);
        }
      }
      if (data['is_academic'] != false) {
        user.academicGroup.clear();
        for (var i in data['Academic_group_link']) {
          user.academicGroup.add(i);
        }
      }
    }

    Future<QuerySnapshot<Map<String, dynamic>>> query= FirebaseFirestore.instance
                  .collection("groups")
                  .doc("Activity")
                  .collection(userDetails
                  .activityGroup[0]
                  .toString())
                  .orderBy("timestamp", descending: true).get().then((value){
                    print(value.docs.length);
                    return value;
    });
 }

  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    final userDetails = Get.find<UserDetails>();
    getData(userDetails);
    super.initState();
  }

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
                  // Container(
                  //   margin: EdgeInsets.symmetric(
                  //       vertical: width * 0.04, horizontal: width * 0.04),
                  //   child: TextField(
                  //     controller: search,
                  //     textAlignVertical: TextAlignVertical.center,
                  //     decoration: InputDecoration(
                  //       suffixIcon: Icon(Icons.search),
                  //       filled: true,
                  //       fillColor: Colors.grey.shade300,
                  //       contentPadding:
                  //           EdgeInsets.symmetric(horizontal: width * 0.04),
                  //       border: OutlineInputBorder(
                  //           borderSide: BorderSide.none,
                  //           borderRadius: BorderRadius.circular(width * 0.01)),
                  //       hintText: "Search",
                  //     ),
                  //   ),
                  // ),
                  TabBar(

                    unselectedLabelColor: Colors.black,
                    labelColor: themeColor1,
                    indicatorColor: themeColor1,
                    tabs: [
                      Tab(
                        text: "Private",
                      ),
                      Tab(
                        text: "Activity",
                      ),
                      Tab(
                        text: "Academic",
                      ),

                    ],
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // FirebaseAnimatedList(query:FirebaseFirestore.instance
                        //           .collection("groups")
                        //           .doc("Activity")
                        //           .collection(userDetails
                        //           .activityGroup[0]
                        //           .toString())
                        //           .orderBy("timestamp", descending: true)
                        //           .limit(1) as Query,
                        //     itemBuilder: (context,snapshot,animation,index){
                        //   return Text("dd");
                        //     }),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: userDetails.chatUsers.length,
                            itemBuilder: (context, index) {
                              return StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("chat")
                                      .doc(userDetails.chatUsers[index]
                                      .toString())
                                      .collection(userDetails.chatUsers[index]
                                      .toString())
                                      .orderBy("timestamp", descending: true)
                                      .limit(1)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting)
                                      return Column(
                                        children: [Center(child: ChatProgressIndicator())],
                                      );
                                    if(snapshot.data!.docs.length<1)
                                      return Padding(
                                        padding: EdgeInsets.all(width * 0.07),
                                        child: Center(child: Text("Not Record are found"),),
                                      );
                                    List<ChatMessage> msg = snapshot.data!.docs
                                        .map(
                                          (doc) => ChatMessage(
                                        myName: doc['my_name'],
                                        friendName: doc["friend_name"],
                                        msgOwner: doc['msg_owner'],
                                        myUid: doc['uid'],
                                        seen: doc['seen'],
                                        image: doc["image"],
                                        timestamp:
                                        doc["timestamp"].toString(),
                                        friendUid: doc['friend_uid'],
                                        isDocument: doc['is_document'],
                                        document: doc['document'],
                                        isImage: doc['is_image'],
                                        message: doc['message'],
                                      ),
                                    )
                                        .toList();
                                    return ChatTiles(
                                      name: msg[0].friendName,
                                      width: width,
                                      msg: msg[0].message.toString(),
                                      time: readTimestamp(
                                          int.parse(msg[0].timestamp)),
                                      onTap: () async {
                                        chatUserDetails.name.value =
                                            msg[0].friendName;
                                        chatUserDetails.uid.value =
                                            msg[0].friendUid;
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
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: userDetails.activityGroup.length,
                            itemBuilder: (context, index) {
                              return StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("groups/Activity/${userDetails.activityGroup[index]}")
                                      .orderBy("timestamp", descending: true)
                                      .limit(1)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting)
                                      return Column(
                                        children: [Center(child: ChatProgressIndicator())],
                                      );
                                    if (snapshot.hasData) {
                                      List<GroupMessage> msg = snapshot
                                          .data!.docs
                                          .map(
                                            (doc) => GroupMessage(
                                          groupImage: doc["group_image"],
                                          desc:doc["description"] ,
                                          type: doc["group_type"],
                                          myName: doc['my_name'],
                                          friendName: doc["friend_name"],
                                          groupType: doc["group_class"],
                                          msgOwner: doc['msg_owner'],
                                          myUid: doc['uid'],
                                          seen: doc['seen'],
                                          image: doc["image"],
                                          timestamp:
                                          doc["timestamp"].toString(),
                                          friendUid: doc['friend_uid'],
                                          isDocument: doc['is_document'],
                                          document: doc['document'],
                                          isImage: doc['is_image'],
                                          message: doc['message'],
                                        ),
                                      )
                                          .toList();
                                      return
                                        ChatTiles(
                                          name: msg[0].friendName,
                                          width: width,
                                          msg: msg[0].message.toString(),
                                          time: readTimestamp(
                                              int.parse(msg[0].timestamp)),
                                          onTap: () async {
                                            groupDetails.groupInfo.clear();
                                            groupDetails.groupInfo.add(msg[index]);
                                            Get.to(GroupChatRoomScreen());
                                          });
                                    }
                                    return Text("result not available");
                                  }
                              );
                            }),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: userDetails.academicGroup.length,
                            itemBuilder: (context, index) {
                              return StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("groups")
                                      .doc("Academic")
                                      .collection(userDetails.academicGroup[index].toString())
                                      .orderBy("timestamp",descending: true).limit(1)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting)
                                      return Column(
                                        children: [Center(child: ChatProgressIndicator())],
                                      );
                                    List<GroupMessage> msg = snapshot.data!.docs
                                        .map(
                                          (doc) => GroupMessage(
                                            groupImage: doc["group_image"],
                                            desc:doc["description"] ,
                                            type: doc["group_type"],
                                            groupType: doc["group_class"],
                                            myName: doc['my_name'],
                                            friendName: doc["friend_name"],
                                            msgOwner: doc['msg_owner'],
                                            myUid: doc['uid'],
                                            seen: doc['seen'],
                                            image: doc["image"],
                                            timestamp:
                                                doc["timestamp"].toString(),
                                            friendUid: doc['friend_uid'],
                                            isDocument: doc['is_document'],
                                            document: doc['document'],
                                            isImage: doc['is_image'],
                                            message: doc['message'],
                                          ),
                                        )
                                        .toList();
                                    return ChatTiles(
                                      name: msg[0].friendName,
                                      width: width,
                                      msg: msg[0].message.toString(),
                                      time: readTimestamp(
                                          int.parse(msg[0].timestamp)),
                                      onTap: () async {
                                        groupDetails.groupInfo.clear();
                                        groupDetails.groupInfo.add(msg[index]);
                                        Get.to(GroupChatRoomScreen());
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

                      ],
                      controller: _tabController,
                    ),
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
