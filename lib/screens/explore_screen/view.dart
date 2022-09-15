import 'package:flutter/material.dart';
import 'package:uni_chat_app/constant/constant.dart';
import 'package:uni_chat_app/widgets/chat_progress_indicator.dart';
import 'package:uni_chat_app/widgets/chat_text_field.dart';


class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  TextEditingController search=TextEditingController();

  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    var width =MediaQuery.of(context).size.width;
    var height =MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back_ios_new,color: Colors.white,),
          title: Center(child: Text("Explore",style: TextStyle(color: themeColor1),)),
          actions: [
            Icon(Icons.arrow_back_ios_new,color: Colors.white,),
          ],
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: width * 0.04,horizontal: width * 0.04),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginTextField(width: width, controller: search, hintText: "Search", obscureText: false)
                  ,Expanded(child: Center(child: Container(child: Text("No Record are found"),)))
                ],
              ) ,
            ),
            isLoading? Positioned.fill(child: ChatProgressIndicator()):Container()
          ],
        ),
      ),
    );
  }
  setLoading(bool value){
    setState(() {
      isLoading=true;
    });
  }
}
