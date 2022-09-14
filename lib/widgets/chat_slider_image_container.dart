
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SliderImageContainer extends StatelessWidget {
  const SliderImageContainer({
    Key? key,
    required this.width,
    required this.mainImage,
    required this.profileImage,
    required this.name,
    required this.disc,
  }) : super(key: key);

  final double width;
  final String mainImage;
  final String profileImage;
  final String name;
  final String disc;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height:150,
                decoration: BoxDecoration(
                    color:Colors.white,
                    borderRadius: BorderRadius.circular(width * 0.02)
                ),
                padding: EdgeInsets.symmetric(horizontal: width * 0.07,vertical: width * 0.07 ),
                child: SvgPicture.asset(mainImage,width: 200,height: 200,),),
              SizedBox(height: width * 0.071,),
              Row(children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child:Image.asset(profileImage,scale: 10,) ,
                ),
                SizedBox(width: width * 0.071,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    Text(disc,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w100),)

                  ],)
              ],)
            ],
          ),
        ],
      ),
    );
  }
}
