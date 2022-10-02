import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uni_chat_app/constant/constant.dart';
import 'package:uni_chat_app/model/Group_chat_model.dart';
import 'package:uni_chat_app/model/chat_message_model.dart';
import 'package:uni_chat_app/screens/group_chat_room/view.dart';
import 'package:uni_chat_app/widgets/chat_button.dart';

import '../../widgets/chat_text_field.dart';
enum GroupType{academic ,activity}
enum GroupClass{private,public}
class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  TextEditingController group = TextEditingController();
  TextEditingController description = TextEditingController();
  FilePickerResult? result;
  final _formKey = GlobalKey<FormState>();
  final groupDetails = Get.put(GroupChatModel());
  GroupType value=GroupType.activity;
  GroupClass value1=GroupClass.public;
  final ImagePicker _picker = ImagePicker();
  File? image;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            "Create Group",
            style: TextStyle(color: themeColor1),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: width * 0.04,
                    ),
                    InkWell(
                      onTap: () async {
                         result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['png', 'jpg', "jpeg"],
                        );
                        image = File(result!.files.single.path!);
                        setState(() {});
                      },
                      child: image == null
                          ? CircleAvatar(
                              radius: width * 0.19,
                              backgroundColor: themeColor1.withOpacity(0.7),
                              child: Icon(
                                Icons.add_a_photo_outlined,
                                size: width * 0.18,
                                color: Colors.white,
                              ),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: width * 0.2,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(width),
                                  child: Image.file(
                                    image!,
                                    width: width * 0.4,
                                    fit: BoxFit.fill,
                                    height: width * 0.4,
                                  )),
                            ),
                    ),
                    LoginTextField(
                      controller: group,
                      obscureText: false,
                      width: width,
                      hintText: "Group Name",
                    ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: width * 0.04,
                    ),
                    Text(
                      "Group Type",
                      style: TextStyle(
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(
                      height: width * 0.04,
                    ),
                    ListTile(
                    title: const Text('Academic'),
            leading: Radio(
              value: GroupType.academic,
              groupValue: value,
              onChanged: (GroupType? check) {
                    setState(() {
                      value=check!;
                      print(check);

                    });
              },
            ),
          ),
                    ListTile(
                      title: const Text('Activity'),
                      leading: Radio(
                        value: GroupType.activity,
                        groupValue: value,
                        onChanged: (GroupType? check) {
                          setState(() {
                            value=check!;
                            print(check);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: width * 0.04,
                        ),
                        Text(
                          "Group Class",
                          style: TextStyle(
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(
                          height: width * 0.04,
                        ),
                        ListTile(
                          title: const Text('Private'),
                          leading: Radio(
                            value: GroupClass.private,
                            groupValue: value1,
                            onChanged: (GroupClass? check) {
                              setState(() {
                                value1=check!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Public'),
                          leading: Radio(
                            value: GroupClass.public,
                            groupValue: value1,
                            onChanged: (GroupClass? check) {
                              setState(() {
                                value1=check!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Description",
                            style: TextStyle(
                                fontSize: width * 0.05,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: width * 0.04,
                          ),
                          TextFormField(
                            maxLines: 3,
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Description';
                              }
                              return null;
                            },
                            controller: description,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade300,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * 0.04,
                                  vertical: width * 0.04),
                              border: InputBorder.none,
                              hintText: "Type description here ........",
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: width * 0.04,
                    ),
                    ChatButton(
                        width: width,
                        name: "Create Now",
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            if(image != null){
                              FirebaseAuth _auth=FirebaseAuth.instance;
                              groupDetails.groupInfo.clear();
                                groupDetails.groupInfo.add(
                                  GroupMessage(groupType: value1.toString(), groupImage:  Blob(await image!.readAsBytes()), desc: description.text, type: value==GroupType.activity?"Activity" :"Academic", myName: "", friendName: group.text.trim(), msgOwner: "", image: Blob(await image!.readAsBytes()), myUid: "", timestamp: "", seen: false, friendUid: "", isDocument: false, isImage: false)
                                  //GroupChatsModel(name: group.text, desc: description.text, link:_auth.currentUser!.uid+group.text.replaceAll(" ", "_"),groupType: value==GroupType.activity?"Activity" :"Academic" , image: Blob(await image!.readAsBytes()))
                                );
                                Get.to(GroupChatRoomScreen());
                            }else{
                              Fluttertoast.showToast(msg:"Image is required");
                            }
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
