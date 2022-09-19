import 'package:flutter/material.dart';
import 'package:uni_chat_app/constant/constant.dart';

class ChatDetailsScreen extends StatefulWidget {
  const ChatDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> list = [
    "assets/png_images/logic.png",
    "assets/png_images/logic.png",
    "assets/png_images/logic.png",
    "assets/png_images/logic.png",
    "assets/png_images/logic.png",
    "assets/png_images/logic.png",
    "assets/png_images/logic.png",
    "assets/png_images/logic.png",
    "assets/png_images/logic.png",
    "assets/png_images/logic.png",
    "assets/png_images/logic.png",
    "assets/png_images/logic.png",
  ];
  @override
  void initState() {
    // TODO: implement initState
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.04, vertical: width * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      //color: Colors.blue,
                      border: Border.all(color: themeColor1),
                      borderRadius: BorderRadius.circular(width * 1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(width * 1),
                      child: Image.asset(
                        "assets/png_images/logic.png",
                        width: width * 0.4,
                        height: width * 0.4,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: width * 0.08,
              ),
              Text(
                "Talha Iqbal",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: width * 0.07),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: width * 0.04,
              ),
              Text(
                "talhaiqbal246@gmail.com",
                style: TextStyle(
                    color: Colors.grey.shade600, fontSize: width * 0.045),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: width * 0.04,
              ),
              Text(
                "Student",
                style: TextStyle(
                    color: Colors.grey.shade600, fontSize: width * 0.045),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: width * 0.08,
              ),
              TabBar(
                unselectedLabelColor: Colors.black,
                labelColor: themeColor1,
                indicatorColor: themeColor1,
                tabs: [
                  Tab(
                    icon: Icon(Icons.image),
                  ),
                  Tab(
                    icon: Icon(Icons.file_present),
                  ),
                ],
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Container(
                      child: GridView.count(
                          crossAxisSpacing: width * 0.01,
                          mainAxisSpacing: width * 0.01,
                          crossAxisCount: 3,
                          children: list
                              .map((e) => Container(
                                    color: Colors.blue,
                                    child: Image.asset(
                                      e.toString(),
                                      fit: BoxFit.cover,
                                      width: width * 0.04,
                                      height: width * 0.04,
                                    ),
                                  ))
                              .toList()),
                    ),
                    Container(
                      child: ListView.separated(
                        separatorBuilder: (context,index){
                          return Divider();
                        },
                        itemCount: 15,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading:Icon(Icons.file_present,color: Colors.black,size: width * 0.08,),
                            title: Text("My Documents"),
                            subtitle: Text("12kb      .      Sunday"),
                            trailing: Text("10:00 PM"),
                          );
                        },
                      ),
                    ),
                  ],
                  controller: _tabController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
