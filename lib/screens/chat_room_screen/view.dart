import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uni_chat_app/constant/constant.dart';
import 'package:uni_chat_app/model/chat_message_model.dart';
import 'package:uni_chat_app/model/user_model.dart';
import 'package:uni_chat_app/screens/chat_details_screen/view.dart';
import 'package:uni_chat_app/widgets/chat_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  TextEditingController message = TextEditingController();
  final chatUserDetails = Get.find<ChatUserDetails>();
  final userDetails = Get.find<UserDetails>();
  final ImagePicker _picker = ImagePicker();
  final ScrollController _controller = ScrollController();
  void _scrollDown() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  late final storageRef;
  bool isLoading = false;
  @override
  void initState() {
    storageRef = FirebaseStorage.instance.ref();
// TODO: implement initState
    super.initState();
  }

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
            onTap: ()async{
              Get.to(ChatDetailsScreen());
            },
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
                      .collection("chat")
                      .doc(userDetails.uid.toString() +
                          chatUserDetails.uid.toString())
                      .collection(userDetails.uid.toString() +
                          chatUserDetails.uid.toString())
                      .orderBy("timestamp")
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
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      await Future.delayed(Duration(seconds: 1), () {
                        if (_controller.hasClients) {
                          _controller
                              .jumpTo(_controller.position.maxScrollExtent);
                        }
                      });
                    });
                    return Expanded(
                      child: ListView.builder(
                          controller: _controller,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: msg.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              trailing: CircleAvatar(
                                backgroundColor: msg[index].msgOwner ==
                                        userDetails.name.value
                                    ? themeColor1
                                    : Colors.white,
                                child: Text(
                                  msg[index]
                                      .msgOwner
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
                                backgroundColor: msg[index].msgOwner !=
                                        userDetails.name.value
                                    ? themeColor1
                                    : Colors.white,
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    msg[index].isImage
                                        ? Image.memory(
                                            msg[index].image!.bytes,
                                          )
                                        : msg[index].isDocument
                                            ? InkWell(
                                      onTap:()async{
                                        await canLaunch(msg[index].document!) ? await launch(msg[index].document!) : Fluttertoast.showToast(
                                            msg: "Somethings went wrong",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      },
                                              child: Row(
                                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                        msg[index].message.toString(),
                                                        textAlign: TextAlign.start,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                      ),
                                                  ),
                                                  Container(
                                                    padding:EdgeInsets.all(width * 0.01),
                                                      decoration:BoxDecoration(
                                                        borderRadius: BorderRadius.circular(width),
                                                        border: Border.all(color: Colors.white)
                                                      ),
                                                      child: Icon(Icons.download,color: Colors.white,size: width * 0.04,))
                                                ],
                                              ),
                                            )
                                            : Text(
                                                msg[index].message.toString(),
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                    SizedBox(
                                      height: width * 0.02,
                                    ),
                                    Text(
                                      readTimestamp(
                                          int.parse(msg[index].timestamp)),
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: width * 0.04),
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
                          onPressed: () async {
                            final XFile? photo = await _picker
                                .pickImage(
                                    source: ImageSource.camera,
                                    imageQuality: 10)
                                .then((value) async {
                              var chatPath = FirebaseFirestore.instance
                                  .collection("chat")
                                  .doc(userDetails.uid.toString() +
                                      chatUserDetails.uid.toString())
                                  .collection(userDetails.uid.toString() +
                                      chatUserDetails.uid.toString())
                                  .doc();
                              chatPath.set({
                                "my_name": userDetails.name.value.toString(),
                                "friend_name":
                                    chatUserDetails.name.value.toString(),
                                "friend_uid":
                                    chatUserDetails.uid.value.toString(),
                                "is_image": true,
                                "message": "picture",
                                "is_document": false,
                                "document": null,
                                "msg_owner": userDetails.name.value.toString(),
                                "image": Blob(await value!.readAsBytes()),
                                "uid": userDetails.uid.value.toString(),
                                "seen": false,
                                "timestamp":
                                    DateTime.now().millisecondsSinceEpoch,
                              });
                            });
                          },
                          icon: Icon(Icons.camera_alt_outlined)),
                      IconButton(
                          onPressed: () async {
                            final XFile? photo = await _picker
                                .pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 10)
                                .then((value) async {
                              var chatPath = FirebaseFirestore.instance
                                  .collection("chat")
                                  .doc(userDetails.uid.toString() +
                                      chatUserDetails.uid.toString())
                                  .collection(userDetails.uid.toString() +
                                      chatUserDetails.uid.toString())
                                  .doc();
                              chatPath.set({
                                "my_name": userDetails.name.value.toString(),
                                "friend_name":
                                    chatUserDetails.name.value.toString(),
                                "friend_uid":
                                    chatUserDetails.uid.value.toString(),
                                "is_image": true,
                                "message": "picture",
                                "is_document": false,
                                "document": null,
                                "msg_owner": userDetails.name.value.toString(),
                                "image": Blob(await value!.readAsBytes()),
                                "uid": userDetails.uid.value.toString(),
                                "seen": false,
                                "timestamp":
                                    DateTime.now().millisecondsSinceEpoch,
                              });
                            });
                          },
                          icon: Icon(Icons.image)),
                      IconButton(
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf', 'doc'],
                            );
                            if (result != null) {
                              File file = await File(result.files.single.path!);
                              FirebaseStorage _storage =
                                  FirebaseStorage.instance;
                              Reference reference =
                                  _storage.ref().child("${result.names[0]}/");
                              print(file.path);
                              var uploadTask = await reference.putFile(file);
                              var dd = await reference.getDownloadURL();
                              print(dd);
                              var chatPath = FirebaseFirestore.instance
                                  .collection("chat")
                                  .doc(userDetails.uid.toString() +
                                      chatUserDetails.uid.toString())
                                  .collection(userDetails.uid.toString() +
                                      chatUserDetails.uid.toString())
                                  .doc();
                              chatPath.set({
                                "my_name": userDetails.name.value.toString(),
                                "friend_name":
                                    chatUserDetails.name.value.toString(),
                                "friend_uid":
                                    chatUserDetails.uid.value.toString(),
                                "is_image": false,
                                "message": result.names[0],
                                "is_document": true,
                                "document": dd,
                                "msg_owner": userDetails.name.value.toString(),
                                "image": null,
                                "uid": userDetails.uid.value.toString(),
                                "seen": false,
                                "timestamp":
                                    DateTime.now().millisecondsSinceEpoch,
                              });
                            }
                          },
                          icon: Icon(Icons.file_open_rounded)),
                      Container(
                        width: width * 0.5,
                        margin: EdgeInsets.symmetric(
                            vertical: width * 0.04, horizontal: width * 0.04),
                        child: TextField(
                          maxLines: null,
                          controller: message,
                          decoration: InputDecoration(
                            filled: true,
                            suffixIcon: IconButton(
                              onPressed: () async {
                                var friend = await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(chatUserDetails.uid.toString())
                                    .update({
                                  "user_chat_link": FieldValue.arrayUnion([
                                    userDetails.uid.toString() +
                                        chatUserDetails.uid.toString()
                                  ])
                                });
                                var me = await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(userDetails.uid.toString())
                                    .update({
                                  "user_chat_link": FieldValue.arrayUnion([
                                    userDetails.uid.toString() +
                                        chatUserDetails.uid.toString()
                                  ])
                                });
                                var chatPath = FirebaseFirestore.instance
                                    .collection("chat")
                                    .doc(userDetails.uid.toString() +
                                        chatUserDetails.uid.toString())
                                    .collection(userDetails.uid.toString() +
                                        chatUserDetails.uid.toString())
                                    .doc();
                                chatPath.set({
                                  "my_name": userDetails.name.value.toString(),
                                  "friend_name":
                                      chatUserDetails.name.value.toString(),
                                  "friend_uid":
                                      chatUserDetails.uid.value.toString(),
                                  "is_image": false,
                                  "message": message.text.trim(),
                                  "is_document": false,
                                  "document": null,
                                  "msg_owner":
                                      userDetails.name.value.toString(),
                                  "image": null,
                                  "uid": userDetails.uid.value.toString(),
                                  "seen": false,
                                  "timestamp":
                                      DateTime.now().millisecondsSinceEpoch,
                                });
                                message.clear();
                              },
                              icon: Icon(Icons.send,
                                  size: width * 0.06, color: themeColor1),
                            ),
                            fillColor: Colors.grey.shade300,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: width * 0.04,
                                vertical: width * 0.04),
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
