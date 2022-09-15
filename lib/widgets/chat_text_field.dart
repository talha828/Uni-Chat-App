import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget{
  const LoginTextField({
    Key? key,
    required this.width,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  }) : super(key: key);

  final double width;
  final TextEditingController controller;
  final String hintText;
  final bool   obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hintText,
            style: TextStyle(
                fontSize: width * 0.05,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(
            height: width * 0.04,
          ),
          TextFormField(
            obscureText:obscureText ,
            validator: (value){
              if (value == null || value.isEmpty) {
                return 'Please enter your $hintText';
              }
              return null;
            },
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade300,
              contentPadding:
              EdgeInsets.symmetric(horizontal: width * 0.04),
              border: InputBorder.none,
              hintText: hintText,
            ),
          ),
        ],
      ),
    );
  }
}
