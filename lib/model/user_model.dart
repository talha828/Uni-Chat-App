import 'package:get/get.dart';

class UserDetails extends GetxController {
  RxString name = "".obs;
  RxString email = "".obs;
  RxString uid = "".obs;
  RxString specialization = "".obs;
  RxString password = "".obs;
  List chatUsers=[].obs;
  List academicGroup=[].obs;
  List activityGroup=[].obs;

}

class MyUser {
  String name;
  String email;
  String uid;
  String specialization;
  String password;

  MyUser(
      {required this.name,
      required this.email,
      required this.password,
      required this.specialization,
      required this.uid});
}
class ChatUserDetails extends GetxController {
  RxString name = "".obs;
  RxString email = "".obs;
  RxString uid = "".obs;
  RxString specialization = "".obs;
  RxString password = "".obs;
}

