import 'package:flutter/material.dart';
import 'package:uni_chat_app/constant/constant.dart';
import 'package:uni_chat_app/widgets/chat_notification_tile.dart';
import 'package:uni_chat_app/widgets/chat_progress_indicator.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading=false;
  String name="talha";
  String msg="kuch v";
  String  time="10:00 PM";
  String  number="3+";
  @override
  Widget build(BuildContext context) {
    var width =MediaQuery.of(context).size.width;
    var height =MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back_ios_new,color: Colors.white,),
          title: Center(child: Text("Notification",style: TextStyle(color: themeColor1),),),
          actions: [
            Icon(Icons.arrow_back_ios_new,color: Colors.white,),
          ],
        ),
        body: Stack(
          children: [
            Container(
              child:ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context,index){
                    return NotificationTile(name: name, width: width, msg: msg, number: number,onTap: (){},);
                  }, separatorBuilder: (context,index){
                return Container(
                    margin: EdgeInsets.symmetric(horizontal: width * 0.04),
                    child: Divider());
              }, itemCount: 5),
            ),
            isLoading?const Positioned.fill(child: ChatProgressIndicator()):Container()
          ],
        ),
      ),
    );
  }
}


