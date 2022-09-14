import 'package:flutter/material.dart';

class ChatProgressIndicator extends StatelessWidget {
  const ChatProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.black38,child: Center(child: CircularProgressIndicator(color: Color(0xff3d2f90),backgroundColor: Color(0xffe11f7b),),),);
  }
}
