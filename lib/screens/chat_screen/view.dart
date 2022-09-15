import 'package:flutter/material.dart';
import 'package:uni_chat_app/widgets/chat_progress_indicator.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController search=TextEditingController();
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    var width =MediaQuery.of(context).size.width;
    var height =MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
             Container(
               child: Column(
                 children: [
                   Container(
                     
                      child:TextField(
                        controller: search,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: width * 0.04),
                          border: InputBorder.none,
                          hintText: "Search",
                        ),
                      ),
                    ),
                 ],
               ),
             ),
            isLoading?const Positioned.fill(child: ChatProgressIndicator()):Container()
          ],
        ),
      ),
    );
  }
}
