import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uni_chat_app/model/chat_message_model.dart';

class GroupChatModel extends GetxController{
  RxList<GroupMessage> groupInfo=<GroupMessage>[].obs;
}