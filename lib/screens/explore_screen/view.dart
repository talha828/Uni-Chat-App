import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_chat_app/constant/constant.dart';
import 'package:uni_chat_app/model/user_model.dart';
import 'package:uni_chat_app/screens/chat_room_screen/view.dart';
import 'package:uni_chat_app/widgets/chat_progress_indicator.dart';
import 'package:uni_chat_app/widgets/chat_text_field.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  TextEditingController search = TextEditingController();
  final chatUserDetails=Get.put(ChatUserDetails());

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          title: Center(
              child: Text(
            "Explore",
            style: TextStyle(color: themeColor1),
          )),
          actions: [
            Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ],
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: width * 0.04, horizontal: width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginTextField(
                      width: width,
                      controller: search,
                      hintText: "Search",
                      obscureText: false,
                      onChange: (value){
                      setState(() {});
                      },
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) // TODO: show alert
                        return Text('Something went wrong');

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

                      List<MyUser> shops = snapshot.data!.docs
                          .map((doc) => MyUser(
                              name: doc['name'],
                              uid: doc['uid'],
                              password: doc['password'],
                              email: doc['email'],
                              specialization: doc["specialization"]))
                          .toList();
                      shops = shops
                          .where((s) => s.name
                              .toLowerCase()
                              .contains(search.text.toLowerCase()))
                          .toList();

                      return Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: shops.length,
                            itemBuilder: (context, index){
                              return ListTile(
                                onTap: (){
                                  chatUserDetails.name.value=shops[index].name;
                                  chatUserDetails.email.value=shops[index].email;
                                  chatUserDetails.password.value=shops[index].password;
                                  chatUserDetails.uid.value=shops[index].uid;
                                  chatUserDetails.specialization.value=shops[index].specialization;
                                  Get.to(ChatRoomScreen());
                                },
                                leading: CircleAvatar(
                                  backgroundColor: themeColor1,
                                  child: Text(shops[index].name.substring(0,1),style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),),),
                                title: Text(shops[index].name),
                                subtitle: Text(shops[index].email),
                                trailing: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.send,color: themeColor1,),),
                              );
                            }),
                      );
                    },
                  )
                ],
              ),
            ),
            isLoading
                ? Positioned.fill(child: ChatProgressIndicator())
                : Container()
          ],
        ),
      ),
    );
  }

  setLoading(bool value) {
    setState(() {
      isLoading = true;
    });
  }
}
