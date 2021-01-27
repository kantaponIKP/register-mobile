//Username
//Email

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:register_demo/models/person.dart';
import 'package:register_demo/models/responseData.dart';
import 'package:register_demo/screens/register/temp/registerThird.dart';
import 'package:register_demo/services/registerService.dart';
import 'package:register_demo/services/registerStorage.dart';

class SettingUserPage extends StatefulWidget {
    final Sink<bool> dataSink;
  SettingUserPage(this.dataSink);



  @override
  _SettingUserPageState createState() => _SettingUserPageState();
}

class _SettingUserPageState extends State<SettingUserPage> {
  RegisterStorage registerStorage;
  @override
  void initState() {
    super.initState();
    registerStorage = RegisterStorage.getInstance();
  }
   Person person;

  ResponseData responseData;
  String url = '';
  String diglogText = '';
  String _diglogText = '';
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

    void setStage() {
    print("------------------SET STAGE--------------");
    bool isThirdStageComplete;
    print(usernameController.text);
    print(usernameController.text.length);
    print(emailController.text.length);
    if ((usernameController.text.length > 4) &&
        (emailController.text.length >= 6)) {
          registerStorage.person.username = usernameController.text;
          registerStorage.person.email = emailController.text;
      isThirdStageComplete = true;
    } else {
      isThirdStageComplete = false;
    }
    print("isThirdStageComplete: "+isThirdStageComplete.toString());
    widget.dataSink.add(isThirdStageComplete);
  }


  @override
  Widget build(BuildContext context) {
    double paddingText = 15;
    return Column(children: [
      Container(
        padding: EdgeInsets.only(top: paddingText, bottom: paddingText),
        child: TextFormField(
           controller: usernameController,
           onChanged: (text) {
                    setStage();
                  },
          decoration:
              InputDecoration(labelText: 'Username',labelStyle: TextStyle(fontWeight: FontWeight.normal),border: OutlineInputBorder(), counterText: ''),
          maxLength: 30,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        padding: EdgeInsets.only(top: paddingText, bottom: paddingText),
        child: TextFormField(
           controller: emailController,
           onChanged: (text) {
                    setStage();
                  },
            decoration:
                InputDecoration(labelText: 'Email',labelStyle: TextStyle(fontWeight: FontWeight.normal),
                  border: OutlineInputBorder(), counterText: '',
                  ),
            maxLength: 30,
            style: TextStyle(fontWeight: FontWeight.bold),
            keyboardType: TextInputType.emailAddress,
            ),
      ),
    ]);
  }

  showFillUpAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("ตกลง",
          style: TextStyle(
            color: Colors.red,
            fontSize: 30.0,
          )),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("ข้อความ"),
      content: Text("กรุณากรอกข้อมูลให้ครบ"),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showResponseAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("ตกลง",
          style: TextStyle(
            color: Colors.red,
            fontSize: 30.0,
          )),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("ข้อความ",
          style: TextStyle(
            color: Colors.red,
            fontSize: 30.0,
          )),
      content: Text(_diglogText),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
