import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uni_chat_app/constant/constant.dart';
import 'package:uni_chat_app/widgets/chat_button.dart';

import '../../widgets/chat_text_field.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  TextEditingController group = TextEditingController();
  TextEditingController description = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? image;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            "Create Group",
            style: TextStyle(color: themeColor1),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              height: height - 90,
              padding: EdgeInsets.symmetric(horizontal: width * 0.07),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['png', 'jpg', "jpeg"],
                      );
                      image = File(result!.files.single.path!);
                      setState(() {});
                    },
                    child: image == null
                        ? CircleAvatar(
                            radius: width * 0.19,
                            backgroundColor: themeColor1.withOpacity(0.7),
                            child: Icon(
                              Icons.add_a_photo_outlined,
                              size: width * 0.18,
                              color: Colors.white,
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: width * 0.2,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(width),
                                child: Image.file(
                                  image!,
                                  width: width * 0.4,
                                  fit: BoxFit.fill,
                                  height: width * 0.4,
                                )),
                          ),
                  ),
                  LoginTextField(
                    controller: group,
                    obscureText: false,
                    width: width,
                    hintText: "Group Name",
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description",
                          style: TextStyle(
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: width * 0.04,
                        ),
                        TextFormField(
                          maxLines: 10,
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Description';
                            }
                            return null;
                          },
                          controller: description,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: width * 0.04,
                                vertical: width * 0.04),
                            border: InputBorder.none,
                            hintText: "Type description here ........",
                          ),
                        ),
                      ],
                    ),
                  ),
                  ChatButton(
                      width: width,
                      name: "Create Now",
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          if(image != null){

                          }else{
                            Fluttertoast.showToast(msg:"Image is required");
                          }
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
