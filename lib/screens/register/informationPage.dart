import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:register_demo/models/person.dart';
import 'package:register_demo/services/registerStorage.dart';

class InformationPage extends StatefulWidget {
  final Sink<bool> dataSink;
  InformationPage(this.dataSink);
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage>
    with SingleTickerProviderStateMixin {
  TextEditingController firstnameThController = TextEditingController();
  TextEditingController lastnameThController = TextEditingController();
  TextEditingController firstnameEngController = TextEditingController();
  TextEditingController lastnameEngController = TextEditingController();
  TextEditingController idnoController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();

  int nameTitleIndex = 0;
  int index;
  bool consentValue = true;

  RegisterStorage registerStorage;

  static const Map<int, String> monthsInYear = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December"
  };

  static const Map<String, String> indexMonthsInYear = {
    "January": "01",
    "February": "02",
    "March": "03",
    "April": "04",
    "May": "05",
    "June": "06",
    "July": "07",
    "August": "08",
    "September": "09",
    "October": "10",
    "November": "11",
    "December": "12"
  };

  DateTime selectedDate = DateTime.now();

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
    print("person.dateOfBirth: *****************" + person.dateOfBirth);
    if (person.dateOfBirth != "") {
      print("!= null");
      List<String> splitDate = person.dateOfBirth.split(" ");
      String monthNumber = indexMonthsInYear["June"];
      String date;
      if (splitDate[0].length == 1) {
        date = "0" + splitDate[0];
      } else {
        date = splitDate[0];
      }
      String dateTime = splitDate[2] + monthNumber.toString() + date;
      print("dateTime :" + dateTime);
      DateTime tempDate = DateTime.parse(dateTime);
      print("tempDate: " + tempDate.toString());
      selectedDate = tempDate;
    }
    if (person.nameTitleTh != null) {
      if (person.nameTitleTh == 'นาย') {
        nameTitleIndex = 0;
      } else if (person.nameTitleTh == 'นาง') {
        nameTitleIndex = 1;
      } else if (person.nameTitleTh == 'นางสาว') {
        nameTitleIndex = 2;
      } else if (person.nameTitleTh == 'อื่นๆ') {
        nameTitleIndex = 3;
      }
    } else {
      nameTitleIndex = 3;
    }
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
              child: ChoiceChip(
                // label: Text('Item $index'),
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
              ));
        },
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    double paddingText = 30;
    double paddingBetweenText = 10;

    return Column(children: [
      Container(alignment: Alignment.centerLeft, child: Text("คำนำหน้าชื่อ")),
      Container(
        padding: EdgeInsets.only(
            top: paddingText, bottom: paddingText, right: paddingBetweenText),
        child: Row(
          children: [choiceChipWidget()],
        ),
      ),
      Container(
          alignment: Alignment.centerLeft,
          child: Text("ชื่อจริง - นามสกุล (ภาษาไทย)")),
      Row(children: [
        Container(
          child: Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  top: paddingText,
                  bottom: paddingText,
                  right: paddingBetweenText),
              child: TextFormField(
                  onChanged: (text) {
                    setStage();
                  },
                  controller: firstnameThController,
                  decoration: InputDecoration(
                      prefixStyle: TextStyle(fontWeight: FontWeight.bold),
                      // labelText: 'ชื่อจริง',
                      hintText: 'ชื่อจริง',
                      hintStyle: TextStyle(fontWeight: FontWeight.normal),
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 10),
                      border: OutlineInputBorder(),
                      counterText: ''),
                  maxLength: 30,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        Container(
          child: Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  top: paddingText,
                  bottom: paddingText,
                  left: paddingBetweenText),
              child: TextFormField(
                  onChanged: (text) {
                    setStage();
                  },
                  controller: lastnameThController,
                  decoration: InputDecoration(
                      // labelText: 'นามสกุล',
                      hintText: 'นามสกุล',
                      hintStyle: TextStyle(fontWeight: FontWeight.normal),
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 10),
                      border: OutlineInputBorder(),
                      counterText: ''),
                  maxLength: 30,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ]),
      Container(
          alignment: Alignment.centerLeft,
          child: Text("ชื่อจริง - นามสกุล (ภาษาอังกฤษ)")),
      Row(children: [
        Container(
          child: Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  top: paddingText,
                  bottom: paddingText,
                  right: paddingBetweenText),
              child: TextFormField(
                  onChanged: (text) {
                    setStage();
                  },
                  controller: firstnameEngController,
                  decoration: InputDecoration(
                      // labelText: 'ชื่อจริง',
                      hintText: 'ชื่อจริง',
                      hintStyle: TextStyle(fontWeight: FontWeight.normal),
                      border: OutlineInputBorder(),
                      counterText: ''),
                  maxLength: 30,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        Container(
          child: Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  top: paddingText,
                  bottom: paddingText,
                  left: paddingBetweenText),
              child: TextFormField(
                  onChanged: (text) {
                    setStage();
                  },
                  controller: lastnameEngController,
                  decoration: InputDecoration(
                      // labelText: 'นามสกุล',
                      hintText: 'นามสกุล',
                      hintStyle: TextStyle(fontWeight: FontWeight.normal),
                      border: OutlineInputBorder(),
                      counterText: ''),
                  maxLength: 30,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ]),
      Container(
          alignment: Alignment.centerLeft, child: Text("รหัสประจำตัวประชาชน")),
      Container(
        padding: EdgeInsets.only(top: paddingText, bottom: paddingText),
        child: TextFormField(
          onChanged: (text) {
            setStage();
          },
          controller: idnoController,
          decoration:
              InputDecoration(border: OutlineInputBorder(), counterText: ''),
          maxLength: 13,
          style: TextStyle(fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
        ),
      ),
      Container(
          alignment: Alignment.centerLeft, child: Text("วัน/เดือน/ปีเกิด")),
      InkWell(
        onTap: () {
          _selectDate(context);
        },
        child: Container(
          padding: EdgeInsets.only(top: paddingText, bottom: paddingText),
          child: TextFormField(
            onChanged: (text) {
              setStage();
            },
            enabled: false,
            controller: dateOfBirthController,
            decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  // borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1, color: Colors.black38),
                ),
                border: OutlineInputBorder(),
                counterText: '',
                suffixIcon: Icon(Icons.calendar_today)),
            maxLength: 30,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
            value: consentValue,
            onChanged: (bool value) {
              setState(() {
                consentValue = value;
                setStage();
              });
            },
          ),
          Text("ยินยอมให้ใช้ข้อมูลส่วนตัวได้")
        ],
      )
          //  Container(
          //     alignment: Alignment.centerLeft, child: Text("ยินยอมให้ใช้ข้อมูลส่วนตัวได้")),
          // Container(
          //   padding: EdgeInsets.only(top: paddingText, bottom: paddingText),
          //   child: TextFormField(
          //     onChanged: (text) {
          //       setStage();
          //     },
          //     controller: idnoController,
          //     decoration:
          //         InputDecoration(border: OutlineInputBorder(), counterText: ''),
          //     maxLength: 13,
          //     style: TextStyle(fontWeight: FontWeight.bold),
          //     keyboardType: TextInputType.number,
          //   ),
          // ),
          )
    ]);
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

  // void pickDate() {}

  _selectDate(BuildContext context) async {
    print("regis: " + registerStorage.person.idno);
    // print("**********************************");
    // setControllerText();
    // print("**********************************");
    DateTime lastDate = DateTime.now();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime(int.parse(lastDate.year.toString()) + 1),
    );

    String datePicker = picked.day.toString() +
        " " +
        monthsInYear[int.parse(picked.month.toString())] +
        " " +
        picked.year.toString();

    log("pick date: " + datePicker);
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateOfBirthController.text = datePicker;
        log("setState");
        setStage();
      });
  }
}
