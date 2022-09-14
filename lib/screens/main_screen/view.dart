import 'package:carousel_slider/carousel_slider.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uni_chat_app/constant/constant.dart';
import 'package:uni_chat_app/screens/login_screen/view.dart';
import 'package:uni_chat_app/widgets/chat_image_container.dart';
import 'package:uni_chat_app/widgets/chat_slider_image_container.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget>list=[DiscoverGroupScreen(),LoginScreen(),LoginScreen(),LoginScreen(),LoginScreen(),];
  int index=0;

  @override
  Widget build(BuildContext context) {
    var width =MediaQuery.of(context).size.width;
    var height =MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: FloatingNavbar(
          selectedBackgroundColor: themeColor2,
          selectedItemColor: Colors.white,
          backgroundColor:Colors.white,
          unselectedItemColor: Colors.black,
          onTap: (int val) {
           setState(() {
             index=val;
           });
          },
          currentIndex: index,
          items: [
            FloatingNavbarItem(icon: Icons.home, title: 'Home'),
            FloatingNavbarItem(icon: Icons.search, title: 'Explore'),
            FloatingNavbarItem(icon: Icons.message, title: 'Chats'),
            FloatingNavbarItem(icon: Icons.notifications_none_outlined, title: 'Settings'),
            FloatingNavbarItem(icon: Icons.person, title: 'Settings'),
          ],
        ),
        body: list.elementAt(index)
      ),
    );
  }
}


class DiscoverGroupScreen extends StatefulWidget {
  const DiscoverGroupScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverGroupScreen> createState() => _DiscoverGroupScreenState();
}

class _DiscoverGroupScreenState extends State<DiscoverGroupScreen> {
  String name="Talha Iqbal";
  String disc="Jorden";
  String profileImage="assets/logo/logo.png";
  String mainImage="assets/svg_images/sign_up.svg";
  @override
  Widget build(BuildContext context) {
    var width =MediaQuery.of(context).size.width;
    var height =MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        themeColor1,
                        themeColor2
                      ],
                    ),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(width * 0.06,),bottomRight: Radius.circular(width * 0.06,))
                ),
                height: height / 3,
                child: CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    height: width * 0.6,
                  ),
                  items: [
                    SliderImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc) ,
                    SliderImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc) ,
                    SliderImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc) ,
                    SliderImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc) ,
                    SliderImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc) ,
                    SliderImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc) ,
                    SliderImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc) ,
                    SliderImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc) ,
                    SliderImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc) ,
                    SliderImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc) ,
                    SliderImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc) ,
                    SliderImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc) ,
                    SliderImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc) ,
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: width * 0.05,horizontal: width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Group Me you Like",style: TextStyle(fontWeight: FontWeight.bold,fontSize: width * 0.05),),
                    SizedBox(height: width * 0.07,),
                    GridView.count(
                      crossAxisSpacing: width *0.04,
                      mainAxisSpacing: width * 0.04,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      children: [
                        ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                        ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                        ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                        ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                        ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                        ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                        ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                        ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                        ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                        ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                        ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

