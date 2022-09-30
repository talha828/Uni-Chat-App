import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uni_chat_app/constant/constant.dart';
import 'package:uni_chat_app/model/chat_message_model.dart';
import 'package:uni_chat_app/screens/chat_screen/view.dart';
import 'package:uni_chat_app/screens/explore_screen/view.dart';
import 'package:uni_chat_app/screens/login_screen/view.dart';
import 'package:uni_chat_app/screens/notification_screen/view.dart';
import 'package:uni_chat_app/screens/setting_screen/view.dart';
import 'package:uni_chat_app/widgets/chat_image_container.dart';
import 'package:uni_chat_app/widgets/chat_progress_indicator.dart';
import 'package:uni_chat_app/widgets/chat_slider_image_container.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget>list=[DiscoverGroupScreen(),ExploreScreen(),ChatScreen(),SettingScreen(),];
  int index=0;

  @override
  Widget build(BuildContext context) {
    var width =MediaQuery.of(context).size.width;
    var height =MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: FloatingNavbar(
          elevation: 1.0,
          selectedBackgroundColor: themeColor1,
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

class _DiscoverGroupScreenState extends State<DiscoverGroupScreen> with SingleTickerProviderStateMixin{
  String name="Talha Iqbal";
  String disc="Activity";
  String profileImage="assets/logo/logo.png";
  String mainImage="assets/svg_images/sign_up.svg";

  Future<List<String>>getAcademicGroup()async{
    List<String>list=[];
    var activity =await FirebaseFirestore.instance.collection("group_list").doc("Academic").get().then((subCollection)async{
      print(subCollection["group_list"]);
      for(var i in subCollection["group_list"]){
        list.add(i);
        print(i);
      }
      return subCollection;
    });
    return list;
  }
  Future<List<String>>getActivityGroup()async{
    List<String>list=[];
    var activity =await FirebaseFirestore.instance.collection("group_list").doc("activity").get().then((subCollection)async{
      print(subCollection["group_list"]);
      for(var i in subCollection["group_list"]){
        list.add(i);
        print(i);
      }
      return subCollection;
    });
    return list;
  }
  late TabController _tabController;
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var width =MediaQuery.of(context).size.width;
    var height =MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
         Icons.arrow_back_ios_new,
          color: Colors.white,
        ),
        title: Center(
            child: Text(
              "Discover Groups",
              style: TextStyle(color: themeColor1),
            )),
        actions: [
          Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ],
      ),
      body: Container(
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TabBar(
                unselectedLabelColor: Colors.black,
                labelColor: themeColor1,
                indicatorColor: themeColor1,
                tabs: [
                  Tab(
                    text: "Academic",
                  ),
                  Tab(
                    text: "Activity",
                  ),
                ],
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
             Expanded(
               child: TabBarView(
                   controller: _tabController,
                   children: [
                     Container(
                       padding: EdgeInsets.symmetric(vertical: width * 0.05,horizontal: width * 0.05),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text("Academic Group",style: TextStyle(fontWeight: FontWeight.bold,fontSize: width * 0.05),),
                           SizedBox(height: width * 0.07,),
                           FutureBuilder<List<String>>(
                               future: getAcademicGroup(),
                               builder: (context,snapshot) {
                                 if(snapshot.connectionState==ConnectionState.waiting)
                                   return CircularProgressIndicator();
                                 if(snapshot.hasError)
                                   return Text("No records founds");
                                 return ListView.builder(
                                     shrinkWrap: true,
                                     itemCount: snapshot.data!.length,
                                     itemBuilder: (context, index) {
                                       return Container(
                                         child: StreamBuilder(
                                           stream: FirebaseFirestore.instance
                                               .collection("groups").doc("Academic").collection(snapshot.data![index]).orderBy("timestamp",descending: true).limit(1)
                                               .snapshots(),
                                           builder: (BuildContext context,
                                               AsyncSnapshot<QuerySnapshot> snapshot) {
                                             if (snapshot.hasError) // TODO: show alert
                                               return Center(child: Text('Something went wrong'));

                                             if (snapshot.connectionState == ConnectionState.waiting)
                                               return Column(
                                                 children: [Center(child: ChatProgressIndicator())],
                                               );

                                             var len = snapshot.data!.docs.length;
                                             if (len == 0)
                                               return Column(
                                                 children: [
                                                   SizedBox(height: 100),
                                                   Center(
                                                     child: Text("No shops available",
                                                         style: TextStyle(
                                                             fontSize: 20, color: Colors.grey)),
                                                   )
                                                 ],
                                               );

                                             List<GroupMessage> shops = snapshot.data!.docs
                                                 .map(
                                                   (doc) => GroupMessage(
                                                 groupImage: doc["group_image"],
                                                 desc:doc["description"] ,
                                                 type: doc["group_type"],
                                                 myName: doc['my_name'],
                                                 friendName: doc["friend_name"],
                                                 msgOwner: doc['msg_owner'],
                                                 myUid: doc['uid'],
                                                 seen: doc['seen'],
                                                 image: doc["image"],
                                                 timestamp: doc["timestamp"].toString(),
                                                 friendUid: doc['friend_uid'],
                                                 isDocument: doc['is_document'],
                                                 document: doc['document'],
                                                 isImage: doc['is_image'],
                                                 message: doc['message'],
                                               ),
                                             )
                                                 .toList();

                                             return Expanded(
                                               child: ListView.builder(
                                                   padding: EdgeInsets.symmetric(vertical: 15),
                                                   scrollDirection: Axis.vertical,
                                                   shrinkWrap: true,
                                                   itemCount: shops.length,
                                                   itemBuilder: (context, index){
                                                     return  ImageContainer(width: width, mainImage: shops[index].groupImage, profileImage: profileImage, name: shops[index].friendName, disc: disc);

                                                     //   ListTile(
                                                     //   onTap: ()async{
                                                     //     // groupDetails.groupInfo.clear();
                                                     //     // groupDetails.groupInfo.add(shops[index]);
                                                     //     // Get.to(GroupChatRoomScreen());
                                                     //   },
                                                     //   leading: CircleAvatar(
                                                     //       backgroundColor: themeColor1,
                                                     //       child: ClipRRect(
                                                     //           borderRadius: BorderRadius.circular(width * 0.2),
                                                     //           child: Image.memory(shops[index].groupImage.bytes))),
                                                     //   title: Text(shops[index].friendName),
                                                     //   subtitle: Text(shops[index].desc),
                                                     //   trailing: CircleAvatar(
                                                     //     backgroundColor: Colors.white,
                                                     //     child: Icon(Icons.send,color: themeColor1,),),
                                                     // );
                                                   }),
                                             );
                                           },
                                         ),
                                       );
                                     }
                                 );
                               }
                           )
                           // GridView.count(
                           //   crossAxisSpacing: width *0.04,
                           //   mainAxisSpacing: width * 0.04,
                           //   physics: NeverScrollableScrollPhysics(),
                           //   shrinkWrap: true,
                           //   crossAxisCount: 2,
                           //   children: [
                           //     ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                           //     ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                           //     ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                           //     ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                           //     ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                           //     ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                           //     ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                           //     ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                           //     ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                           //     ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                           //     ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                           //   ],
                           // ),
                         ],
                       ),
                     ),
                     Container(
                       padding: EdgeInsets.symmetric(vertical: width * 0.05,horizontal: width * 0.05),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text("Activity Group",style: TextStyle(fontWeight: FontWeight.bold,fontSize: width * 0.05),),
                           SizedBox(height: width * 0.07,),
                           FutureBuilder<List<String>>(
                               future: getActivityGroup(),
                               builder: (context,snapshot) {
                                 if(snapshot.connectionState==ConnectionState.waiting)
                                   return CircularProgressIndicator();
                                 if(snapshot.hasError)
                                   return Text("No records founds");
                                 return ListView.builder(
                                     shrinkWrap: true,
                                     itemCount: snapshot.data!.length,
                                     itemBuilder: (context, index) {
                                       return Container(
                                         child: StreamBuilder(
                                           stream: FirebaseFirestore.instance
                                               .collection("groups").doc("Activity").collection(snapshot.data![index]).orderBy("timestamp",descending: true).limit(1)
                                               .snapshots(),
                                           builder: (BuildContext context,
                                               AsyncSnapshot<QuerySnapshot> snapshot) {
                                             if (snapshot.hasError) // TODO: show alert
                                               return Center(child: Text('Something went wrong'));

                                             if (snapshot.connectionState == ConnectionState.waiting)
                                               return Column(
                                                 children: [Center(child: ChatProgressIndicator())],
                                               );

                                             var len = snapshot.data!.docs.length;
                                             if (len == 0)
                                               return Column(
                                                 children: [
                                                   SizedBox(height: 100),
                                                   Center(
                                                     child: Text("No shops available",
                                                         style: TextStyle(
                                                             fontSize: 20, color: Colors.grey)),
                                                   )
                                                 ],
                                               );

                                             List<GroupMessage> shops = snapshot.data!.docs
                                                 .map(
                                                   (doc) => GroupMessage(
                                                 groupImage: doc["group_image"],
                                                 desc:doc["description"] ,
                                                 type: doc["group_type"],
                                                 myName: doc['my_name'],
                                                 friendName: doc["friend_name"],
                                                 msgOwner: doc['msg_owner'],
                                                 myUid: doc['uid'],
                                                 seen: doc['seen'],
                                                 image: doc["image"],
                                                 timestamp: doc["timestamp"].toString(),
                                                 friendUid: doc['friend_uid'],
                                                 isDocument: doc['is_document'],
                                                 document: doc['document'],
                                                 isImage: doc['is_image'],
                                                 message: doc['message'],
                                               ),
                                             )
                                                 .toList();

                                             return Expanded(
                                               child: ListView.builder(
                                                   padding: EdgeInsets.symmetric(vertical: 15),
                                                   scrollDirection: Axis.vertical,
                                                   shrinkWrap: true,
                                                   itemCount: shops.length,
                                                   itemBuilder: (context, index){
                                                     return  ImageContainer(width: width, mainImage: shops[index].groupImage, profileImage: profileImage, name: shops[index].friendName, disc: disc);

                                                     //   ListTile(
                                                     //   onTap: ()async{
                                                     //     // groupDetails.groupInfo.clear();
                                                     //     // groupDetails.groupInfo.add(shops[index]);
                                                     //     // Get.to(GroupChatRoomScreen());
                                                     //   },
                                                     //   leading: CircleAvatar(
                                                     //       backgroundColor: themeColor1,
                                                     //       child: ClipRRect(
                                                     //           borderRadius: BorderRadius.circular(width * 0.2),
                                                     //           child: Image.memory(shops[index].groupImage.bytes))),
                                                     //   title: Text(shops[index].friendName),
                                                     //   subtitle: Text(shops[index].desc),
                                                     //   trailing: CircleAvatar(
                                                     //     backgroundColor: Colors.white,
                                                     //     child: Icon(Icons.send,color: themeColor1,),),
                                                     // );
                                                   }),
                                             );
                                           },
                                         ),
                                       );
                                     }
                                 );
                               }
                           )
                           // GridView.count(
                           //   crossAxisSpacing: width *0.04,
                           //   mainAxisSpacing: width * 0.04,
                           //   physics: NeverScrollableScrollPhysics(),
                           //   shrinkWrap: true,
                           //   crossAxisCount: 2,
                           //   children: [
                           //     ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                           //     ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                           //     ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                           //     ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                           //     ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                           //     ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                           //     ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                           //     ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                           //     ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                           //     ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                           //     ImageContainer(width: width, mainImage: mainImage, profileImage: profileImage, name: name, disc: disc),
                           //   ],
                           // ),
                         ],
                       ),
                     ),
                   ]),
             ),
            ],
          ),
        ),
    );
  }
}

