import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:register_demo/firebase_ml_vision.dart';
import 'package:register_demo/detector_painters.dart';
import 'package:register_demo/models/person.dart';
import 'package:register_demo/screens/dialogs.dart';
import 'package:register_demo/screens/register/previewPicturePage.dart';

class GoogleVisionService {
  Person person;
  File _imageFileID;
  PickedFile _pickedImageID;
  Size _imageSizeID;
  dynamic _scanResultsID;

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

  Detector _currentDetector = Detector.cloudText;
  final BarcodeDetector _barcodeDetector =
      FirebaseVision.instance.barcodeDetector();
  final FaceDetector _faceDetector = FirebaseVision.instance.faceDetector();
  final ImageLabeler _imageLabeler = FirebaseVision.instance.imageLabeler();
  final ImageLabeler _cloudImageLabeler =
      FirebaseVision.instance.cloudImageLabeler();
  final TextRecognizer _recognizer = FirebaseVision.instance.textRecognizer();
  final TextRecognizer _cloudRecognizer =
      FirebaseVision.instance.cloudTextRecognizer();
  final DocumentTextRecognizer _cloudDocumentRecognizer =
      FirebaseVision.instance.cloudDocumentTextRecognizer();
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  DateTime selectedDate = DateTime.now();

  ImageSource _imgsource;

  final List<Tab> tabs = <Tab>[
    new Tab(icon: Icon(Icons.person), text: "ID Card"),
    new Tab(icon: Icon(Icons.directions_car), text: "Driving License"),
    new Tab(icon: Icon(Icons.book), text: "Passport"),
  ];

  TabController _tabController;

  Future<Person> getIdentificationCardExtractedData(File file) async {
    String data;
    data = await scanImage(file);
    Person person = identificationCardExtractData(data);
    return person;
  }

  Future<Person> getDrivingLicenseExtractedData(File file) async {
    String data;
    data = await scanImage(file);
    Person person = drivingLicenseExtractData(data);
    return person;
  }

  Future<Person> getPassportExtractedData(File file) async {
    String data;
    data = await scanImage(file);
    Person person = passportExtractData(data);
    return person;
  }

  Future<String> scanImage(File imageFile) async {
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);

    dynamic results;
    switch (_currentDetector) {
      case Detector.barcode:
        results = await _barcodeDetector.detectInImage(visionImage);
        break;
      case Detector.face:
        results = await _faceDetector.processImage(visionImage);
        break;
      case Detector.label:
        results = await _imageLabeler.processImage(visionImage);
        break;
      case Detector.cloudLabel:
        results = await _cloudImageLabeler.processImage(visionImage);
        break;
      case Detector.text:
        results = await _recognizer.processImage(visionImage);
        log("Log resultsText: ${results.text}");
        break;
      case Detector.cloudText:
        results = await _cloudRecognizer.processImage(visionImage);
        log("Log resultsText: ${results.text}");
        break;
      case Detector.cloudDocumentText:
        results = await _cloudDocumentRecognizer.processImage(visionImage);
        break;
      default:
        return null;
    }
    return results.text;
  }

  Person identificationCardExtractData(String text) {
    log("-----------Extract Data----------");

    var textIdno = 'Identification Number';
    var textNameTh = 'ชื่อตัวและชื่อสกุล';
    var textNameEng = 'Name';
    var textLastNameEng = 'Last name';
    var textDateOfBirth = 'Date of Birth';
    var textReligion = 'ศาสนา';
    var textAddress = 'ที่อยู่';
    var textProvince = 'จ.';
    var textDateofIssue = 'วันออกบัตร';
    var textDateofExpiry = 'วันบัตรหมดอายุ';
    var textListInLine = [
      textNameTh,
      textNameEng,
      textLastNameEng,
      textDateOfBirth,
      textReligion,
      textAddress,
      textProvince
    ];
    var textListOutLine = [textIdno, textDateofIssue, textDateofExpiry];
    var resultsListInline = [];
    var resultsListOutline = [];

    // Inline Extract
    for (var i = 0; i < textListInLine.length; i++) {
      try {
        var indexStart = text.indexOf(textListInLine[i]);
        var subString = text.substring(indexStart);
        var indexEnd = subString.indexOf('\n');
        resultsListInline.add(text
            .substring(
                indexStart + textListInLine[i].length, indexStart + indexEnd)
            .trim());
      } catch (e) {
        resultsListInline.add('');
      }
    }

    // Outline Extract
    for (var i = 0; i < textListOutLine.length; i++) {
      try {
        var indexStart = text.indexOf(textListOutLine[i]);
        var subString = text.substring(indexStart);
        var indexEnd = subString.indexOf('\n');
        var indexEndSecond = subString.indexOf('\n', indexEnd + 1);
        resultsListOutline.add(text
            .substring(indexStart + textListOutLine[i].length + 1,
                indexStart + indexEndSecond)
            .trim());
      } catch (e) {
        resultsListOutline.add('');
      }
    }

    var resultNameTitleTh = '';
    var resultNameTh = '';
    var resultLastNameTh = '';
    // Split Thai name
    var nameThExtract = resultsListInline[0].split(" ");
    try {
      resultNameTitleTh = nameThExtract[0];
    } catch (e) {
      resultNameTitleTh = '';
    }
    try {
      resultNameTh = nameThExtract[1];
    } catch (e) {
      resultNameTh = '';
    }
    try {
      resultLastNameTh = nameThExtract[2];
    } catch (e) {
      resultLastNameTh = '';
    }

    var resultNameTitleEng = '';
    var resultNameEng = '';
    var resultLastNameEng = '';
    // Split Eng name
    var nameEngExtract = resultsListInline[1].split(" ");
    try {
      resultNameTitleEng = nameEngExtract[0];
    } catch (e) {
      resultNameTitleEng = '';
    }
    try {
      resultNameEng = nameEngExtract[1];
    } catch (e) {
      resultNameEng = '';
    }

    // Split Date of Birth
    var dateOfBirthExtract = resultsListInline[3].split(" ");
    var dateOfBirth = "";
    const Map<String, String> monthsInYear = {
      "Jan.": "January",
      "Feb.": "February",
      "Mar.": "March",
      "Apr.": "April",
      "May": "May",
      "Jun.": "June",
      "Jul.": "July",
      "Aug.": "August",
      "Sep.": "September",
      "Oct.": "October",
      "Nov.": "November",
      "Dec.": "December"
    };

    try {
      dateOfBirth = dateOfBirthExtract[0].trim() +
          " " +
          monthsInYear[dateOfBirthExtract[1].trim()] +
          " " +
          (dateOfBirthExtract[2].trim()).substring(0, 4);
    } catch (e) {
      dateOfBirth = '';
    }

    // Get Identification No.
    var resultsIdNo = '';
    RegExp exp = new RegExp(r'\d\s\d{4}\s\d{5}\s\d{2}\s\d');
    bool isMatch = exp.hasMatch(text);
    if (isMatch) {
      log(exp.stringMatch(text));
      resultsIdNo = (exp.stringMatch(text)).replaceAll(" ", "");
    }

    // Get Identification No.
    // try {
    //   var indexFirst = text.indexOf('\n');
    //   var indexSecond = text.indexOf('\n', indexFirst + 1);
    //   var indexThird = text.indexOf('\n', indexSecond + 1);
    //   var indexFourth = text.indexOf('\n', indexThird + 1);
    //   var subString = text.substring(0, indexFourth);
    //   var splitText = text.split('\n');
    //   var countNextline = ('\n').allMatches(subString).length;
    //   for (var i = 0; i <= countNextline; i++) {
    //     if (splitText[i][0].contains(new RegExp(r'[0-9]'))) {
    //       resultsListOutline[0] = splitText[i][0];
    //       break;
    //     }
    //   }
    // } catch (e) {
    //   resultsListOutline[0] = '';
    // }

    Person person = new Person();
    person.nameTitleTh = resultNameTitleTh;
    person.firstnameTh = resultNameTh;
    person.lastnameTh = resultLastNameTh;
    person.firstnameEng = resultNameEng;
    person.lastnameEng = resultsListInline[2];
    // person.idno = resultsListOutline[0].replaceAll(" ", "");
    person.idno = resultsIdNo;
    person.dateOfBirth = dateOfBirth;
    person.address = resultsListInline[5];
    person.religion = resultsListInline[4];

    return person;
  }

  Person drivingLicenseExtractData(String text) {
    var drivingLicenseType = [
      'รถยนต์ชั่วคราว',
      'รถยนต์สามล้อชั่วคราว',
      'จักรยานยนต์ส่วนบุคคลชั่วคราว',
      'รถยนต์ส่วนบุคคล',
      'รถยนต์สามล้อส่วนบุคคล',
      'รถยนต์สาธารณะ',
      'รถยนต์สามล้อสาธารณะ',
      'รถจักรยานยนต์ส่วนบุคคล',
      'รถจักรยานยนต์สาธารณะ',
      'รถบดถนน',
      'รถแทรกเตอร์',
      'ใบอนุญาตขับรถชนิดอื่นนอกจาก 1.-9.'
    ];
    var nameTitleTh = ['นาย', 'นาง', 'น.ส'];
    var nameTitleEng = ['MR.', 'MRS.', 'MISS'];

    log("-----------Extract Data----------");

    var textIdno = 'Identification Number';
    var textNameTh = 'ชื่อตัวและชื่อสกุล';
    var textNameEng = 'Name';
    var textLastNameEng = 'Last name';
    var textDateOfBirth = 'Date of Birth';
    var textReligion = 'ศาสนา';
    var textAddress = 'ที่อยู่';
    var textProvince = 'จ.';
    var textDateofIssue = 'วันออกบัตร';
    var textDateofExpiry = 'วันบัตรหมดอายุ';
    var textListInLine = [
      textNameTh,
      textNameEng,
      textLastNameEng,
      textDateOfBirth,
      textReligion,
      textAddress,
      textProvince
    ];
    var textListOutLine = [textIdno, textDateofIssue, textDateofExpiry];
    var resultsListInline = [];
    var resultsListOutline = [];

    var lines = text.split("\n");
    int countLines = lines.length;
    log("--------------------------------Count: " +
        countLines.toString() +
        "---------------------------");

    //find No
    var resultNo = '';
    for (var line in lines) {
      RegExp exp = new RegExp(r'\d{8}');
      bool isMatch = exp.hasMatch(line);
      if (isMatch) {
        log(exp.stringMatch(line));
        resultNo = exp.stringMatch(line);
        break;
      }
    }

    //find Idno
    var resultsIdNo = '';
    for (var line in lines) {
      RegExp exp = new RegExp(r'\d\s\d{4}\s\d{5}\s\d{2}\s\d');
      bool isMatch = exp.hasMatch(line);
      if (isMatch) {
        log(exp.stringMatch(line));
        resultsIdNo = (exp.stringMatch(line)).replaceAll(" ", "");
        break;
      }
    }

    //find DateOfBirth Th
    for (var line in lines) {
      RegExp exp = new RegExp(
          r'(\b\d{1,2}\D{0,3})(?:มกราคม|กุมภาพันธ์|มีนาคม|เมษายน|พฤษภาคม|มิถุนายน|กรกฎาคม|สิงหาคม|กันยายน|ตุลาคม|พฤศจิกายน|ธันวาคม)\D?(\d{1,2}\D?)?\D?((19[7-9]\d|20\d{2})|\d{2})');
      bool isMatch = exp.hasMatch(line);
      if (isMatch) {
        log(exp.stringMatch(line));
      }
    }

    var dateOfBirthList = [];
    RegExp exp;
    bool isMatch;
    //find dateOfBirth
    var resultsDateOfBirth = '';
    exp = new RegExp(
        r'(\d{1,2}\s{1})(?:Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|(Nov|Dec)(?:ember)?)(\s{1}\d{4})');
    isMatch = exp.hasMatch(text);
    if (isMatch) {
      log("---------Date---------");
      Iterable<RegExpMatch> iterable = exp.allMatches(text);
      log((iterable.length).toString());
      log(iterable.toList().toString());
      log("---------Date---------");
      log((iterable.elementAt(0)[0]).toString());
      for (int i = 0; i < iterable.length; i++) {
        log(i.toString());
        dateOfBirthList.add((iterable.elementAt(i)[0]).toString());
      }
      log(dateOfBirthList.toString());
    }

    if ((dateOfBirthList.length == 2) && ((text.indexOf('Life Time')) > 0)) {
      var date1 = dateOfBirthList[0].split(" ");
      var date2 = dateOfBirthList[1].split(" ");
      if (int.parse(date1[2]) < int.parse(date2[2])) {
        resultsDateOfBirth = dateOfBirthList[0];
      } else if (int.parse(date2[2]) < int.parse(date1[2])) {
        resultsDateOfBirth = dateOfBirthList[1];
      }
    } else if (dateOfBirthList.length == 3) {
      var date1 = dateOfBirthList[0].split(" ");
      var date2 = dateOfBirthList[1].split(" ");
      var date3 = dateOfBirthList[2].split(" ");
      if ((int.parse(date1[2]) < int.parse(date2[2])) &&
          (int.parse(date1[2]) < int.parse(date3[2]))) {
        log(dateOfBirthList[0]);
        resultsDateOfBirth = dateOfBirthList[0];
      } else if ((int.parse(date2[2]) < int.parse(date1[2])) &&
          (int.parse(date2[2]) < int.parse(date3[2]))) {
        log(dateOfBirthList[1]);
        resultsDateOfBirth = dateOfBirthList[1];
      } else if ((int.parse(date3[2]) < int.parse(date1[2])) &&
          (int.parse(date3[2]) < int.parse(date2[2]))) {
        log(dateOfBirthList[2]);
        resultsDateOfBirth = dateOfBirthList[2];
      }
    }

    // Split Date of Birth
    if (resultsDateOfBirth != "") {
      var dateOfBirthExtract = resultsDateOfBirth.split(" ");
      try {
        resultsDateOfBirth = dateOfBirthExtract[0].trim() +
            " " +
            dateOfBirthExtract[1].trim() +
            " " +
            (dateOfBirthExtract[2].trim()).substring(0, 4);
      } catch (e) {
        resultsDateOfBirth = '';
      }
    }

    //find name th
    var resultsFirstNameTh = '';
    var resultsLastNameTh = '';
    var resultsNameTitleTh = '';
    for (var line in lines) {
      RegExp exp = new RegExp(
          r'(?:นาย|นาง|นางสาว|น.ส.)(\s)([ก-๙]{3,30}\s)([ก-๙]{3,30})');
      // r'((.*)(นาย|นาง|นางสาว|น.ส.)(\s)([ก-๙]{2,30}\s)([ก-๙]{2,30}))');
      bool isMatch = exp.hasMatch(line);
      if (isMatch) {
        log(exp.stringMatch(line));
        var splitText = (exp.stringMatch(line)).split(' ');
        log(splitText.toString());
        resultsNameTitleTh = splitText[0];
        resultsFirstNameTh = splitText[1];
        resultsLastNameTh = splitText[2];
      }
    }

    var resultsFirstNameEng = '';
    var resultsLastNameEng = '';
    for (var line in lines) {
      RegExp exp =
          new RegExp(r'(?:MR.|MRS.|MISS)(\s)([A-Z]{3,30}\s)([A-Z]{3,30})');
      bool isMatch = exp.hasMatch(line);
      if (isMatch) {
        log(exp.stringMatch(line));
        var splitText = (exp.stringMatch(line)).split(' ');
        log(splitText.toString());
        log((splitText.length).toString());
        resultsFirstNameEng = splitText[1][0].toUpperCase() +
            splitText[1].substring(1).toLowerCase();
        resultsLastNameEng = splitText[2][0].toUpperCase() +
            splitText[2].substring(1).toLowerCase();
      }
    }

    var resultsType = '';
    for (var type in drivingLicenseType) {
      log("- contain -");
      log((text.indexOf(type)).toString());
      if ((text.indexOf(type)) > 0) {
        resultsType = type;
        break;
      }
    }

    log("-------------------------------END------------------------------");

    Person person = new Person();
    person.nameTitleTh = resultsNameTitleTh;
    person.firstnameTh = resultsFirstNameTh;
    person.lastnameTh = resultsLastNameTh;
    person.firstnameEng = resultsFirstNameEng;
    person.lastnameEng = resultsLastNameEng;
    person.idno = resultsIdNo;
    person.dateOfBirth = resultsDateOfBirth;

    print("title: " + resultsNameTitleTh);
    print("firstnameTh: " + resultsFirstNameTh);
    print("lastnameEng: " + resultsLastNameTh);
    print("firstnameEng: " + resultsFirstNameEng);
    print("lastnameEng: " + resultsLastNameEng);
    print("idno: " + resultsIdNo);
    print("dateOfBirth: " + resultsDateOfBirth);

    // firstNameThDLController.text = resultsFirstNameTh;
    // lastNameThDLController.text = resultsLastNameTh;
    // firstNameEngDLController.text = resultsFirstNameEng;
    // lastNameEngDLController.text = resultsLastNameEng;
    // idNoDLController.text = resultsIdNo;
    // dateOfBirthDLController.text = resultsDateOfBirth;
    // noDLController.text = resultNo;
    // typeDLController.text = resultsType;

    return person;
    //To do bug no return but got number
  }

  Person passportExtractData(String text) {
     
    RegExp exp;
    bool isMatch;
    //find Idno
    var resultsPassportNo = '';
    exp = new RegExp(r'(Passport.*)[\r\n]+([A-Z0-9] ?[A-Z0-9] ?[A-Z0-9] ?[A-Z0-9] ?[A-Z0-9] ?[A-Z0-9] ?[A-Z0-9] ?[A-Z0-9]? ?[A-Z0-9]?)');
    isMatch = exp.hasMatch(text);
    if (isMatch) {
      log("---------PassportNo---------");
      Iterable<RegExpMatch> iterable = exp.allMatches(text);
      log((iterable.elementAt(0)[2]).toString());
      resultsPassportNo =
          ((iterable.elementAt(0)[2]).toString().replaceAll(" ", ""));
    }

    var resultsNationality = '';
    exp = new RegExp(r'(Nationality.*)[\r\n]+([A-Z]{2}.*)');
    isMatch = exp.hasMatch(text);
    if (isMatch) {
      log("---------Nationality---------");
      Iterable<RegExpMatch> iterable = exp.allMatches(text);
      log((iterable.elementAt(0)[2]).toString());
      resultsNationality =
          ((iterable.elementAt(0)[2]).toString().replaceAll(" ", ""));
      resultsNationality =
          "${resultsNationality[0].toUpperCase()}${(resultsNationality.substring(1)).toLowerCase()}";
    }

    var resultsPersonalNo = '';
    exp = new RegExp(r'\d{13}');
    isMatch = exp.hasMatch(text);
    if (isMatch) {
      log("---------Personal No---------");
      Iterable<RegExpMatch> iterable = exp.allMatches(text);
      log((iterable.elementAt(0)[0]).toString());
      resultsPersonalNo =
          ((iterable.elementAt(0)[0]).toString().replaceAll(" ", ""));
    }

    var resultsFirstNameEng = '';
    var resultsNameTitleTh = '';
    exp = new RegExp(r'(MR.|MRS.|MISS|MASTER).*');
    isMatch = exp.hasMatch(text);
    if (isMatch) {
      log("---------First Name Eng---------");
      Iterable<RegExpMatch> iterable = exp.allMatches(text);
      log((iterable.elementAt(0)[0]).toString());

      // resultsFirstNameEng = ((iterable.elementAt(0)[0]).toString().replaceAll(" ", ""));
      var firstNameEng = ((iterable.elementAt(0)[0]).toString());
      var firstNameEngExtract = firstNameEng.split(" ");
      resultsFirstNameEng = firstNameEngExtract[1].trim();
      resultsNameTitleTh = "${resultsFirstNameEng[0].toUpperCase()}";
      resultsFirstNameEng =
          "${resultsFirstNameEng[0].toUpperCase()}${(resultsFirstNameEng.substring(1)).toLowerCase()}";
    }

    var resultsLastNameEng = '';
        exp = new RegExp(r'(Surname.*)[\r\n]+([A-Z]{2}.*)');
    isMatch = exp.hasMatch(text);
    if (isMatch) {
      log("---------Lastname Name Eng---------");
      Iterable<RegExpMatch> iterable = exp.allMatches(text);
      log((iterable.elementAt(0)[2]).toString());
      resultsLastNameEng =
          ((iterable.elementAt(0)[2]).toString().replaceAll(" ", ""));
      resultsLastNameEng =
          "${resultsLastNameEng[0].toUpperCase()}${(resultsLastNameEng.substring(1)).toLowerCase()}";
    }

    var resultsFirstNameTh = '';
    var resultsLastNameTh = '';
    exp = new RegExp(r'(นาย|นาง|นางสาว|น.ส.|เด็กชาย|เด็กหญิง).*');
    isMatch = exp.hasMatch(text);
    if (isMatch) {
      log("---------Last Name Th---------");
      Iterable<RegExpMatch> iterable = exp.allMatches(text);
      log((iterable.elementAt(0)[0]).toString());
      var nameTh = ((iterable.elementAt(0)[0]).toString());
      var nameThExtract = nameTh.split(" ");
      resultsFirstNameTh = nameThExtract[1].trim();
      resultsLastNameTh = nameThExtract[2].trim();
    }

    var dateOfBirthList = [];

    //find dateOfBirth
    var resultsDateOfBirth = '';
    exp = new RegExp(
        r'(\d{1,2}\s{1})(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)(\s{1}\d{4})');
    isMatch = exp.hasMatch(text);
    if (isMatch) {
      log("---------Date---------");
      Iterable<RegExpMatch> iterable = exp.allMatches(text);
      log((iterable.length).toString());
      log(iterable.toList().toString());
      log("---------Date---------");
      log((iterable.elementAt(0)[0]).toString());
      for (int i = 0; i < iterable.length; i++) {
        log(i.toString());
        dateOfBirthList.add((iterable.elementAt(i)[0]).toString());
      }
      log(dateOfBirthList.toString());
    }

    if (dateOfBirthList.length == 3) {
      var date1 = dateOfBirthList[0].split(" ");
      var date2 = dateOfBirthList[1].split(" ");
      var date3 = dateOfBirthList[2].split(" ");
      if ((int.parse(date1[2]) < int.parse(date2[2])) &&
          (int.parse(date1[2]) < int.parse(date3[2]))) {
        log(dateOfBirthList[0]);
        resultsDateOfBirth = dateOfBirthList[0];
      } else if ((int.parse(date2[2]) < int.parse(date1[2])) &&
          (int.parse(date2[2]) < int.parse(date3[2]))) {
        log(dateOfBirthList[1]);
        resultsDateOfBirth = dateOfBirthList[1];
      } else if ((int.parse(date3[2]) < int.parse(date1[2])) &&
          (int.parse(date3[2]) < int.parse(date2[2]))) {
        log(dateOfBirthList[2]);
        resultsDateOfBirth = dateOfBirthList[2];
      }

      var dateOfBirthExtract = resultsDateOfBirth.split(" ");

      const Map<String, String> monthsInYear = {
        "JAN": "January",
        "FEB": "February",
        "MAR": "March",
        "APR": "April",
        "MAY": "May",
        "JUN": "June",
        "JUL": "July",
        "AUG": "August",
        "SEP": "September",
        "OCT": "October",
        "NOV": "November",
        "DEC": "December"
      };

      try {
        resultsDateOfBirth = dateOfBirthExtract[0].trim() +
            " " +
            monthsInYear[dateOfBirthExtract[1].trim()] +
            " " +
            (dateOfBirthExtract[2].trim());
      } catch (e) {
        resultsDateOfBirth = '';
      }
    }

    log("-------------------------------END------------------------------");
    
    Person person = new Person();
    person.nameTitleTh = resultsNameTitleTh;
    person.firstnameTh = resultsFirstNameTh;
    person.lastnameTh = resultsLastNameTh;
    person.firstnameEng = resultsFirstNameEng;
    person.lastnameEng = resultsLastNameEng;
    person.idno = resultsPersonalNo;
    person.dateOfBirth = resultsDateOfBirth;

    return person;
  }
}
