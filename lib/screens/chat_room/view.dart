import 'package:flutter/material.dart';
import 'package:uni_chat_app/constant/constant.dart';
import 'package:uni_chat_app/widgets/chat_progress_indicator.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  TextEditingController message=TextEditingController();
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    var width =MediaQuery.of(context).size.width;
    var height =MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios_new,),
      title: ListTile(
        leading: CircleAvatar(
          radius: width * 0.04,
          backgroundColor:themeColor1,
          child: Text("H",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: width * 0.04),),
        ),
        title: Text("Talha Iqbal",style: TextStyle(fontSize: width * 0.05,fontWeight: FontWeight.bold),),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.all(width * 0.03),
          child: Icon(Icons.list,color:themeColor1,size: width * 0.08,),
        ),
      ],
    ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    child: SizedBox(),
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
                      IconButton(onPressed: (){}, icon: Icon(Icons.camera_alt_outlined)),
                      IconButton(onPressed: (){}, icon: Icon(Icons.file_open_rounded)),
                      Container(
                        width: width * 0.65,
                        margin: EdgeInsets.symmetric(vertical: width * 0.04,horizontal: width * 0.04),
                        child:TextField(
                          controller: message,
                          decoration: InputDecoration(
                            filled: true,
                            suffixIcon: Icon(Icons.send,size: width * 0.06,color: themeColor1,),
                            fillColor: Colors.grey.shade300,
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: width * 0.04),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
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
            isLoading?const Positioned.fill(child: ChatProgressIndicator()):Container()
          ],
        ),
      ),
    );
  }
}
