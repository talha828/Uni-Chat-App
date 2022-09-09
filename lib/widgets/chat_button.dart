import 'package:flutter/material.dart';

class ChatButton extends StatelessWidget {
   ChatButton({
    Key key,
    @required this.width,
    @required this.name,
    @required this.onTap
  }) : super(key: key);

  final double width;
  final String name;
  Function  onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap ,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xff3d2f90),
                  Color(0xffe11f7b),

                ]
            ),
            borderRadius: BorderRadius.circular(width * 0.5)
        ),
        padding: EdgeInsets.symmetric(vertical: width * 0.03,),
        child: Text(name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: width * 0.05),),
      ),
    );
  }
}

