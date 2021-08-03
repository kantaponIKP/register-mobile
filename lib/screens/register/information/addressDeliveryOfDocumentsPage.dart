import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:register_demo/models/person.dart';
import 'package:register_demo/services/registerStorage.dart';

class AddressDeliveryOfDocumentsPage extends StatefulWidget {
  final Sink<bool> dataSink;
  AddressDeliveryOfDocumentsPage(this.dataSink);
  @override
  _AddressDeliveryOfDocumentsPageState createState() =>
      _AddressDeliveryOfDocumentsPageState();
}

class _AddressDeliveryOfDocumentsPageState
    extends State<AddressDeliveryOfDocumentsPage>
    with SingleTickerProviderStateMixin {
  TextEditingController firstnameThController = TextEditingController();
  TextEditingController lastnameThController = TextEditingController();
  TextEditingController firstnameEngController = TextEditingController();
  TextEditingController lastnameEngController = TextEditingController();
  TextEditingController idnoController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController expiredDateController = TextEditingController();

  int nameTitleIndex = 0;
  int index;
  bool consentValue = true;
  bool asRegistrationAddress = true;
  bool asCurrentAddress = false;
  bool newAddress = false;

  Color primaryColor = Colors.red[700];

  RegisterStorage registerStorage;
  @override
  void initState() {
    registerStorage = RegisterStorage.getInstance();
    super.initState();
    setControllerText();
    setStage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setStage() {
    print("------------------SET STAGE--------------");
    bool isSecondStageComplete;
    if ((firstnameThController.text != "") &&
        (lastnameThController.text != "") &&
        (firstnameEngController.text != "") &&
        (lastnameEngController.text != "") &&
        (idnoController.text != "") &&
        (dateOfBirthController.text != "") &&
        (expiredDateController.text != "") &&
        (consentValue == true)) {
      isSecondStageComplete = true;
    } else {
      isSecondStageComplete = false;
    }
    widget.dataSink.add(isSecondStageComplete);
  }

  setControllerText() {
    Person person = registerStorage.person;
    firstnameThController.text = person.firstnameTh;
    lastnameThController.text = person.lastnameTh;
    firstnameEngController.text = person.firstnameEng;
    lastnameEngController.text = person.lastnameEng;
    idnoController.text = person.idno;
    dateOfBirthController.text = person.dateOfBirth;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          alignment: Alignment.centerLeft,
          child: Text("ที่อยู่สำหรับส่งเอกสาร",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
      SizedBox(
        height: 30,
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.01,
            right: MediaQuery.of(context).size.width * 0.01),
        child: Row(children: [
          Expanded(
              child: (asRegistrationAddress)
                  ? ElevatedButton(
                      child: Text("ตามทะเบียนบ้าน".toUpperCase(),
                          style: TextStyle(fontSize: 14)),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(15)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(primaryColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  side: BorderSide(color: primaryColor)))),
                      onPressed: () => onClickAsRegistrationAddress())
                  : TextButton(
                      child: Text("ตามทะเบียนบ้าน".toUpperCase(),
                          style: TextStyle(fontSize: 14)),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(15)),
                          foregroundColor: MaterialStateProperty.all<Color>(primaryColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0), side: BorderSide(color: primaryColor)))),
                      onPressed: () => onClickAsRegistrationAddress())),
          SizedBox(width: 20),
          Expanded(
              child: (asCurrentAddress)
                  ? ElevatedButton(
                      child: Text("ที่อยู่ปัจจุบัน".toUpperCase(),
                          style: TextStyle(fontSize: 14)),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(15)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(primaryColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  side: BorderSide(color: primaryColor)))),
                      onPressed: () => onClickAsCurrentAddress())
                  : TextButton(
                      child: Text("ที่อยู่ปัจจุบัน".toUpperCase(),
                          style: TextStyle(fontSize: 14)),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(15)),
                          foregroundColor: MaterialStateProperty.all<Color>(primaryColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0), side: BorderSide(color: primaryColor)))),
                      onPressed: () => onClickAsCurrentAddress()))
        ]),
      ),
      SizedBox(height: 20),
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.01,
            right: MediaQuery.of(context).size.width * 0.01),
        child: Row(children: [
          Expanded(
              child: (newAddress)
                  ? ElevatedButton(
                      child: Text("เพิ่มที่อยู่ +".toUpperCase(),
                          style: TextStyle(fontSize: 14)),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(15)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(primaryColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  side: BorderSide(color: primaryColor)))),
                      onPressed: () => onClickNewAddress())
                  : TextButton(
                      child: Text("เพิ่มที่อยู่ +".toUpperCase(),
                          style: TextStyle(fontSize: 14)),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(15)),
                          foregroundColor: MaterialStateProperty.all<Color>(primaryColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0), side: BorderSide(color: primaryColor)))),
                      onPressed: () => onClickNewAddress())),
          SizedBox(width: 20),
          Expanded(child: Container()),
        ]),
      ),
      SizedBox(
        height: 30,
      ),
      addAddress(context)
    ]);
  }

  Widget addAddress(BuildContext context) {
    double paddingText = 00;
    double paddingBetweenText = 20;
    if (newAddress) {
      return Column(children: [
        Container(alignment: Alignment.centerLeft, child: Text("ที่อยู่",style: TextStyle(fontWeight: FontWeight.bold))),
        Container(
          padding:
              EdgeInsets.only(top: paddingText, bottom: paddingBetweenText),
          child: TextFormField(
            onChanged: (text) {
              setStage();
            },
            // controller: idnoController,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(alignment: Alignment.centerLeft, child: Text("จังหวัด",style: TextStyle(fontWeight: FontWeight.bold))),
        Container(
          padding:
              EdgeInsets.only(top: paddingText, bottom: paddingBetweenText),
          child: TextFormField(
            onChanged: (text) {
              setStage();
            },
            // controller: idnoController,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(alignment: Alignment.centerLeft, child: Text("เขต / อำเภอ",style: TextStyle(fontWeight: FontWeight.bold))),
        Container(
          padding:
              EdgeInsets.only(top: paddingText, bottom: paddingBetweenText),
          child: TextFormField(
            onChanged: (text) {
              setStage();
            },
            // controller: idnoController,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(alignment: Alignment.centerLeft, child: Text("แขวง / ตำบล",style: TextStyle(fontWeight: FontWeight.bold))),
        Container(
          padding:
              EdgeInsets.only(top: paddingText, bottom: paddingBetweenText),
          child: TextFormField(
            onChanged: (text) {
              setStage();
            },
            // controller: idnoController,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(alignment: Alignment.centerLeft, child: Text("รหัสไปรษณีย์",style: TextStyle(fontWeight: FontWeight.bold))),
        Container(
          padding:
              EdgeInsets.only(top: paddingText, bottom: paddingBetweenText),
          child: TextFormField(
            onChanged: (text) {
              setStage();
            },
            // controller: idnoController,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ]);
    } else {
      return Container();
    }
  }

  onClickAsRegistrationAddress() {
    setState(() {
      asRegistrationAddress = true;
      asCurrentAddress = false;
      newAddress = false;
    });
  }

  onClickAsCurrentAddress() {
    setState(() {
      asRegistrationAddress = false;
      asCurrentAddress = true;
      newAddress = false;
    });
  }

  onClickNewAddress() {
    setState(() {
      asRegistrationAddress = false;
      asCurrentAddress = false;
      newAddress = true;
    });
  }

  showFillUpAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("ตกลง",
          style: TextStyle(
            color: Colors.red,
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
}
