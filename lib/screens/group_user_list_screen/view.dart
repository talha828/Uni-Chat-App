import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_chat_app/constant/constant.dart';
import 'package:uni_chat_app/model/Group_chat_model.dart';
import 'package:uni_chat_app/model/user_model.dart';

class GroupUserListScreen extends StatefulWidget {
  const GroupUserListScreen({Key? key}) : super(key: key);

  @override
  State<GroupUserListScreen> createState() => _GroupUserListScreenState();
}

class _GroupUserListScreenState extends State<GroupUserListScreen> {
  
  final chatUserDetails=Get.find<GroupChatModel>();
  @override
  Widget build(BuildContext context) {
  var width  = MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
      appBar:AppBar(
        leading: IconButton(
          onPressed: ()=>Navigator.pop(context),
          icon:Icon(Icons.arrow_back_ios_new),
        ),
        title: Center(
            child: Text(
              "Group Users",
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
        padding: EdgeInsets.symmetric(vertical: width * 0.02),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("users").where(chatUserDetails.groupInfo[0].type=="Activity"?"activity_group_link":"Academic_group_link",arrayContains: chatUserDetails.groupInfo[0].friendName).snapshots(),
            builder: (context,AsyncSnapshot<QuerySnapshot>snapshot){
              List<MyUser> shops = snapshot.data!.docs
                  .map((doc) => MyUser(
                  name: doc['name'],
                  uid: doc['uid'],
                  password: doc['password'],
                  email: doc['email'],
                  specialization: doc["specialization"]))
                  .toList();
          return ListView.builder(
            itemCount: shops.length,
            itemBuilder:(context,index){
              return Container(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: themeColor1,
                        child: Text(shops[index].name.substring(0,1).toUpperCase(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      ),
                      title: Text(shops[index].name.toUpperCase()),
                      subtitle: Text(shops[index].email),
                      trailing: InkWell(
                        onTap: ()async{
                          await FirebaseFirestore.instance.collection("users").doc(shops[index].uid).update({
                            chatUserDetails.groupInfo[0].type=="Activity"?"activity_group_link":"Academic_group_link":FieldValue.arrayRemove([chatUserDetails.groupInfo[0].friendName])
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width * 0.02),
                          color: themeColor1,
                          ),
                          padding: EdgeInsets.symmetric(vertical: width * 0.02,horizontal: width * 0.04),
                          child: Text("Delete",style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ),
            );}
          );
        }),
      ),
    ));
  }
}
