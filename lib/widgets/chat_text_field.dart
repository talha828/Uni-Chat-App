import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget{
  const LoginTextField({
    Key key,
    @required this.width,
    @required this.email,
    @required this.name,
  }) : super(key: key);

  final double width;
  final TextEditingController email;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
                fontSize: width * 0.05,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(
            height: width * 0.04,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(width * 0.01),
                border: Border.all(color: Colors.black)),
            child: TextField(
              controller: email,
              decoration: InputDecoration(
                contentPadding:
                EdgeInsets.symmetric(horizontal: width * 0.04),
                border: InputBorder.none,
                hintText: name,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
