import 'package:flutter/material.dart';

class CreateAccount extends StatelessWidget {
   CreateAccount({
    Key key,
    this.onTap
  }) : super(key: key);
   var onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Create new Account?",style: TextStyle(color: Colors.grey),),
            Text(" Signup",style: TextStyle(color: Colors.blue,decoration: TextDecoration.underline),),

          ],
        ),
      ),
    );
  }
}
