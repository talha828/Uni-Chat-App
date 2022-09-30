import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_chat_app/constant/constant.dart';
import 'package:uni_chat_app/screens/complainbox_screen/view.dart';
import 'package:uni_chat_app/screens/create_group_screen/view.dart';
import 'package:uni_chat_app/screens/edit_screen/view.dart';
import 'package:uni_chat_app/screens/group_explore_screen/view.dart';
import 'package:uni_chat_app/screens/login_screen/view.dart';
import 'package:uni_chat_app/widgets/chat_progress_indicator.dart';


class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    var width =MediaQuery.of(context).size.width;
    var height =MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back_ios_new,color: Colors.white,),
          title: Center(child: Text("Settings",style: TextStyle(color: themeColor1),)),
          actions: [
            Icon(Icons.arrow_back_ios_new,color: Colors.white,),
          ],
        ),
        body: Column(
          children: [
            ListTile(
              onTap: ()async{
                Get.to(CreateGroupScreen());
              },
              leading: Icon(Icons.group,color: themeColor1,),
              title: Text("Create Group"),
            ),
            ListTile(
              onTap: ()=>
                Get.to(GroupExploreScreen()),
              leading: Icon(Icons.group_add,color: themeColor1,),
              title: Text("Join Group"),
            ),
            ListTile(
              onTap: ()=>Get.to(EditScreen()),
              leading: Icon(Icons.person,color: themeColor1,),
              title: Text("Edit Profile"),
            ),
            ListTile(
              onTap: ()=>Get.to(ComplainBoxScreen()),
              leading: Icon(Icons.mood_bad_outlined,color: themeColor1,),
              title: Text("Complain Box"),
            ),
            ListTile(
              onTap: ()async{
                SharedPreferences prefs=await SharedPreferences.getInstance();
                prefs.setString("email", "null");
                prefs.setString("password", "null");
                Get.to(LoginScreen());
              },
              leading: Icon(Icons.logout,color: themeColor1,),
              title: Text("Logout"),
            ),
            isLoading?const Positioned.fill(child: ChatProgressIndicator()):Container()
          ],
        ),
      ),
    );
  }
}
