import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage{
  String myName;
  String friendName;
  String friendUid;
  bool isImage;
  String? message;
  bool isDocument;
  String? document;
  String myUid;
  String timestamp;
  Blob? image;
  String msgOwner;
  bool seen;
  ChatMessage({required this.myName,required this.friendName,required this.msgOwner,required this.image,required this.myUid,required this.timestamp,required this.seen,this.message,this.document,required this.friendUid,required this.isDocument,required this.isImage});
}