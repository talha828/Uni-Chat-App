import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_chat_app/model/user_model.dart';
import 'package:uni_chat_app/screens/main_screen/view.dart';

class Database{
  static Future<bool>signUp(String name,String email,String password,String specialization)async{
    FirebaseAuth auth=FirebaseAuth.instance;
    CollectionReference database=FirebaseFirestore.instance.collection("users");
    //database=FirebaseDatabase.instance.ref().child("database").child("user_details");
    await auth.createUserWithEmailAndPassword(email: email, password: password).then((value)async {
      await database.doc(auth.currentUser!.uid).set({
        "name":name,
        "email":email,
        "specialization":specialization,
        "password":password,
        "uid":auth.currentUser!.uid,
        "is_chat":false,
        "is_academic":false,
        "is_activity":false,
      }).then((value) async{
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("email", email);
        prefs.setString("password", password);
        CollectionReference user=FirebaseFirestore.instance.collection("users");
        FirebaseAuth _auth=FirebaseAuth.instance;
        DocumentSnapshot<Object?> data=await user.doc(_auth.currentUser!.uid).get();
        if(data.exists){
          final user=Get.put(UserDetails());
          var dd=data.data();
          user.name.value=data['name'].toString();
          user.email.value=data['email'].toString();
          user.uid.value=data['uid'].toString();
          user.specialization.value=data['specialization'].toString();
          user.password.value=data['password'].toString();
          // data['academic_chat_link'].printError();
          if(data['is_chat'] != false){
            for (var i in data['user_chat_link']) {
              user.chatUsers.add(i);
            }
          }
          if(data['is_activity'] != false){
            for (var i in data['activity_chat_link']) {
              user.activityGroup.add(i);
            }
          }
          if(data['is_academic'] != false){
            for (var i in data['academic_chat_link']) {
              user.academicGroup.add(i);
            }
          }}
        Get.to(const MainScreen());});
    }).catchError((e){Fluttertoast .showToast(msg: "something went wrong");});
    return true;
  }
  static Future<bool>login(String email,String password,)async{
    FirebaseAuth auth=FirebaseAuth.instance;
    DatabaseReference database=FirebaseDatabase.instance.ref().child("database").child("user_details");
    await auth.signInWithEmailAndPassword(email: email, password: password).then((value)async{
        CollectionReference user=FirebaseFirestore.instance.collection("users");
        DocumentSnapshot<Object?> data=await user.doc(value.user!.uid).get();
        if(data.exists){
          final user=Get.put(UserDetails());
          var dd=data.data();
          user.name.value=data['name'].toString();
          user.email.value=data['email'].toString();
          user.uid.value=data['uid'].toString();
          user.specialization.value=data['specialization'].toString();
          user.password.value=data['password'].toString();
          // data['academic_chat_link'].printError();
          if(data['is_chat'] != false){
          for (var i in data['user_chat_link']) {
            user.chatUsers.add(i);
          }
        }
          if(data['is_activity'] != false){
          for (var i in data['activity_group_link']) {
            user.activityGroup.add( data['activity_group_link'].toString());
          }
        }
          if(data['is_academic'] != false){
          for (var i in data['Academic_group_link']) {
            user.academicGroup.add(i);
          }
        }

        final prefs = await SharedPreferences.getInstance();
          prefs.setString("email",data['email']);
          prefs.setString("password", data['password']);
          print(user.password);
          Get.to(const MainScreen());
        }
        else{
          print("data error");
        }

    });
    return true;
  }
}