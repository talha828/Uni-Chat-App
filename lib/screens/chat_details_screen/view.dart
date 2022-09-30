import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uni_chat_app/constant/constant.dart';
import 'package:uni_chat_app/model/chat_message_model.dart';
import 'package:uni_chat_app/model/user_model.dart';

class ChatDetailsScreen extends StatefulWidget {
  const ChatDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen>
    with SingleTickerProviderStateMixin {
  final chatUserDetails = Get.find<ChatUserDetails>();
  final userDetails = Get.find<UserDetails>();
  late TabController _tabController;
  List<String> list = [
    "assets/png_images/logic.png",
    "assets/png_images/logic.png",
    "assets/png_images/logic.png",
    "assets/png_images/logic.png",
    "assets/png_images/logic.png",
    "assets/png_images/logic.png",
    "assets/png_images/logic.png",
    "assets/png_images/logic.png",
    "assets/png_images/logic.png",
    "assets/png_images/logic.png",
    "assets/png_images/logic.png",
    "assets/png_images/logic.png",
  ];
  @override
  void initState() {
    // TODO: implement initState
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton( icon:Icon(Icons.arrow_back_ios),onPressed: ()=>Navigator.pop(context),),
          elevation: 0,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.04, vertical: width * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: width * 0.02,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      //color: Colors.blue,
                      border: Border.all(color: themeColor1),
                      borderRadius: BorderRadius.circular(width * 1),
                    ),
                    child: CircleAvatar(
                      backgroundColor: themeColor1,
                      radius: width * 0.15,
                      child: Text(chatUserDetails.name.substring(0,1),style: TextStyle(fontSize: width * 0.2,color: Colors.white),),
                    )
                  ),
                ],
              ),
              SizedBox(
                height: width * 0.08,
              ),
              Text(
                chatUserDetails.name.value,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: width * 0.07),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: width * 0.04,
              ),
              Text(
                chatUserDetails.email.value,
                style: TextStyle(
                    color: Colors.grey.shade600, fontSize: width * 0.045),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: width * 0.04,
              ),
              Text(
                chatUserDetails.specialization.value,
                style: TextStyle(
                    color: Colors.grey.shade600, fontSize: width * 0.045),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: width * 0.08,
              ),
              TabBar(
                unselectedLabelColor: Colors.black,
                labelColor: themeColor1,
                indicatorColor: themeColor1,
                tabs: [
                  Tab(
                    icon: Icon(Icons.image),
                  ),
                  Tab(
                    icon: Icon(Icons.file_present),
                  ),
                ],
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Container(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                    .collection("chat")
                    .doc(userDetails.uid.toString() +
                    chatUserDetails.uid.toString())
                    .collection(userDetails.uid.toString() +
                    chatUserDetails.uid.toString()).where("is_image",isEqualTo: true)
                    .orderBy("timestamp",descending: true)
                    .snapshots(),
                        builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
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
                          if (snapshot.hasError) // TODO: show alert
                            return Text('Something went wrong');

                          if (snapshot.connectionState == ConnectionState.waiting)
                            return Column(
                              children: [Center(child: CircularProgressIndicator())],
                            );
                          if(snapshot.data!.docs.length <1){
                            return Center(child: Text("No records are found"),);
                          }
                          return GridView.count(
                              crossAxisSpacing: width * 0.01,
                              mainAxisSpacing: width * 0.01,
                              crossAxisCount: 3,
                              children: msg
                                  .map((e) => Container(
                                        color: Colors.blue,
                                        child: Image.memory(
                                          e.image!.bytes,
                                          fit: BoxFit.cover,
                                          width: width * 0.04,
                                          height: width * 0.04,
                                        ),
                                      ))
                                  .toList());
                        }
                      ),
                    ),
                    Container(
                      child: StreamBuilder(
                        stream:FirebaseFirestore.instance
                            .collection("chat")
                            .doc(userDetails.uid.toString() +
                            chatUserDetails.uid.toString())
                            .collection(userDetails.uid.toString() +
                            chatUserDetails.uid.toString()).where("is_document",isEqualTo: true)
                            .orderBy("timestamp",descending: true)
                            .snapshots(),
                        builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
                          if(snapshot.data!.docs.length <1){
                            return Center(child: Text("No records are found"),);
                          }
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
                          return ListView.separated(
                            separatorBuilder: (context,index){
                              return Divider();
                            },
                            itemCount: msg.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading:Icon(Icons.file_present,color: Colors.black,size: width * 0.08,),
                                title: Text(msg[index].message.toString(),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                //subtitle: Text("12kb      .      Sunday"),
                                trailing: Text(
                                  readTimestamp(
                                      int.parse(msg[index].timestamp)),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: width * 0.04),
                                ),
                              );
                            },
                          );
                        }
                      ),
                    ),
                  ],
                  controller: _tabController,
                ),
              ),
            ],
          ),
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
