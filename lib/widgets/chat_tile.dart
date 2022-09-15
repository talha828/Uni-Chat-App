import 'package:flutter/material.dart';
import 'package:uni_chat_app/constant/constant.dart';

class ChatTiles extends StatelessWidget {
  ChatTiles({
    Key? key,
    required this.name,
    required this.width,
    required this.msg,
    required this.time,
    required this.onTap,
  }) : super(key: key);

  final String name;
  final double width;
  final String msg;
  final String time;
  dynamic Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading:CircleAvatar(
        backgroundColor: themeColor1,
        child: Text(name.substring(0,1).toUpperCase(),style:TextStyle(fontSize: width * 0.06,fontWeight: FontWeight.bold,color: Colors.white),),
      ) ,
      title: Text(name,maxLines: 1,overflow: TextOverflow.ellipsis,),
      subtitle: Text(msg,maxLines: 1,overflow: TextOverflow.ellipsis,),
      trailing: Text(time,style: TextStyle(color: Colors.grey.shade600),),
    );
  }
}
