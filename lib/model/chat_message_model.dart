class ChatMessage{
  String myName;
  String friendName;
  String uid;
  String timestamp;
  String message;
  String msgOwner;
  String seen;
  ChatMessage({required this.myName,required this.friendName,required this.msgOwner,required this.message,required this.uid,required this.timestamp,required this.seen});
}