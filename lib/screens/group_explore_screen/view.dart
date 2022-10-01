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
import 'package:uni_chat_app/widgets/chat_text_field.dart';

class GroupExploreScreen extends StatefulWidget {
  const GroupExploreScreen({Key? key}) : super(key: key);

  @override
  State<GroupExploreScreen> createState() => _GroupExploreScreenState();
}

class _GroupExploreScreenState extends State<GroupExploreScreen> with SingleTickerProviderStateMixin{
  TextEditingController search = TextEditingController();
  final chatUserDetails=Get.put(ChatUserDetails());
  final groupDetails = Get.put(GroupChatModel());
  late TabController _tabController;
  Future<List<String>>getActivityGroup()async{
  List<String>list=[];
    var activity =await FirebaseFirestore.instance.collection("group_list").doc("activity").get().then((subCollection)async{
      print(subCollection["group_list"]);
      for(var i in subCollection["group_list"]){
        list.add(i); 
        print(i);
      }
      return subCollection;
      });
    return list;
  }
  Future<List<String>>getAcademicGroup()async{
    List<String>list=[];
    var activity =await FirebaseFirestore.instance.collection("group_list").doc("Academic").get().then((subCollection)async{
      print(subCollection["group_list"]);
      for(var i in subCollection["group_list"]){
        list.add(i);
        print(i);
      }
      return subCollection;
    });
    return list;
  }
  @override
  void initState() {
  // TODO: implement initState
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: ()=>Navigator.pop(context),
            icon:Icon(Icons.arrow_back_ios_new),
          ),
          title: Center(
              child: Text(
                "Explore Groups",
                style: TextStyle(color: themeColor1),
              )),
          actions: [
            Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ],
        ),
        body: Column(
          children: [
            TabBar(
              unselectedLabelColor: Colors.black,
              labelColor: themeColor1,
              indicatorColor: themeColor1,
              tabs: [
                Tab(
                  text: "Academic",
                ),
                Tab(
                  text: "Activity",
                ),
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(child: TabBarView(children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: width * 0.04, horizontal: width * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LoginTextField(
                          width: width,
                          controller: search,
                          hintText: "Search",
                          obscureText: false,
                          onChange: (value){
                            setState(() {});
                          },
                        ),
                        FutureBuilder<List<String>>(
                          future: getAcademicGroup(),
                          builder: (context,snapshot) {
                            if(snapshot.connectionState==ConnectionState.waiting)
                              return CircularProgressIndicator();
                            if(snapshot.hasError)
                              return Text("No records founds");
                            return ListView.builder(
                              shrinkWrap: true,
                             itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("groups").doc("Academic").collection(snapshot.data![index]).orderBy("timestamp",descending: true).limit(1)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasError) // TODO: show alert
                                        return Center(child: Text('Something went wrong'));

                                      if (snapshot.connectionState == ConnectionState.waiting)
                                        return Column(
                                          children: [Center(child: ChatProgressIndicator())],
                                        );

                                      var len = snapshot.data!.docs.length;
                                      if (len == 0)
                                        return Column(
                                          children: [
                                            SizedBox(height: 100),
                                            Center(
                                              child: Text("No shops available",
                                                  style: TextStyle(
                                                      fontSize: 20, color: Colors.grey)),
                                            )
                                          ],
                                        );

                                      List<GroupMessage> shops = snapshot.data!.docs
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
                                          timestamp: doc["timestamp"].toString(),
                                          friendUid: doc['friend_uid'],
                                          isDocument: doc['is_document'],
                                          document: doc['document'],
                                          isImage: doc['is_image'],
                                          message: doc['message'],
                                        ),
                                      )
                                          .toList();

                                      return Expanded(
                                        child: ListView.builder(
                                            padding: EdgeInsets.symmetric(vertical: 15),
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount: shops.length,
                                            itemBuilder: (context, index){
                                              return ListTile(
                                                onTap: ()async{
                                                  groupDetails.groupInfo.clear();
                                                  groupDetails.groupInfo.add(shops[index]);
                                                  Get.to(GroupChatRoomScreen());
                                                },
                                                leading: CircleAvatar(
                                                  backgroundColor: themeColor1,
                                                  child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(width * 0.2),
                                                      child: Image.memory(shops[index].groupImage.bytes))),
                                                title: Text(shops[index].friendName),
                                                subtitle: Text(shops[index].desc),
                                                trailing: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  child: Icon(Icons.send,color: themeColor1,),),
                                              );
                                            }),
                                      );
                                    },
                                  ),
                                );
                              }
                            );
                          }
                        )
                      ],
                    ),
                  ),
                  isLoading
                      ? Positioned.fill(child: ChatProgressIndicator())
                      : Container()
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: width * 0.04, horizontal: width * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LoginTextField(
                          width: width,
                          controller: search,
                          hintText: "Search",
                          obscureText: false,
                          onChange: (value){
                            setState(() {});
                          },
                        ),
                        FutureBuilder<List<String>>(
                            future: getActivityGroup(),
                            builder: (context,snapshot) {
                              if(snapshot.connectionState==ConnectionState.waiting)
                                return CircularProgressIndicator();
                              if(snapshot.hasError)
                                return Text("No records sre found");
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      child: StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection("groups").doc("Activity").collection(snapshot.data![index]).orderBy("timestamp",descending: true).limit(1)
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (snapshot.hasError) // TODO: show alert
                                            return Text('Something went wrong');

                                          if (snapshot.connectionState == ConnectionState.waiting)
                                            return Column(
                                              children: [Center(child: ChatProgressIndicator())],
                                            );

                                          var len = snapshot.data!.docs.length;
                                          if (len == 0)
                                            return Column(
                                              children: [
                                                SizedBox(height: 100),
                                                Center(
                                                  child: Text("No shops available",
                                                      style: TextStyle(
                                                          fontSize: 20, color: Colors.grey)),
                                                )
                                              ],
                                            );

                                          List<GroupMessage> shops = snapshot.data!.docs
                                              .map(
                                                (doc) => GroupMessage(
                                              groupImage: doc["group_image"],
                                              desc:doc["description"] ,
                                              type: doc["group_type"],
                                              myName: doc['my_name'],
                                              friendName: doc["friend_name"],
                                              msgOwner: doc['msg_owner'],
                                              groupType: doc["group_class"],
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

                                          return Expanded(
                                            child: ListView.builder(
                                                padding: EdgeInsets.symmetric(vertical: 15),
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemCount: shops.length,
                                                itemBuilder: (context, index){
                                                  return ListTile(
                                                    onTap: (){
                                                      Get.to(GroupChatRoomScreen());
                                                    },
                                                    leading: CircleAvatar(
                                                        backgroundColor: themeColor1,
                                                        child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(width * 0.2),
                                                            child: Image.memory(shops[index].groupImage.bytes))),
                                                    title: Text(shops[index].friendName),
                                                    subtitle: Text(shops[index].desc),
                                                    trailing: CircleAvatar(
                                                      backgroundColor: Colors.white,
                                                      child: Icon(Icons.send,color: themeColor1,),),
                                                  );
                                                }),
                                          );
                                        },
                                      ),
                                    );
                                  }
                              );
                            }
                        )
                      ],
                    ),
                  ),
                  isLoading
                      ? Positioned.fill(child: ChatProgressIndicator())
                      : Container()
                ],
              ),
            ],
              controller: _tabController
            ),
            ),
          ],
        ),
      ),
    );
  }

  setLoading(bool value) {
    setState(() {
      isLoading = true;
    });
  }
}
