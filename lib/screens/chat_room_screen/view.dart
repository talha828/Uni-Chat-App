import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uni_chat_app/constant/constant.dart';
import 'package:uni_chat_app/model/chat_message_model.dart';
import 'package:uni_chat_app/model/user_model.dart';
import 'package:uni_chat_app/widgets/chat_progress_indicator.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  TextEditingController message = TextEditingController();
  final chatUserDetails = Get.find<ChatUserDetails>();
  final userDetails = Get.find<UserDetails>();
  final ScrollController _controller = ScrollController();
  void _scrollDown() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  bool isLoading = false;
  List<String> list = [
    "Hello talha",
    "how are your",
    "I am fine what about you?",
    "i want to known please submit your task and make sure bla bla bla"
  ];
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new),
          ),
          title: ListTile(
            leading: CircleAvatar(
              radius: width * 0.04,
              backgroundColor: themeColor1,
              child: Text(
                chatUserDetails.name.toString().substring(0, 1).toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.04),
              ),
            ),
            title: Text(
              chatUserDetails.name.toString(),
              style: TextStyle(
                  fontSize: width * 0.05, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: width * 0.04,
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chat").doc(userDetails.uid.toString() + chatUserDetails.uid.toString()).collection(userDetails.uid.toString() + chatUserDetails.uid.toString()).orderBy("timeStamp")
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
                            child: Text("No chats available",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey)),
                          )
                        ],
                      );

                    List<ChatMessage> msg = snapshot.data!.docs
                        .map((doc) => ChatMessage(
                        myName: doc['my_name'],
                        friendName: doc["friend_name"],
                        msgOwner: doc['message_owner'],
                        uid: doc['uid'],
                        seen: doc['seen'].toString(),
                        message: doc['message'],
                        timestamp: doc["timeStamp"].toString()))
                        .toList();
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_controller.hasClients) {
                        _controller.jumpTo(_controller.position.maxScrollExtent);
                        }});
                    return Expanded(
                      child: ListView.builder(
                        controller: _controller,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: msg.length,
                          itemBuilder: (context, index){
                            return ListTile(
                                          trailing: CircleAvatar(
                                            backgroundColor:
                                                msg[index].msgOwner ==userDetails.name.value ? themeColor1 : Colors.white,
                                            child: Text(
                                              msg[index].msgOwner
                                                  .toString()
                                                  .substring(0, 1)
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: width * 0.05),
                                            ),
                                          ),
                                          leading: CircleAvatar(
                                            backgroundColor:
                                            msg[index].msgOwner !=userDetails.name.value ? themeColor1 : Colors.white,
                                            child: Text(
                                              chatUserDetails.name
                                                  .toString()
                                                  .substring(0, 1)
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: width * 0.05),
                                            ),
                                          ),
                                          title: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: width * 0.04,
                                                horizontal: width * 0.04),
                                            decoration: BoxDecoration(
                                                color: themeColor1.withOpacity(0.9),
                                                borderRadius:
                                                    BorderRadius.circular(width * 0.02)),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: [
                                                Text(
                                                  msg[index].message,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                                SizedBox(height: width * 0.02,),
                                                Text(
                                                  readTimestamp(int.parse(msg[index].timestamp)),
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(color: Colors.white,fontSize: width * 0.04),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                          }),
                    );
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.camera_alt_outlined)),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.file_open_rounded)),
                      Container(
                        width: width * 0.65,
                        margin: EdgeInsets.symmetric(
                            vertical: width * 0.04, horizontal: width * 0.04),
                        child: TextField(
                          maxLines: null,
                          controller: message,
                          decoration: InputDecoration(

                            filled: true,
                            suffixIcon: IconButton(
                              onPressed: () async {
                                var friend=await FirebaseFirestore.instance.collection("users").doc(chatUserDetails.uid.toString()).update({"user_chat_link":FieldValue.arrayUnion([userDetails.uid.toString() + chatUserDetails.uid.toString()])});
                                var me=await FirebaseFirestore.instance.collection("users").doc(userDetails.uid.toString()).update({"user_chat_link":FieldValue.arrayUnion([userDetails.uid.toString() + chatUserDetails.uid.toString()])});
                                var chatPath=FirebaseFirestore.instance.collection("chat").doc(userDetails.uid.toString() + chatUserDetails.uid.toString()).collection(userDetails.uid.toString() + chatUserDetails.uid.toString()).doc();
                                 chatPath.set({
                                   "my_name":userDetails.name.value.toString(),
                                   "friend_name":chatUserDetails.name.value.toString(),
                                   "msg_owner":userDetails.name.value.toString(),
                                   "message":message.text.trim(),
                                   "uid":userDetails.uid.value.toString(),
                                   "seen":false,
                                   "timestamp":DateTime.now().millisecondsSinceEpoch,
                                 });
                                 message.clear();
                                },
                              icon: Icon(Icons.send,
                                  size: width * 0.06, color: themeColor1),
                            ),
                            fillColor: Colors.grey.shade300,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: width * 0.04,vertical: width * 0.04),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(width * 0.04),
                            ),
                            hintText: "Type ..",
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
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

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
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
