
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uni_chat_app/constant/constant.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    Key? key,
    required this.width,
    required this.mainImage,
    required this.profileImage,
    required this.name,
    required this.disc,
  }) : super(key: key);

  final double width;
  final Blob mainImage;
  final String profileImage;
  final String name;
  final String disc;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment:Alignment.bottomRight,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: width * 0.05,horizontal: width *0.07),
            decoration:BoxDecoration(
                borderRadius: BorderRadius.circular(width * 0.021),
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      themeColor1,
                      themeColor2
                    ]
                )
            ),
            child: Image.memory(mainImage.bytes),
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Colors.black26,
                      Colors.black12
                    ]
                )
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: width * 0.04,
                    backgroundColor: Colors.white,
                    child:Image.asset(profileImage,scale: 15,) ,
                  ),
                  SizedBox(width: width * 0.04,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: width * 0.035),),
                      Text(disc,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w100,fontSize: width * 0.03),)

                    ],)
                ],),
            ),
          )
        ],
      ),
    );
  }
}
