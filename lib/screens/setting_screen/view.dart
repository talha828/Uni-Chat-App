import 'package:flutter/material.dart';
import 'package:uni_chat_app/constant/constant.dart';
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
                leading: Icon(Icons.person,color: themeColor1,),
                  title: Text("Edit Profile"),
              ),
            ListTile(
              leading: Icon(Icons.mood_bad_outlined,color: themeColor1,),
              title: Text("Complain Box"),
            ),
            ListTile(
              leading: Icon(Icons.bug_report_outlined,color: themeColor1,),
              title: Text("Bug Report"),
            ),
            ListTile(
              leading: Icon(Icons.info_outline,color: themeColor1,),
              title: Text("About Us"),
            ),
            ListTile(
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
