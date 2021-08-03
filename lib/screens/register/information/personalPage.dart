import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:register_demo/models/person.dart';
import 'package:register_demo/services/registerStorage.dart';

class PersonalPage extends StatefulWidget {
  final Sink<bool> dataSink;
  PersonalPage(this.dataSink);
  @override
  _PersonalPageState createState() => _PersonalPageState();

  // static void nextPage() {
  //    Navigator.push(
  //   context,
  //   MaterialPageRoute(builder: (context) => SecondRoute()),
  // );
  // }
}

class _PersonalPageState extends State<PersonalPage>
    with SingleTickerProviderStateMixin {
  TextEditingController firstnameThController = TextEditingController();
  TextEditingController lastnameThController = TextEditingController();
  TextEditingController firstnameEngController = TextEditingController();
  TextEditingController lastnameEngController = TextEditingController();
  TextEditingController idnoController = TextEditingController();
  TextEditingController idnoBackController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController expiredDateController = TextEditingController();

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

  DateTime selectedDateOfBirth = DateTime.now();
  DateTime selectedExpiredDate = DateTime.now();

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
      selectedDateOfBirth = tempDate;
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
              child: Theme(
                  data: ThemeData(
                      primaryColor: primaryColor,
                      colorScheme: ColorScheme.light(primary: primaryColor)),
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
    double paddingText = 10;
    double paddingBetweenText = 00;
    double paddingTopText = 30;

    return Column(children: [
      Container(alignment: Alignment.centerLeft, child: Text("คำนำหน้าชื่อ",style: TextStyle(fontWeight: FontWeight.bold))),
      Container(
        padding: EdgeInsets.only(
            top: paddingText, bottom: paddingText, right: paddingBetweenText),
        child: Row(
          children: [choiceChipWidget()],
        ),
      ),
      Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: paddingTopText),
          child: Text("ชื่อจริง - นามสกุล (ภาษาไทย)",style: TextStyle(fontWeight: FontWeight.bold))),
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
              decoration: new InputDecoration(hintText: 'ชื่อจริง'),
            ),
          )),
        ),
        SizedBox(width: 20),
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
              controller: lastnameThController,
              decoration: new InputDecoration(hintText: 'นามสกุล'),
            ),
          )),
        ),
      ]),
      Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: paddingTopText),
          child: Text("ชื่อจริง - นามสกุล (ภาษาอังกฤษ)",style: TextStyle(fontWeight: FontWeight.bold))),
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
              decoration: new InputDecoration(hintText: 'First Name'),
            ),
          )),
        ),
        SizedBox(width: 20),
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
              controller: lastnameEngController,
              decoration: new InputDecoration(hintText: 'Last Name'),
            ),
          )),
        ),
      ]),

      Container(
          alignment: Alignment.centerLeft, padding: EdgeInsets.only(top: paddingTopText), child: Text("วัน/เดือน/ปีเกิด",style: TextStyle(fontWeight: FontWeight.bold))),
      InkWell(
        onTap: () {
          _selectDate(context);
        },
        child: 
        Container(
          padding: EdgeInsets.only(top: paddingText, bottom: paddingText),
          child: TextFormField(
            onChanged: (text) {
              setStage();
            },
            enabled: false,
            controller: dateOfBirthController,
            decoration: InputDecoration(
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.black38),
                ),
                counterText: '',
                suffixIcon: Icon(Icons.calendar_today)),
            maxLength: 30,
          ),
        ),
      ),
      Container(
          alignment: Alignment.centerLeft, padding: EdgeInsets.only(top: paddingTopText), child: Text("รหัสประจำตัวประชาชน",style: TextStyle(fontWeight: FontWeight.bold))),

      Container(
          child: Padding(
        padding: EdgeInsets.only(
            top: paddingText, bottom: paddingText, right: paddingBetweenText),
        child: TextFormField(
          onChanged: (text) {
            setStage();
          },
          decoration: InputDecoration(
            counterText: '',
          ),
          controller: idnoController,
          maxLength: 13,
          keyboardType: TextInputType.number,
        ),
      )),
      Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: paddingTopText),
          child: Text("เลขหลังบัตรประจำตัวประชาชน",style: TextStyle(fontWeight: FontWeight.bold))),
      Container(
          child: Padding(
        padding: EdgeInsets.only(
            top: paddingText, bottom: paddingText, right: paddingBetweenText),
        child: TextFormField(
          onChanged: (text) {
            setStage();
          },
          controller: idnoBackController,
          decoration: InputDecoration(
            counterText: '',
            hintText: 'xxx-xxxxxxx-xx',
          ),
          maxLength: 12,
          keyboardType: TextInputType.number,
        ),
      )),
      Container(alignment: Alignment.centerLeft, padding: EdgeInsets.only(top: paddingTopText), child: Text("วันหมดอายุ",style: TextStyle(fontWeight: FontWeight.bold))),
      InkWell(
        onTap: () {
          _selectExpiredDate(context);
        },
        child: Container(
          padding: EdgeInsets.only(top: paddingText, bottom: paddingText),
          child: TextFormField(
            onChanged: (text) {
              setStage();
            },
            enabled: false,
            controller: expiredDateController,
            decoration: InputDecoration(
              disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.black38),
                ),
                counterText: '',
                suffixIcon: Icon(Icons.calendar_today)),
            maxLength: 30,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
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
      initialDate: selectedDateOfBirth, // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime(int.parse(lastDate.year.toString()) + 1),
    );

    String datePicker = picked.day.toString() +
        " " +
        monthsInYear[int.parse(picked.month.toString())] +
        " " +
        picked.year.toString();

    log("pick date: " + datePicker);
    if (picked != null && picked != selectedDateOfBirth)
      setState(() {
        selectedDateOfBirth = picked;
        dateOfBirthController.text = datePicker;
        log("setState");
        setStage();
      });
  }

  _selectExpiredDate(BuildContext context) async {
    DateTime lastDate = DateTime.now();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedExpiredDate, // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime(int.parse(lastDate.year.toString()) + 1),
    );

    String datePicker = picked.day.toString() +
        " " +
        monthsInYear[int.parse(picked.month.toString())] +
        " " +
        picked.year.toString();

    log("pick date: " + datePicker);
    if (picked != null && picked != selectedExpiredDate)
      setState(() {
        selectedExpiredDate = picked;
        expiredDateController.text = datePicker;
        log("setState");
        setStage();
      });
  }
}
