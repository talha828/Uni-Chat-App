import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_chat_app/model/user_model.dart';
import 'package:uni_chat_app/screens/main_screen/view.dart';

class Database{
  static Future<bool>signUp(String name,String email,String password,)async{
    FirebaseAuth auth=FirebaseAuth.instance;
    CollectionReference database=FirebaseFirestore.instance.collection("users");
    //database=FirebaseDatabase.instance.ref().child("database").child("user_details");
    await auth.createUserWithEmailAndPassword(email: email, password: password).then((value)async {
      await database.doc(auth.currentUser!.uid).set({
        "name":name,
        "email":email,
        "password":password,
        "uid":auth.currentUser!.uid,
      }).then((value) async{
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("email", email);
        prefs.setString("password", password);
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
          user.password.value=data['password'].toString();
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