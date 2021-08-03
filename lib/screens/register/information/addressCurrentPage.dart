import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:register_demo/models/person.dart';
import 'package:register_demo/services/registerStorage.dart';

class AddressCurrentPage extends StatefulWidget {
  final Sink<bool> dataSink;
  AddressCurrentPage(this.dataSink);
  @override
  _AddressCurrentPageState createState() => _AddressCurrentPageState();
}

class _AddressCurrentPageState extends State<AddressCurrentPage>
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
  bool asRegistration = true;

  RegisterStorage registerStorage;

  Color primaryColor = Colors.red[700];

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

  Widget choiceChipWidget() {
    double paddingBetweenChoiceChip = 8;
    double paddingChoiceChip = 8;
    List<String> chipLabel = ['นาย', 'นาง', 'นางสาว', 'อื่นๆ'];
    return Wrap(
      children: List<Widget>.generate(
        4,
        (int index) {
          return Padding(
              padding: EdgeInsets.only(right: paddingBetweenChoiceChip),
              child: Theme(
                  data: ThemeData(
                      colorScheme: ColorScheme.light(primary: Colors.red)),
                  // colorScheme: ColorScheme.light(primary: Theme.of(context).primaryColor)),
                  child: ChoiceChip(
                    // label: Text('Item $index'),
                    // selectedColor: Colors.red[300],
                    // selected: style: TextStyle(fontWeight: FontWeight.bold),
                    // selectedColor: Theme.of(context).primaryColor,
                    // backgroundColor: Theme.of(context).primaryColor,
                    // backgroundColor: Colors.red,
                    label: Container(
                        padding: EdgeInsets.all(paddingChoiceChip),
                        child: Text(chipLabel[index],
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    selected: nameTitleIndex == index,
                    onSelected: (bool selected) {
                      setState(() {
                        nameTitleIndex = selected ? index : index;
                      });
                    },
                  )));
        },
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    double paddingText = 00;
    double paddingBetweenText = 20;

    return Column(children: [
      Container(
          alignment: Alignment.centerLeft,
          child: Text("ที่อยู่ปัจจุบัน",
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
              child: (asRegistration)
                  ?ElevatedButton(
                  child: Text("ตามทะเบียนบ้าน".toUpperCase(),
                      style: TextStyle(fontSize: 14)),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(15)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        primaryColor),
                          // Theme.of(context).primaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              side: BorderSide(
                                  color: primaryColor)))),
                  onPressed: () => onClickAsRegistration())
                  :TextButton(
                  child: Text("ตามทะเบียนบ้าน".toUpperCase(),
                      style: TextStyle(fontSize: 14)),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(15)),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          primaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              side: BorderSide(
                                  color: primaryColor)))),
                  onPressed: () => onClickAsRegistration())
                  ),
          SizedBox(width: 20),
          Expanded(
              child: (asRegistration)
              ?TextButton(
                  child: Text("เพิ่มที่อยู่ +".toUpperCase(),
                      style: TextStyle(fontSize: 14)),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(15)),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          primaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              side: BorderSide(
                                  color: primaryColor)))),
                  onPressed: () => onClickAddAddress())
                  :ElevatedButton(
                  child: Text("เพิ่มที่อยู่ +".toUpperCase(),
                      style: TextStyle(fontSize: 14)),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(15)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          primaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              side: BorderSide(
                                  color: primaryColor)))),
                  onPressed: () => onClickAddAddress()))
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
    if (!asRegistration) {
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

  onClickAsRegistration() {
    setState(() {
      asRegistration = true;
    });
    print(asRegistration);
  }

  onClickAddAddress() {
  setState(() {
      asRegistration = false;
    });
    print(asRegistration);
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
