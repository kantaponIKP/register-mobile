// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:register_demo/firebase_ml_vision.dart';
// import 'package:register_demo/detector_painters.dart';
// import 'package:register_demo/models/person.dart';
// import 'package:register_demo/screens/dialogs.dart';
// import 'package:register_demo/screens/register/previewPicturePage.dart';

// import 'registerSecond.dart';

// class RegisterPage extends StatefulWidget {
//   @override
//   _RegisterPageState createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage>
//     with SingleTickerProviderStateMixin {
//   TextEditingController firstNameThIDController = TextEditingController();
//   TextEditingController lastNameThIDController = TextEditingController();
//   TextEditingController firstNameEngIDController = TextEditingController();
//   TextEditingController lastNameEngIDController = TextEditingController();
//   TextEditingController idNoIDController = TextEditingController();
//   TextEditingController dateOfBirthIDController = TextEditingController();
//   TextEditingController addressIDController = TextEditingController();
//   TextEditingController religionIDController = TextEditingController();

//   TextEditingController noDLController = TextEditingController();
//   TextEditingController typeDLController = TextEditingController();
//   TextEditingController firstNameThDLController = TextEditingController();
//   TextEditingController lastNameThDLController = TextEditingController();
//   TextEditingController firstNameEngDLController = TextEditingController();
//   TextEditingController lastNameEngDLController = TextEditingController();
//   TextEditingController idNoDLController = TextEditingController();
//   TextEditingController dateOfBirthDLController = TextEditingController();

//   TextEditingController passportNoPPController = TextEditingController();
//   TextEditingController nationalityPPController = TextEditingController();
//   TextEditingController firstNameThPPController = TextEditingController();
//   TextEditingController lastNameThPPController = TextEditingController();
//   TextEditingController firstNameEngPPController = TextEditingController();
//   TextEditingController lastNameEngPPController = TextEditingController();
//   TextEditingController personalNoPPController = TextEditingController();
//   TextEditingController dateOfBirthPPController = TextEditingController();

//   Person person;
//   File _imageFileID;
//   File _imageFileDL;
//   File _imageFilePP;
//   PickedFile _pickedImageID;
//   PickedFile _pickedImageDL;
//   PickedFile _pickedImagePP;
//   Size _imageSizeID;
//   Size _imageSizeDL;
//   Size _imageSizePP;
//   dynamic _scanResultsID;
//   dynamic _scanResultsDL;
//   dynamic _scanResultsPP;

//   static const Map<int, String> monthsInYear = {
//     1: "January",
//     2: "February",
//     3: "March",
//     4: "April",
//     5: "May",
//     6: "June",
//     7: "July",
//     8: "August",
//     9: "September",
//     10: "October",
//     11: "November",
//     12: "December"
//   };

//   Detector _currentDetector = Detector.cloudText;
//   final BarcodeDetector _barcodeDetector =
//       FirebaseVision.instance.barcodeDetector();
//   final FaceDetector _faceDetector = FirebaseVision.instance.faceDetector();
//   final ImageLabeler _imageLabeler = FirebaseVision.instance.imageLabeler();
//   final ImageLabeler _cloudImageLabeler =
//       FirebaseVision.instance.cloudImageLabeler();
//   final TextRecognizer _recognizer = FirebaseVision.instance.textRecognizer();
//   final TextRecognizer _cloudRecognizer =
//       FirebaseVision.instance.cloudTextRecognizer();
//   final DocumentTextRecognizer _cloudDocumentRecognizer =
//       FirebaseVision.instance.cloudDocumentTextRecognizer();
//   final ImagePicker _picker = ImagePicker();
//   final GlobalKey<State> _keyLoader = new GlobalKey<State>();

//   DateTime selectedDate = DateTime.now();

//   ImageSource _imgsourceID;
//   ImageSource _imgsourceDL;
//   ImageSource _imgsourcePP;

//   final List<Tab> tabs = <Tab>[
//     new Tab(icon: Icon(Icons.person), text: "ID Card"),
//     new Tab(icon: Icon(Icons.directions_car), text: "Driving License"),
//     new Tab(icon: Icon(Icons.book), text: "Passport"),
//   ];

//   TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = new TabController(vsync: this, length: tabs.length);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _barcodeDetector.close();
//     _faceDetector.close();
//     _imageLabeler.close();
//     _cloudImageLabeler.close();
//     _recognizer.close();
//     _cloudRecognizer.close();
//     super.dispose();
//   }

//   idExtractData(var text) {
//     log("-----------Extract Data----------");

//     var textIdno = 'Identification Number';
//     var textNameTh = 'ชื่อตัวและชื่อสกุล';
//     var textNameEng = 'Name';
//     var textLastNameEng = 'Last name';
//     var textDateOfBirth = 'Date of Birth';
//     var textReligion = 'ศาสนา';
//     var textAddress = 'ที่อยู่';
//     var textProvince = 'จ.';
//     var textDateofIssue = 'วันออกบัตร';
//     var textDateofExpiry = 'วันบัตรหมดอายุ';
//     var textListInLine = [
//       textNameTh,
//       textNameEng,
//       textLastNameEng,
//       textDateOfBirth,
//       textReligion,
//       textAddress,
//       textProvince
//     ];
//     var textListOutLine = [textIdno, textDateofIssue, textDateofExpiry];
//     var resultsListInline = [];
//     var resultsListOutline = [];

//     // Inline Extract
//     for (var i = 0; i < textListInLine.length; i++) {
//       try {
//         var indexStart = text.indexOf(textListInLine[i]);
//         var subString = text.substring(indexStart);
//         var indexEnd = subString.indexOf('\n');
//         resultsListInline.add(text
//             .substring(
//                 indexStart + textListInLine[i].length, indexStart + indexEnd)
//             .trim());
//         // log("--------result-------");
//         // log(resultsListInline[i]);
//       } catch (e) {
//         // log("--------result-------");
//         // log(resultsListInline[i]);
//         resultsListInline.add('');
//       }
//     }

//     // Outline Extract
//     for (var i = 0; i < textListOutLine.length; i++) {
//       try {
//         var indexStart = text.indexOf(textListOutLine[i]);
//         var subString = text.substring(indexStart);
//         var indexEnd = subString.indexOf('\n');
//         var indexEndSecond = subString.indexOf('\n', indexEnd + 1);
//         resultsListOutline.add(text
//             .substring(indexStart + textListOutLine[i].length + 1,
//                 indexStart + indexEndSecond)
//             .trim());
//         // log("--------result-------");
//         // log(resultsListOutline[i]);
//       } catch (e) {
//         // log("--------result-------");
//         // log(resultsListOutline[i]);
//         resultsListOutline.add('');
//       }
//     }

//     var resultNameTitleTh = '';
//     var resultNameTh = '';
//     var resultLastNameTh = '';
//     // Split Thai name
//     var nameThExtract = resultsListInline[0].split(" ");
//     try {
//       resultNameTitleTh = nameThExtract[0];
//     } catch (e) {
//       resultNameTitleTh = '';
//     }
//     try {
//       resultNameTh = nameThExtract[1];
//     } catch (e) {
//       resultNameTh = '';
//     }
//     try {
//       resultLastNameTh = nameThExtract[2];
//     } catch (e) {
//       resultLastNameTh = '';
//     }

//     var resultNameTitleEng = '';
//     var resultNameEng = '';
//     var resultLastNameEng = '';
//     // Split Eng name
//     var nameEngExtract = resultsListInline[1].split(" ");
//     try {
//       resultNameTitleEng = nameEngExtract[0];
//     } catch (e) {
//       resultNameTitleEng = '';
//     }
//     try {
//       resultNameEng = nameEngExtract[1];
//     } catch (e) {
//       resultNameEng = '';
//     }

//     // Split Date of Birth
//     var dateOfBirthExtract = resultsListInline[3].split(" ");
//     var dateOfBirth = "";
//     const Map<String, String> monthsInYear = {
//       "Jan.": "January",
//       "Feb.": "February",
//       "Mar.": "March",
//       "Apr.": "April",
//       "May": "May",
//       "Jun.": "June",
//       "Jul.": "July",
//       "Aug.": "August",
//       "Sep.": "September",
//       "Oct.": "October",
//       "Nov.": "November",
//       "Dec.": "December"
//     };

//     try {
//       dateOfBirth = dateOfBirthExtract[0].trim() +
//           " " +
//           monthsInYear[dateOfBirthExtract[1].trim()] +
//           " " +
//           (dateOfBirthExtract[2].trim()).substring(0, 4);
//     } catch (e) {
//       dateOfBirth = '';
//     }

//     // Get Identification No.
//     try {
//       var indexFirst = text.indexOf('\n');
//       var indexSecond = text.indexOf('\n', indexFirst + 1);
//       var indexThird = text.indexOf('\n', indexSecond + 1);
//       var indexFourth = text.indexOf('\n', indexThird + 1);
//       var subString = text.substring(0, indexFourth);
//       var splitText = text.split('\n');
//       var countNextline = ('\n').allMatches(subString).length;
//       for (var i = 0; i <= countNextline; i++) {
//         if (splitText[i][0].contains(new RegExp(r'[0-9]'))) {
//           resultsListOutline[0] = splitText[i];
//           break;
//         }
//       }
//     } catch (e) {
//       resultsListOutline[0] = '';
//     }
//     firstNameThIDController.text = resultNameTh;
//     lastNameThIDController.text = resultLastNameTh;
//     firstNameEngIDController.text = resultNameEng;
//     lastNameEngIDController.text = resultsListInline[2];
//     idNoIDController.text = resultsListOutline[0].replaceAll(" ", "");
//     dateOfBirthIDController.text = dateOfBirth;
//     addressIDController.text = resultsListInline[5];
//     religionIDController.text = resultsListInline[4];
//   }

//   dlExtractData(var text) {
//     var drivingLicenseType = [
//       'รถยนต์ชั่วคราว',
//       'รถยนต์สามล้อชั่วคราว',
//       'จักรยานยนต์ส่วนบุคคลชั่วคราว',
//       'รถยนต์ส่วนบุคคล',
//       'รถยนต์สามล้อส่วนบุคคล',
//       'รถยนต์สาธารณะ',
//       'รถยนต์สามล้อสาธารณะ',
//       'รถจักรยานยนต์ส่วนบุคคล',
//       'รถจักรยานยนต์สาธารณะ',
//       'รถบดถนน',
//       'รถแทรกเตอร์',
//       'ใบอนุญาตขับรถชนิดอื่นนอกจาก 1.-9.'
//     ];
//     var nameTitleTh = ['นาย', 'นาง', 'น.ส'];
//     var nameTitleEng = ['MR.', 'MRS.', 'MISS'];

//     log("-----------Extract Data----------");

//     var textIdno = 'Identification Number';
//     var textNameTh = 'ชื่อตัวและชื่อสกุล';
//     var textNameEng = 'Name';
//     var textLastNameEng = 'Last name';
//     var textDateOfBirth = 'Date of Birth';
//     var textReligion = 'ศาสนา';
//     var textAddress = 'ที่อยู่';
//     var textProvince = 'จ.';
//     var textDateofIssue = 'วันออกบัตร';
//     var textDateofExpiry = 'วันบัตรหมดอายุ';
//     var textListInLine = [
//       textNameTh,
//       textNameEng,
//       textLastNameEng,
//       textDateOfBirth,
//       textReligion,
//       textAddress,
//       textProvince
//     ];
//     var textListOutLine = [textIdno, textDateofIssue, textDateofExpiry];
//     var resultsListInline = [];
//     var resultsListOutline = [];

//     var lines = text.split("\n");
//     int countLines = lines.length;
//     log("--------------------------------Count: " +
//         countLines.toString() +
//         "---------------------------");

//     //find No
//     var resultNo = '';
//     for (var line in lines) {
//       RegExp exp = new RegExp(r'\d{8}');
//       bool isMatch = exp.hasMatch(line);
//       if (isMatch) {
//         log(exp.stringMatch(line));
//         resultNo = exp.stringMatch(line);
//         break;
//       }
//     }

//     //find Idno
//     var resultsIdNo = '';
//     for (var line in lines) {
//       RegExp exp = new RegExp(r'\d\s\d{4}\s\d{5}\s\d{2}\s\d');
//       bool isMatch = exp.hasMatch(line);
//       if (isMatch) {
//         log(exp.stringMatch(line));
//         resultsIdNo = (exp.stringMatch(line)).replaceAll(" ", "");
//         break;
//       }
//     }

//     //find DateOfBirth Th
//     for (var line in lines) {
//       RegExp exp = new RegExp(
//           r'(\b\d{1,2}\D{0,3})(?:มกราคม|กุมภาพันธ์|มีนาคม|เมษายน|พฤษภาคม|มิถุนายน|กรกฎาคม|สิงหาคม|กันยายน|ตุลาคม|พฤศจิกายน|ธันวาคม)\D?(\d{1,2}\D?)?\D?((19[7-9]\d|20\d{2})|\d{2})');
//       bool isMatch = exp.hasMatch(line);
//       if (isMatch) {
//         log(exp.stringMatch(line));
//       }
//     }

//     var dateOfBirthList = [];
//     RegExp exp;
//     bool isMatch;
//     //find dateOfBirth
//     var resultsDateOfBirth = '';
//     exp = new RegExp(
//         r'(\d{1,2}\s{1})(?:Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|(Nov|Dec)(?:ember)?)(\s{1}\d{4})');
//     isMatch = exp.hasMatch(text);
//     if (isMatch) {
//       log("---------Date---------");
//       Iterable<RegExpMatch> iterable = exp.allMatches(text);
//       log((iterable.length).toString());
//       log(iterable.toList().toString());
//       log("---------Date---------");
//       log((iterable.elementAt(0)[0]).toString());
//       for (int i = 0; i < iterable.length; i++) {
//         log(i.toString());
//         dateOfBirthList.add((iterable.elementAt(i)[0]).toString());
//       }
//       log(dateOfBirthList.toString());
//     }

//     if ((dateOfBirthList.length == 2) && ((text.indexOf('Life Time')) > 0)) {
//       var date1 = dateOfBirthList[0].split(" ");
//       var date2 = dateOfBirthList[1].split(" ");
//       if (int.parse(date1[2]) < int.parse(date2[2])) {
//         resultsDateOfBirth = dateOfBirthList[0];
//       } else if (int.parse(date2[2]) < int.parse(date1[2])) {
//         resultsDateOfBirth = dateOfBirthList[1];
//       }
//     } else if (dateOfBirthList.length == 3) {
//       var date1 = dateOfBirthList[0].split(" ");
//       var date2 = dateOfBirthList[1].split(" ");
//       var date3 = dateOfBirthList[2].split(" ");
//       if ((int.parse(date1[2]) < int.parse(date2[2])) &&
//           (int.parse(date1[2]) < int.parse(date3[2]))) {
//         log(dateOfBirthList[0]);
//         resultsDateOfBirth = dateOfBirthList[0];
//       } else if ((int.parse(date2[2]) < int.parse(date1[2])) &&
//           (int.parse(date2[2]) < int.parse(date3[2]))) {
//         log(dateOfBirthList[1]);
//         resultsDateOfBirth = dateOfBirthList[1];
//       } else if ((int.parse(date3[2]) < int.parse(date1[2])) &&
//           (int.parse(date3[2]) < int.parse(date2[2]))) {
//         log(dateOfBirthList[2]);
//         resultsDateOfBirth = dateOfBirthList[2];
//       }
//     }

//     // Split Date of Birth
//     if (resultsDateOfBirth != "") {
//       var dateOfBirthExtract = resultsDateOfBirth.split(" ");
//       try {
//         resultsDateOfBirth = dateOfBirthExtract[0].trim() +
//             " " +
//             dateOfBirthExtract[1].trim() +
//             " " +
//             (dateOfBirthExtract[2].trim()).substring(0, 4);
//       } catch (e) {
//         resultsDateOfBirth = '';
//       }
//     }

//     //find name th
//     var resultsFirstNameTh = '';
//     var resultsLastNameTh = '';
//     for (var line in lines) {
//       RegExp exp = new RegExp(
//           r'(?:นาย|นาง|นางสาว|น.ส.)(\s)([ก-๙]{3,30}\s)([ก-๙]{3,30})');
//       bool isMatch = exp.hasMatch(line);
//       if (isMatch) {
//         log(exp.stringMatch(line));
//         var splitText = (exp.stringMatch(line)).split(' ');
//         log(splitText.toString());
//         resultsFirstNameTh = splitText[1];
//         resultsLastNameTh = splitText[2];
//       }
//     }

//     var resultsFirstNameEng = '';
//     var resultsLastNameEng = '';
//     for (var line in lines) {
//       RegExp exp =
//           new RegExp(r'(?:MR.|MRS|MISS)(\s)([A-Z]{3,30}\s)([A-Z]{3,30})');
//       bool isMatch = exp.hasMatch(line);
//       if (isMatch) {
//         log(exp.stringMatch(line));
//         var splitText = (exp.stringMatch(line)).split(' ');
//         log(splitText.toString());
//         log((splitText.length).toString());
//         resultsFirstNameEng = splitText[1][0].toUpperCase() +
//             splitText[1].substring(1).toLowerCase();
//         resultsLastNameEng = splitText[2][0].toUpperCase() +
//             splitText[2].substring(1).toLowerCase();
//       }
//     }

//     var resultsType = '';
//     for (var type in drivingLicenseType) {
//       log("- contain -");
//       log((text.indexOf(type)).toString());
//       if ((text.indexOf(type)) > 0) {
//         resultsType = type;
//         break;
//       }
//     }

//     log("-------------------------------END------------------------------");

//     firstNameThDLController.text = resultsFirstNameTh;
//     lastNameThDLController.text = resultsLastNameTh;
//     firstNameEngDLController.text = resultsFirstNameEng;
//     lastNameEngDLController.text = resultsLastNameEng;
//     idNoDLController.text = resultsIdNo;
//     dateOfBirthDLController.text = resultsDateOfBirth;
//     noDLController.text = resultNo;
//     typeDLController.text = resultsType;
//   }

//   ppExtractData(var text) {
  
//     RegExp exp;
//     bool isMatch;
//     //find Idno
//     var resultsPassportNo = '';
//     exp = new RegExp(r'(Passport.*)[\r\n]+([A-Z0-9] ?[A-Z0-9] ?[A-Z0-9] ?[A-Z0-9] ?[A-Z0-9] ?[A-Z0-9] ?[A-Z0-9] ?[A-Z0-9]? ?[A-Z0-9]?)');
//     isMatch = exp.hasMatch(text);
//     if (isMatch) {
//       log("---------PassportNo---------");
//       Iterable<RegExpMatch> iterable = exp.allMatches(text);
//       log((iterable.elementAt(0)[2]).toString());
//       resultsPassportNo =
//           ((iterable.elementAt(0)[2]).toString().replaceAll(" ", ""));
//     }

//     var resultsNationality = '';
//     exp = new RegExp(r'(Nationality.*)[\r\n]+([A-Z]{2}.*)');
//     isMatch = exp.hasMatch(text);
//     if (isMatch) {
//       log("---------Nationality---------");
//       Iterable<RegExpMatch> iterable = exp.allMatches(text);
//       log((iterable.elementAt(0)[2]).toString());
//       resultsNationality =
//           ((iterable.elementAt(0)[2]).toString().replaceAll(" ", ""));
//       resultsNationality =
//           "${resultsNationality[0].toUpperCase()}${(resultsNationality.substring(1)).toLowerCase()}";
//     }

//     var resultsPersonalNo = '';
//     exp = new RegExp(r'\d{13}');
//     isMatch = exp.hasMatch(text);
//     if (isMatch) {
//       log("---------Personal No---------");
//       Iterable<RegExpMatch> iterable = exp.allMatches(text);
//       log((iterable.elementAt(0)[0]).toString());
//       resultsPersonalNo =
//           ((iterable.elementAt(0)[0]).toString().replaceAll(" ", ""));
//     }

//     var resultsFirstNameEng = '';
//     exp = new RegExp(r'(MR.|MRS|MISS|MASTER).*');
//     isMatch = exp.hasMatch(text);
//     if (isMatch) {
//       log("---------First Name Eng---------");
//       Iterable<RegExpMatch> iterable = exp.allMatches(text);
//       log((iterable.elementAt(0)[0]).toString());

//       // resultsFirstNameEng = ((iterable.elementAt(0)[0]).toString().replaceAll(" ", ""));
//       var firstNameEng = ((iterable.elementAt(0)[0]).toString());
//       var firstNameEngExtract = firstNameEng.split(" ");
//       resultsFirstNameEng = firstNameEngExtract[1].trim();
//       resultsFirstNameEng =
//           "${resultsFirstNameEng[0].toUpperCase()}${(resultsFirstNameEng.substring(1)).toLowerCase()}";
//     }

//     var resultsLastNameEng = '';
//         exp = new RegExp(r'(Surname.*)[\r\n]+([A-Z]{2}.*)');
//     isMatch = exp.hasMatch(text);
//     if (isMatch) {
//       log("---------Lastname Name Eng---------");
//       Iterable<RegExpMatch> iterable = exp.allMatches(text);
//       log((iterable.elementAt(0)[2]).toString());
//       resultsLastNameEng =
//           ((iterable.elementAt(0)[2]).toString().replaceAll(" ", ""));
//       resultsLastNameEng =
//           "${resultsLastNameEng[0].toUpperCase()}${(resultsLastNameEng.substring(1)).toLowerCase()}";
//     }

//     var resultsFirstNameTh = '';
//     var resultsLastNameTh = '';
//     exp = new RegExp(r'(นาย|นาง|นางสาว|น.ส.|เด็กชาย|เด็กหญิง).*');
//     isMatch = exp.hasMatch(text);
//     if (isMatch) {
//       log("---------Last Name Th---------");
//       Iterable<RegExpMatch> iterable = exp.allMatches(text);
//       log((iterable.elementAt(0)[0]).toString());
//       var nameTh = ((iterable.elementAt(0)[0]).toString());
//       var nameThExtract = nameTh.split(" ");
//       resultsFirstNameTh = nameThExtract[1].trim();
//       resultsLastNameTh = nameThExtract[2].trim();
//     }

//     var dateOfBirthList = [];

//     //find dateOfBirth
//     var resultsDateOfBirth = '';
//     exp = new RegExp(
//         r'(\d{1,2}\s{1})(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)(\s{1}\d{4})');
//     isMatch = exp.hasMatch(text);
//     if (isMatch) {
//       log("---------Date---------");
//       Iterable<RegExpMatch> iterable = exp.allMatches(text);
//       log((iterable.length).toString());
//       log(iterable.toList().toString());
//       log("---------Date---------");
//       log((iterable.elementAt(0)[0]).toString());
//       for (int i = 0; i < iterable.length; i++) {
//         log(i.toString());
//         dateOfBirthList.add((iterable.elementAt(i)[0]).toString());
//       }
//       log(dateOfBirthList.toString());
//     }

//     if (dateOfBirthList.length == 3) {
//       var date1 = dateOfBirthList[0].split(" ");
//       var date2 = dateOfBirthList[1].split(" ");
//       var date3 = dateOfBirthList[2].split(" ");
//       if ((int.parse(date1[2]) < int.parse(date2[2])) &&
//           (int.parse(date1[2]) < int.parse(date3[2]))) {
//         log(dateOfBirthList[0]);
//         resultsDateOfBirth = dateOfBirthList[0];
//       } else if ((int.parse(date2[2]) < int.parse(date1[2])) &&
//           (int.parse(date2[2]) < int.parse(date3[2]))) {
//         log(dateOfBirthList[1]);
//         resultsDateOfBirth = dateOfBirthList[1];
//       } else if ((int.parse(date3[2]) < int.parse(date1[2])) &&
//           (int.parse(date3[2]) < int.parse(date2[2]))) {
//         log(dateOfBirthList[2]);
//         resultsDateOfBirth = dateOfBirthList[2];
//       }

//       var dateOfBirthExtract = resultsDateOfBirth.split(" ");

//       const Map<String, String> monthsInYear = {
//         "JAN": "January",
//         "FEB": "February",
//         "MAR": "March",
//         "APR": "April",
//         "MAY": "May",
//         "JUN": "June",
//         "JUL": "July",
//         "AUG": "August",
//         "SEP": "September",
//         "OCT": "October",
//         "NOV": "November",
//         "DEC": "December"
//       };

//       try {
//         resultsDateOfBirth = dateOfBirthExtract[0].trim() +
//             " " +
//             monthsInYear[dateOfBirthExtract[1].trim()] +
//             " " +
//             (dateOfBirthExtract[2].trim());
//       } catch (e) {
//         resultsDateOfBirth = '';
//       }
//     }

//     log("-------------------------------END------------------------------");
    
//     firstNameEngPPController.text = resultsFirstNameEng;
//     lastNameEngPPController.text = resultsLastNameEng;
//     firstNameThPPController.text = resultsFirstNameTh;
//     lastNameThPPController.text = resultsLastNameTh;
//     passportNoPPController.text = resultsPassportNo;
//     personalNoPPController.text = resultsPersonalNo;
//     nationalityPPController.text = resultsNationality;
//     dateOfBirthPPController.text = resultsDateOfBirth;
//   }

//   Future<void> _getAndScanImageID(source) async {
//     setState(() {
//       _imageFileID = null;
//       _imageSizeID = null;
//     });

//     ImageSource imgsource;

//     if (source == 'camera') {
//       imgsource = ImageSource.camera;
//     } else if (source == 'gallery') {
//       imgsource = ImageSource.gallery;
//     } else {
//       imgsource = _imgsourceID;
//     }

//     setState(() {
//       _imgsourceID = imgsource;
//     });

//     final PickedFile pickedImage = await _picker.getImage(source: imgsource);
//     log("pickedImage");
//     log(pickedImage.toString());

//     if (pickedImage != null) {
//       final File imageFile = File(pickedImage.path);
//       if (imageFile != null) {
//         _getImageSizeID(imageFile);
//         Dialogs.showLoadingDialog(context, _keyLoader);
//         await _scanImageID(imageFile).timeout(Duration(seconds: 10));
//         Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
//         log("--POP--");
//         log("/" + _scanResultsID.text + "/");
//         if (_scanResultsID.text == "") {
//           showRetryIDAlertDialog(context);
//         }
//       }

//       setState(() {
//         _pickedImageID = pickedImage;
//         _imageFileID = imageFile;
//       });
//     }
//   }

//   Future<void> _getAndScanImageDL(source) async {
//     setState(() {
//       _imageFileDL = null;
//       _imageFileDL = null;
//     });

//     ImageSource imgsource;

//     if (source == 'camera') {
//       imgsource = ImageSource.camera;
//     } else if (source == 'gallery') {
//       imgsource = ImageSource.gallery;
//     } else {
//       imgsource = _imgsourceDL;
//     }

//     setState(() {
//       _imgsourceDL = imgsource;
//     });

//     final PickedFile pickedImage = await _picker.getImage(source: imgsource);
//     log("pickedImage");
//     log(pickedImage.toString());

//     if (pickedImage != null) {
//       final File imageFile = File(pickedImage.path);
//       if (imageFile != null) {
//         _getImageSizeDL(imageFile);
//         Dialogs.showLoadingDialog(context, _keyLoader);
//         await _scanImageDL(imageFile).timeout(Duration(seconds: 10));
//         Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
//         log("--POP--");
//         log("/" + _scanResultsDL.text + "/");
//         if (_scanResultsDL.text == "") {
//           showRetryDLAlertDialog(context);
//         }
//       }

//       setState(() {
//         _pickedImageDL = pickedImage;
//         _imageFileDL = imageFile;
//       });
//     }
//   }

//   Future<void> _getAndScanImagePP(source) async {
//     setState(() {
//       _imageFilePP = null;
//       _imageFilePP = null;
//     });

//     ImageSource imgsource;

//     if (source == 'camera') {
//       imgsource = ImageSource.camera;
//     } else if (source == 'gallery') {
//       imgsource = ImageSource.gallery;
//     } else {
//       imgsource = _imgsourcePP;
//     }

//     setState(() {
//       _imgsourcePP = imgsource;
//     });

//     final PickedFile pickedImage = await _picker.getImage(source: imgsource);
//     log("pickedImage");
//     log(pickedImage.toString());

//     if (pickedImage != null) {
//       final File imageFile = File(pickedImage.path);
//       if (imageFile != null) {
//         _getImageSizePP(imageFile);
//         Dialogs.showLoadingDialog(context, _keyLoader);
//         await _scanImagePP(imageFile).timeout(Duration(seconds: 10));
//         Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
//         if (_scanResultsPP.text == "") {
//           showRetryPPAlertDialog(context);
//         }
//       }

//       setState(() {
//         _pickedImagePP = pickedImage;
//         _imageFilePP = imageFile;
//       });
//     }
//   }

//   Future<void> _getImageSizeID(File imageFile) async {
//     final Completer<Size> completer = Completer<Size>();

//     final Image image = Image.file(imageFile);
//     image.image.resolve(const ImageConfiguration()).addListener(
//       ImageStreamListener((ImageInfo info, bool _) {
//         completer.complete(Size(
//           info.image.width.toDouble(),
//           info.image.height.toDouble(),
//         ));
//       }),
//     );

//     final Size imageSize = await completer.future;
//     setState(() {
//       _imageSizeID = imageSize;
//     });
//   }

//   Future<void> _getImageSizeDL(File imageFile) async {
//     final Completer<Size> completer = Completer<Size>();

//     final Image image = Image.file(imageFile);
//     image.image.resolve(const ImageConfiguration()).addListener(
//       ImageStreamListener((ImageInfo info, bool _) {
//         completer.complete(Size(
//           info.image.width.toDouble(),
//           info.image.height.toDouble(),
//         ));
//       }),
//     );

//     final Size imageSize = await completer.future;
//     setState(() {
//       _imageSizeDL = imageSize;
//     });
//   }

//   Future<void> _getImageSizePP(File imageFile) async {
//     final Completer<Size> completer = Completer<Size>();

//     final Image image = Image.file(imageFile);
//     image.image.resolve(const ImageConfiguration()).addListener(
//       ImageStreamListener((ImageInfo info, bool _) {
//         completer.complete(Size(
//           info.image.width.toDouble(),
//           info.image.height.toDouble(),
//         ));
//       }),
//     );

//     final Size imageSize = await completer.future;
//     setState(() {
//       _imageSizePP = imageSize;
//     });
//   }

//   Future<void> _scanImageID(File imageFile) async {
//     setState(() {
//       _scanResultsID = null;
//     });

//     final FirebaseVisionImage visionImage =
//         FirebaseVisionImage.fromFile(imageFile);

//     dynamic results;
//     switch (_currentDetector) {
//       case Detector.barcode:
//         results = await _barcodeDetector.detectInImage(visionImage);
//         break;
//       case Detector.face:
//         results = await _faceDetector.processImage(visionImage);
//         break;
//       case Detector.label:
//         results = await _imageLabeler.processImage(visionImage);
//         break;
//       case Detector.cloudLabel:
//         results = await _cloudImageLabeler.processImage(visionImage);
//         break;
//       case Detector.text:
//         results = await _recognizer.processImage(visionImage);
//         log("Log resultsText: ${results.text}");
//         break;
//       case Detector.cloudText:
//         results = await _cloudRecognizer.processImage(visionImage);
//         log("Log resultsText: ${results.text}");
//         break;
//       case Detector.cloudDocumentText:
//         results = await _cloudDocumentRecognizer.processImage(visionImage);
//         break;
//       default:
//         return;
//     }

//     setState(() {
//       _scanResultsID = results;
//     });

//     idExtractData(_scanResultsID.text);

//     print("tab index");
//     print(_tabController.index.toString());
//   }

//   Future<void> _scanImageDL(File imageFile) async {
//     setState(() {
//       _scanResultsDL = null;
//     });

//     final FirebaseVisionImage visionImage =
//         FirebaseVisionImage.fromFile(imageFile);

//     dynamic results;
//     switch (_currentDetector) {
//       case Detector.barcode:
//         results = await _barcodeDetector.detectInImage(visionImage);
//         break;
//       case Detector.face:
//         results = await _faceDetector.processImage(visionImage);
//         break;
//       case Detector.label:
//         results = await _imageLabeler.processImage(visionImage);
//         break;
//       case Detector.cloudLabel:
//         results = await _cloudImageLabeler.processImage(visionImage);
//         break;
//       case Detector.text:
//         results = await _recognizer.processImage(visionImage);
//         log("Log resultsText: ${results.text}");
//         break;
//       case Detector.cloudText:
//         results = await _cloudRecognizer.processImage(visionImage);
//         log("Log resultsText: ${results.text}");
//         break;
//       case Detector.cloudDocumentText:
//         results = await _cloudDocumentRecognizer.processImage(visionImage);
//         break;
//       default:
//         return;
//     }

//     setState(() {
//       _scanResultsDL = results;
//     });

//     dlExtractData(_scanResultsDL.text);

//     print("tab index");
//     print(_tabController.index.toString());
//   }

//   Future<void> _scanImagePP(File imageFile) async {
//     setState(() {
//       _scanResultsPP = null;
//     });

//     final FirebaseVisionImage visionImage =
//         FirebaseVisionImage.fromFile(imageFile);

//     dynamic results;
//     switch (_currentDetector) {
//       case Detector.barcode:
//         results = await _barcodeDetector.detectInImage(visionImage);
//         break;
//       case Detector.face:
//         results = await _faceDetector.processImage(visionImage);
//         break;
//       case Detector.label:
//         results = await _imageLabeler.processImage(visionImage);
//         break;
//       case Detector.cloudLabel:
//         results = await _cloudImageLabeler.processImage(visionImage);
//         break;
//       case Detector.text:
//         results = await _recognizer.processImage(visionImage);
//         log("Log resultsText: ${results.text}");
//         break;
//       case Detector.cloudText:
//         results = await _cloudRecognizer.processImage(visionImage);
//         log("Log resultsText: ${results.text}");
//         break;
//       case Detector.cloudDocumentText:
//         results = await _cloudDocumentRecognizer.processImage(visionImage);
//         break;
//       default:
//         return;
//     }

//     setState(() {
//       _scanResultsPP = results;
//     });

//     ppExtractData(_scanResultsPP.text);

//     print("tab index");
//     print(_tabController.index.toString());
//   }

//   CustomPaint _buildResultsID(Size imageSize, dynamic results) {
//     CustomPainter painter;

//     switch (_currentDetector) {
//       case Detector.barcode:
//         painter = BarcodeDetectorPainter(_imageSizeID, results);
//         break;
//       case Detector.face:
//         painter = FaceDetectorPainter(_imageSizeID, results);
//         break;
//       case Detector.label:
//         painter = LabelDetectorPainter(_imageSizeID, results);
//         break;
//       case Detector.cloudLabel:
//         painter = LabelDetectorPainter(_imageSizeID, results);
//         break;
//       case Detector.text:
//         painter = TextDetectorPainter(_imageSizeID, results);
//         break;
//       case Detector.cloudText:
//         painter = TextDetectorPainter(_imageSizeID, results);
//         break;
//       case Detector.cloudDocumentText:
//         painter = DocumentTextDetectorPainter(_imageSizeID, results);
//         break;
//       default:
//         break;
//     }
//     return CustomPaint(
//       painter: painter,
//     );
//   }

//   CustomPaint _buildResultsDL(Size imageSize, dynamic results) {
//     CustomPainter painter;

//     switch (_currentDetector) {
//       case Detector.barcode:
//         painter = BarcodeDetectorPainter(_imageSizeDL, results);
//         break;
//       case Detector.face:
//         painter = FaceDetectorPainter(_imageSizeDL, results);
//         break;
//       case Detector.label:
//         painter = LabelDetectorPainter(_imageSizeDL, results);
//         break;
//       case Detector.cloudLabel:
//         painter = LabelDetectorPainter(_imageSizeDL, results);
//         break;
//       case Detector.text:
//         painter = TextDetectorPainter(_imageSizeDL, results);
//         break;
//       case Detector.cloudText:
//         painter = TextDetectorPainter(_imageSizeDL, results);
//         break;
//       case Detector.cloudDocumentText:
//         painter = DocumentTextDetectorPainter(_imageSizeDL, results);
//         break;
//       default:
//         break;
//     }
//     return CustomPaint(
//       painter: painter,
//     );
//   }

//   CustomPaint _buildResultsPP(Size imageSize, dynamic results) {
//     CustomPainter painter;

//     switch (_currentDetector) {
//       case Detector.barcode:
//         painter = BarcodeDetectorPainter(_imageSizePP, results);
//         break;
//       case Detector.face:
//         painter = FaceDetectorPainter(_imageSizePP, results);
//         break;
//       case Detector.label:
//         painter = LabelDetectorPainter(_imageSizePP, results);
//         break;
//       case Detector.cloudLabel:
//         painter = LabelDetectorPainter(_imageSizePP, results);
//         break;
//       case Detector.text:
//         painter = TextDetectorPainter(_imageSizePP, results);
//         break;
//       case Detector.cloudText:
//         painter = TextDetectorPainter(_imageSizePP, results);
//         break;
//       case Detector.cloudDocumentText:
//         painter = DocumentTextDetectorPainter(_imageSizePP, results);
//         break;
//       default:
//         break;
//     }
//     return CustomPaint(
//       painter: painter,
//     );
//   }

//   nextPageID() {
//     if (firstNameEngIDController.text == '' ||
//         lastNameEngIDController.text == '') {
//       showFillUpAlertDialog(context);
//       return;
//     } else {
//       person = new Person();
//       person.firstnameEng = firstNameEngIDController.text;
//       person.lastnameEng = lastNameEngIDController.text;
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (BuildContext context) =>
//                   RegisterSecondPage(person: person)));
//     }
//   }

//   nextPageDL() {
//     if (firstNameEngDLController.text == '' ||
//         lastNameEngDLController.text == '') {
//       showFillUpAlertDialog(context);
//       return;
//     } else {
//       person = new Person();
//       person.firstnameEng = firstNameEngDLController.text;
//       person.lastnameEng = lastNameEngDLController.text;
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (BuildContext context) =>
//                   RegisterSecondPage(person: person)));
//     }
//   }

//   nextPagePP() {
//     if (firstNameEngPPController.text == '' ||
//         lastNameEngPPController.text == '') {
//       showFillUpAlertDialog(context);
//       return;
//     } else {
//       person = new Person();
//       person.firstnameEng = firstNameEngPPController.text;
//       person.lastnameEng = lastNameEngPPController.text;
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (BuildContext context) =>
//                   RegisterSecondPage(person: person)));
//     }
//   }

//   Widget _buildImageID() {
//     return Container(
//       constraints: const BoxConstraints.expand(),
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: Image.file(_imageFileID).image,
//           fit: BoxFit.fill,
//         ),
//       ),
//       child: _imageSizeID == null || _scanResultsID == null
//           ? const Center(
//               child: Text(
//                 'Scanning...',
//                 style: TextStyle(
//                   color: Colors.green,
//                   fontSize: 30.0,
//                 ),
//               ),
//             )
//           : _buildResultsID(_imageSizeID, _scanResultsID),
//     );
//   }

//   Widget _buildImageDL() {
//     return Container(
//       constraints: const BoxConstraints.expand(),
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: Image.file(_imageFileDL).image,
//           fit: BoxFit.fill,
//         ),
//       ),
//       child: _imageSizeDL == null || _scanResultsDL == null
//           ? const Center(
//               child: Text(
//                 'Scanning...',
//                 style: TextStyle(
//                   color: Colors.green,
//                   fontSize: 30.0,
//                 ),
//               ),
//             )
//           : _buildResultsDL(_imageSizeDL, _scanResultsDL),
//     );
//   }

//   Widget _buildImagePP() {
//     return Container(
//       constraints: const BoxConstraints.expand(),
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: Image.file(_imageFilePP).image,
//           fit: BoxFit.fill,
//         ),
//       ),
//       child: _imageSizePP == null || _scanResultsPP == null
//           ? const Center(
//               child: Text(
//                 'Scanning...',
//                 style: TextStyle(
//                   color: Colors.green,
//                   fontSize: 30.0,
//                 ),
//               ),
//             )
//           : _buildResultsPP(_imageSizePP, _scanResultsPP),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//         length: 3,
//         child: Scaffold(
//             appBar: AppBar(
//               bottom: TabBar(
//                 controller: _tabController,
//                 tabs: tabs,
//               ),
//               title: Text('Register 1/2'),
//             ),
//             body: TabBarView(controller: _tabController, children: [
//               buildIDForm(),
//               buildDLForm(),
//               buildPassportForm()
//             ])));
//   }

//   Widget buildIDForm() {
//     return Container(
//       child: ListView(
//         children: <Widget>[
//           Container(
//             width: MediaQuery.of(context).size.width,
//             padding: EdgeInsets.only(top: 30),
//             child: Column(
//               children: <Widget>[
//                 Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(50)),
//                       color: Colors.red[50],
//                     ),
//                     width: MediaQuery.of(context).size.width / 1.2,
//                     height: 55,
//                     child: ListView(children: <Widget>[
//                       new Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             FlatButton(
//                               splashColor: Colors.transparent,
//                               highlightColor: Colors.transparent,
//                               onPressed: () => {},
//                               child: Column(
//                                 children: <Widget>[
//                                   Text("Scan from",
//                                       style: TextStyle(
//                                           fontSize: 18, color: Colors.red))
//                                 ],
//                               ),
//                             ),
//                             FlatButton(
//                               onPressed: () => {_getAndScanImageID('camera')},
//                               padding: EdgeInsets.only(top: 8),
//                               child: Column(
//                                 children: <Widget>[
//                                   Icon(Icons.camera_alt, color: Colors.red),
//                                   Text("Camera",
//                                       style: TextStyle(color: Colors.red))
//                                 ],
//                               ),
//                             ),
//                             FlatButton(
//                               highlightColor: Colors.blue[200],
//                               onPressed: () => {_getAndScanImageID('gallery')},
//                               padding: EdgeInsets.only(top: 8),
//                               child: Column(
//                                 // Replace with a Row for horizontal icon + text
//                                 children: <Widget>[
//                                   Icon(Icons.photo, color: Colors.red),
//                                   Text("Gallery",
//                                       style: TextStyle(color: Colors.red))
//                                 ],
//                               ),
//                             )
//                           ]),
//                     ])),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 1.2,
//                   height: 55,
//                   padding:
//                       EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(50)),
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(color: Colors.black12, blurRadius: 5)
//                       ]),
//                   child: TextField(
//                     controller: idNoIDController,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'Identification No.',
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                     width: MediaQuery.of(context).size.width / 1.2,
//                     height: 55,
//                     child: ListView(
//                         physics: const NeverScrollableScrollPhysics(),
//                         children: <Widget>[
//                           new Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Container(
//                                   width:
//                                       MediaQuery.of(context).size.width / 2.5,
//                                   height: 55,
//                                   padding: EdgeInsets.only(
//                                       top: 4, left: 16, right: 16, bottom: 4),
//                                   decoration: BoxDecoration(
//                                       borderRadius:
//                                           BorderRadius.all(Radius.circular(50)),
//                                       color: Colors.white,
//                                       boxShadow: [
//                                         BoxShadow(
//                                             color: Colors.black12,
//                                             blurRadius: 5)
//                                       ]),
//                                   child: TextField(
//                                     controller: firstNameThIDController,
//                                     decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       hintText: 'First Name (th)',
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   width:
//                                       MediaQuery.of(context).size.width / 2.5,
//                                   height: 55,
//                                   padding: EdgeInsets.only(
//                                       top: 4, left: 16, right: 16, bottom: 4),
//                                   decoration: BoxDecoration(
//                                       borderRadius:
//                                           BorderRadius.all(Radius.circular(50)),
//                                       color: Colors.white,
//                                       boxShadow: [
//                                         BoxShadow(
//                                             color: Colors.black12,
//                                             blurRadius: 5)
//                                       ]),
//                                   child: TextField(
//                                     controller: lastNameThIDController,
//                                     decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       hintText: 'Last Name (th)',
//                                     ),
//                                   ),
//                                 ),
//                               ]),
//                         ])),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                     width: MediaQuery.of(context).size.width / 1.2,
//                     height: 55,
//                     child: ListView(
//                         physics: const NeverScrollableScrollPhysics(),
//                         children: <Widget>[
//                           new Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Container(
//                                   width:
//                                       MediaQuery.of(context).size.width / 2.5,
//                                   height: 55,
//                                   padding: EdgeInsets.only(
//                                       top: 4, left: 16, right: 16, bottom: 4),
//                                   decoration: BoxDecoration(
//                                       borderRadius:
//                                           BorderRadius.all(Radius.circular(50)),
//                                       color: Colors.white,
//                                       boxShadow: [
//                                         BoxShadow(
//                                             color: Colors.black12,
//                                             blurRadius: 5)
//                                       ]),
//                                   child: TextField(
//                                     controller: firstNameEngIDController,
//                                     decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       hintText: 'First Name (eng)',
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   width:
//                                       MediaQuery.of(context).size.width / 2.5,
//                                   height: 55,
//                                   padding: EdgeInsets.only(
//                                       top: 4, left: 16, right: 16, bottom: 4),
//                                   decoration: BoxDecoration(
//                                       borderRadius:
//                                           BorderRadius.all(Radius.circular(50)),
//                                       color: Colors.white,
//                                       boxShadow: [
//                                         BoxShadow(
//                                             color: Colors.black12,
//                                             blurRadius: 5)
//                                       ]),
//                                   child: TextField(
//                                     controller: lastNameEngIDController,
//                                     decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       hintText: 'Last Name (eng)',
//                                     ),
//                                   ),
//                                 ),
//                               ]),
//                         ])),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 InkWell(
//                   child: Container(
//                     width: MediaQuery.of(context).size.width / 1.2,
//                     height: 55,
//                     padding:
//                         EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(50)),
//                         color: Colors.white,
//                         boxShadow: [
//                           BoxShadow(color: Colors.black12, blurRadius: 5)
//                         ]),
//                     child: TextField(
//                       enabled: false,
//                       controller: dateOfBirthIDController,
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         hintText: 'Date of Birth',
//                         hintStyle: TextStyle(color: Colors.grey[600]),
//                       ),
//                     ),
//                   ),
//                   onTap: () {
//                     _selectDateID(context);
//                   },
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 1.2,
//                   height: 55,
//                   padding:
//                       EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(50)),
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(color: Colors.black12, blurRadius: 5)
//                       ]),
//                   child: TextField(
//                     controller: addressIDController,
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'Address',
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 1.2,
//                   height: 55,
//                   padding:
//                       EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(50)),
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(color: Colors.black12, blurRadius: 5)
//                       ]),
//                   child: TextField(
//                     controller: religionIDController,
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'Religion',
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     _imageSizeID == null || _scanResultsID == null
//                         ? DoNothingAction()
//                         : Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (BuildContext context) =>
//                                     PreviewPicturePage(
//                                         pictureWidget: _buildImageID(),
//                                         pickedImage: _pickedImageID,
//                                         resultsText: _scanResultsID.text)));
//                   },
//                   child: Container(
//                     height: 50,
//                     width: MediaQuery.of(context).size.width / 1.2,
//                     decoration: BoxDecoration(
//                         gradient: _imageSizeID == null || _scanResultsID == null
//                             ? LinearGradient(
//                                 colors: [
//                                   Colors.grey[400],
//                                   Colors.grey[400],
//                                 ],
//                               )
//                             : LinearGradient(
//                                 colors: [
//                                   Colors.red[300],
//                                   Colors.red[500],
//                                 ],
//                               ),
//                         borderRadius: BorderRadius.all(Radius.circular(50))),
//                     child: Center(
//                       child: Text(
//                         'Picture Preview',
//                         style: TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Container(
//                     width: MediaQuery.of(context).size.width / 1.2,
//                     height: 55,
//                     child: ListView(
//                         physics: const NeverScrollableScrollPhysics(),
//                         children: <Widget>[
//                           new Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     // Navigator.pop(context);
//                                     Navigator.popUntil(
//                                         context, (route) => route.isFirst);
//                                     // Navigator.pushNamed(context, '/login');
//                                   },
//                                   child: Container(
//                                     height: 50,
//                                     width:
//                                         MediaQuery.of(context).size.width / 2.5,
//                                     decoration: BoxDecoration(
//                                         gradient: LinearGradient(
//                                           colors: [
//                                             Colors.red[300],
//                                             Colors.red[500],
//                                           ],
//                                         ),
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(50))),
//                                     child: Center(
//                                       child: Text(
//                                         'Cancel',
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     nextPageID();
//                                   },
//                                   child: Container(
//                                     height: 50,
//                                     width:
//                                         MediaQuery.of(context).size.width / 2.5,
//                                     decoration: BoxDecoration(
//                                         gradient: LinearGradient(
//                                           colors: [
//                                             // Color(0xff6bceff),
//                                             // Color(0xFF00abff),
//                                             Colors.red[300],
//                                             Colors.red[500],
//                                           ],
//                                         ),
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(50))),
//                                     child: Center(
//                                       child: Text(
//                                         'Next',
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ]),
//                         ])),
//                 SizedBox(
//                   height: 10,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildDLForm() {
//     return Container(
//       child: ListView(
//         children: <Widget>[
//           Container(
//             width: MediaQuery.of(context).size.width,
//             padding: EdgeInsets.only(top: 30),
//             child: Column(
//               children: <Widget>[
//                 Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(50)),
//                       color: Colors.red[50],
//                     ),
//                     width: MediaQuery.of(context).size.width / 1.2,
//                     height: 55,
//                     child: ListView(children: <Widget>[
//                       new Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             FlatButton(
//                               splashColor: Colors.transparent,
//                               highlightColor: Colors.transparent,
//                               onPressed: () => {},
//                               child: Column(
//                                 children: <Widget>[
//                                   Text("Scan from",
//                                       style: TextStyle(
//                                           fontSize: 18, color: Colors.red))
//                                 ],
//                               ),
//                             ),
//                             FlatButton(
//                               onPressed: () => {_getAndScanImageDL('camera')},
//                               padding: EdgeInsets.only(top: 8),
//                               child: Column(
//                                 children: <Widget>[
//                                   Icon(Icons.camera_alt, color: Colors.red),
//                                   Text("Camera",
//                                       style: TextStyle(color: Colors.red))
//                                 ],
//                               ),
//                             ),
//                             FlatButton(
//                               highlightColor: Colors.blue[200],
//                               onPressed: () => {_getAndScanImageDL('gallery')},
//                               padding: EdgeInsets.only(top: 8),
//                               child: Column(
//                                 // Replace with a Row for horizontal icon + text
//                                 children: <Widget>[
//                                   Icon(Icons.photo, color: Colors.red),
//                                   Text("Gallery",
//                                       style: TextStyle(color: Colors.red))
//                                 ],
//                               ),
//                             )
//                           ]),
//                     ])),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 1.2,
//                   height: 55,
//                   padding:
//                       EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(50)),
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(color: Colors.black12, blurRadius: 5)
//                       ]),
//                   child: TextField(
//                     controller: noDLController,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'No.',
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 1.2,
//                   height: 55,
//                   padding:
//                       EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(50)),
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(color: Colors.black12, blurRadius: 5)
//                       ]),
//                   child: TextField(
//                     controller: typeDLController,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'Type',
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                     width: MediaQuery.of(context).size.width / 1.2,
//                     height: 55,
//                     child: ListView(
//                         physics: const NeverScrollableScrollPhysics(),
//                         children: <Widget>[
//                           new Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Container(
//                                   width:
//                                       MediaQuery.of(context).size.width / 2.5,
//                                   height: 55,
//                                   padding: EdgeInsets.only(
//                                       top: 4, left: 16, right: 16, bottom: 4),
//                                   decoration: BoxDecoration(
//                                       borderRadius:
//                                           BorderRadius.all(Radius.circular(50)),
//                                       color: Colors.white,
//                                       boxShadow: [
//                                         BoxShadow(
//                                             color: Colors.black12,
//                                             blurRadius: 5)
//                                       ]),
//                                   child: TextField(
//                                     controller: firstNameThDLController,
//                                     decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       hintText: 'First Name (th)',
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   width:
//                                       MediaQuery.of(context).size.width / 2.5,
//                                   height: 55,
//                                   padding: EdgeInsets.only(
//                                       top: 4, left: 16, right: 16, bottom: 4),
//                                   decoration: BoxDecoration(
//                                       borderRadius:
//                                           BorderRadius.all(Radius.circular(50)),
//                                       color: Colors.white,
//                                       boxShadow: [
//                                         BoxShadow(
//                                             color: Colors.black12,
//                                             blurRadius: 5)
//                                       ]),
//                                   child: TextField(
//                                     controller: lastNameThDLController,
//                                     decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       hintText: 'Last Name (th)',
//                                     ),
//                                   ),
//                                 ),
//                               ]),
//                         ])),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                     width: MediaQuery.of(context).size.width / 1.2,
//                     height: 55,
//                     child: ListView(
//                         physics: const NeverScrollableScrollPhysics(),
//                         children: <Widget>[
//                           new Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Container(
//                                   width:
//                                       MediaQuery.of(context).size.width / 2.5,
//                                   height: 55,
//                                   padding: EdgeInsets.only(
//                                       top: 4, left: 16, right: 16, bottom: 4),
//                                   decoration: BoxDecoration(
//                                       borderRadius:
//                                           BorderRadius.all(Radius.circular(50)),
//                                       color: Colors.white,
//                                       boxShadow: [
//                                         BoxShadow(
//                                             color: Colors.black12,
//                                             blurRadius: 5)
//                                       ]),
//                                   child: TextField(
//                                     controller: firstNameEngDLController,
//                                     decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       hintText: 'First Name (eng)',
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   width:
//                                       MediaQuery.of(context).size.width / 2.5,
//                                   height: 55,
//                                   padding: EdgeInsets.only(
//                                       top: 4, left: 16, right: 16, bottom: 4),
//                                   decoration: BoxDecoration(
//                                       borderRadius:
//                                           BorderRadius.all(Radius.circular(50)),
//                                       color: Colors.white,
//                                       boxShadow: [
//                                         BoxShadow(
//                                             color: Colors.black12,
//                                             blurRadius: 5)
//                                       ]),
//                                   child: TextField(
//                                     controller: lastNameEngDLController,
//                                     decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       hintText: 'Last Name (eng)',
//                                     ),
//                                   ),
//                                 ),
//                               ]),
//                         ])),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 1.2,
//                   height: 55,
//                   padding:
//                       EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(50)),
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(color: Colors.black12, blurRadius: 5)
//                       ]),
//                   child: TextField(
//                     controller: idNoDLController,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'Identification No.',
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 InkWell(
//                   child: Container(
//                     width: MediaQuery.of(context).size.width / 1.2,
//                     height: 55,
//                     padding:
//                         EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(50)),
//                         color: Colors.white,
//                         boxShadow: [
//                           BoxShadow(color: Colors.black12, blurRadius: 5)
//                         ]),
//                     child: TextField(
//                       enabled: false,
//                       controller: dateOfBirthDLController,
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         hintText: 'Date of Birth',
//                         hintStyle: TextStyle(color: Colors.grey[600]),
//                       ),
//                     ),
//                   ),
//                   onTap: () {
//                     _selectDateDL(context);
//                   },
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     _imageSizeDL == null || _scanResultsDL == null
//                         ? DoNothingAction()
//                         : Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (BuildContext context) =>
//                                     PreviewPicturePage(
//                                         pictureWidget: _buildImageDL(),
//                                         pickedImage: _pickedImageDL,
//                                         resultsText: _scanResultsDL.text)));
//                   },
//                   child: Container(
//                     height: 50,
//                     width: MediaQuery.of(context).size.width / 1.2,
//                     decoration: BoxDecoration(
//                         gradient: _imageSizeDL == null || _scanResultsDL == null
//                             ? LinearGradient(
//                                 colors: [
//                                   Colors.grey[400],
//                                   Colors.grey[400],
//                                 ],
//                               )
//                             : LinearGradient(
//                                 colors: [
//                                   Colors.red[300],
//                                   Colors.red[500],
//                                 ],
//                               ),
//                         borderRadius: BorderRadius.all(Radius.circular(50))),
//                     child: Center(
//                       child: Text(
//                         'Picture Preview',
//                         style: TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Container(
//                     width: MediaQuery.of(context).size.width / 1.2,
//                     height: 55,
//                     child: ListView(
//                         physics: const NeverScrollableScrollPhysics(),
//                         children: <Widget>[
//                           new Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     Navigator.pop(context);
//                                   },
//                                   child: Container(
//                                     height: 50,
//                                     width:
//                                         MediaQuery.of(context).size.width / 2.5,
//                                     decoration: BoxDecoration(
//                                         gradient: LinearGradient(
//                                           colors: [
//                                             Colors.red[300],
//                                             Colors.red[500],
//                                           ],
//                                         ),
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(50))),
//                                     child: Center(
//                                       child: Text(
//                                         'Cancel',
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     nextPageDL();
//                                   },
//                                   child: Container(
//                                     height: 50,
//                                     width:
//                                         MediaQuery.of(context).size.width / 2.5,
//                                     decoration: BoxDecoration(
//                                         gradient: LinearGradient(
//                                           colors: [
//                                             Colors.red[300],
//                                             Colors.red[500],
//                                           ],
//                                         ),
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(50))),
//                                     child: Center(
//                                       child: Text(
//                                         'Next',
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ]),
//                         ])),
//                 SizedBox(
//                   height: 10,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildPassportForm() {
//     return Container(
//       child: ListView(
//         children: <Widget>[
//           Container(
//             width: MediaQuery.of(context).size.width,
//             padding: EdgeInsets.only(top: 30),
//             child: Column(
//               children: <Widget>[
//                 Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(50)),
//                       color: Colors.red[50],
//                     ),
//                     width: MediaQuery.of(context).size.width / 1.2,
//                     height: 55,
//                     child: ListView(children: <Widget>[
//                       new Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             FlatButton(
//                               splashColor: Colors.transparent,
//                               highlightColor: Colors.transparent,
//                               onPressed: () => {},
//                               child: Column(
//                                 children: <Widget>[
//                                   Text("Scan from",
//                                       style: TextStyle(
//                                           fontSize: 18, color: Colors.red))
//                                 ],
//                               ),
//                             ),
//                             FlatButton(
//                               onPressed: () => {_getAndScanImagePP('camera')},
//                               padding: EdgeInsets.only(top: 8),
//                               child: Column(
//                                 children: <Widget>[
//                                   Icon(Icons.camera_alt, color: Colors.red),
//                                   Text("Camera",
//                                       style: TextStyle(color: Colors.red))
//                                 ],
//                               ),
//                             ),
//                             FlatButton(
//                               highlightColor: Colors.blue[200],
//                               onPressed: () => {_getAndScanImagePP('gallery')},
//                               padding: EdgeInsets.only(top: 8),
//                               child: Column(
//                                 // Replace with a Row for horizontal icon + text
//                                 children: <Widget>[
//                                   Icon(Icons.photo, color: Colors.red),
//                                   Text("Gallery",
//                                       style: TextStyle(color: Colors.red))
//                                 ],
//                               ),
//                             )
//                           ]),
//                     ])),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 1.2,
//                   height: 55,
//                   padding:
//                       EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(50)),
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(color: Colors.black12, blurRadius: 5)
//                       ]),
//                   child: TextField(
//                     controller: passportNoPPController,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'Passport No.',
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 1.2,
//                   height: 55,
//                   padding:
//                       EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(50)),
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(color: Colors.black12, blurRadius: 5)
//                       ]),
//                   child: TextField(
//                     controller: nationalityPPController,
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'Nationality',
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                     width: MediaQuery.of(context).size.width / 1.2,
//                     height: 55,
//                     child: ListView(
//                         physics: const NeverScrollableScrollPhysics(),
//                         children: <Widget>[
//                           new Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Container(
//                                   width:
//                                       MediaQuery.of(context).size.width / 2.5,
//                                   height: 55,
//                                   padding: EdgeInsets.only(
//                                       top: 4, left: 16, right: 16, bottom: 4),
//                                   decoration: BoxDecoration(
//                                       borderRadius:
//                                           BorderRadius.all(Radius.circular(50)),
//                                       color: Colors.white,
//                                       boxShadow: [
//                                         BoxShadow(
//                                             color: Colors.black12,
//                                             blurRadius: 5)
//                                       ]),
//                                   child: TextField(
//                                     controller: firstNameThPPController,
//                                     decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       hintText: 'First Name (th)',
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   width:
//                                       MediaQuery.of(context).size.width / 2.5,
//                                   height: 55,
//                                   padding: EdgeInsets.only(
//                                       top: 4, left: 16, right: 16, bottom: 4),
//                                   decoration: BoxDecoration(
//                                       borderRadius:
//                                           BorderRadius.all(Radius.circular(50)),
//                                       color: Colors.white,
//                                       boxShadow: [
//                                         BoxShadow(
//                                             color: Colors.black12,
//                                             blurRadius: 5)
//                                       ]),
//                                   child: TextField(
//                                     controller: lastNameThPPController,
//                                     decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       hintText: 'Last Name (th)',
//                                     ),
//                                   ),
//                                 ),
//                               ]),
//                         ])),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                     width: MediaQuery.of(context).size.width / 1.2,
//                     height: 55,
//                     child: ListView(
//                         physics: const NeverScrollableScrollPhysics(),
//                         children: <Widget>[
//                           new Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Container(
//                                   width:
//                                       MediaQuery.of(context).size.width / 2.5,
//                                   height: 55,
//                                   padding: EdgeInsets.only(
//                                       top: 4, left: 16, right: 16, bottom: 4),
//                                   decoration: BoxDecoration(
//                                       borderRadius:
//                                           BorderRadius.all(Radius.circular(50)),
//                                       color: Colors.white,
//                                       boxShadow: [
//                                         BoxShadow(
//                                             color: Colors.black12,
//                                             blurRadius: 5)
//                                       ]),
//                                   child: TextField(
//                                     controller: firstNameEngPPController,
//                                     decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       hintText: 'First Name (eng)',
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   width:
//                                       MediaQuery.of(context).size.width / 2.5,
//                                   height: 55,
//                                   padding: EdgeInsets.only(
//                                       top: 4, left: 16, right: 16, bottom: 4),
//                                   decoration: BoxDecoration(
//                                       borderRadius:
//                                           BorderRadius.all(Radius.circular(50)),
//                                       color: Colors.white,
//                                       boxShadow: [
//                                         BoxShadow(
//                                             color: Colors.black12,
//                                             blurRadius: 5)
//                                       ]),
//                                   child: TextField(
//                                     controller: lastNameEngPPController,
//                                     decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       hintText: 'Last Name (eng)',
//                                     ),
//                                   ),
//                                 ),
//                               ]),
//                         ])),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 1.2,
//                   height: 55,
//                   padding:
//                       EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(50)),
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(color: Colors.black12, blurRadius: 5)
//                       ]),
//                   child: TextField(
//                     controller: personalNoPPController,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'Personal No.',
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 InkWell(
//                   child: Container(
//                     width: MediaQuery.of(context).size.width / 1.2,
//                     height: 55,
//                     padding:
//                         EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(50)),
//                         color: Colors.white,
//                         boxShadow: [
//                           BoxShadow(color: Colors.black12, blurRadius: 5)
//                         ]),
//                     child: TextField(
//                       enabled: false,
//                       controller: dateOfBirthPPController,
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         hintText: 'Date of Birth',
//                         hintStyle: TextStyle(color: Colors.grey[600]),
//                       ),
//                     ),
//                   ),
//                   onTap: () {
//                     _selectDatePP(context);
//                   },
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     _imageSizeDL == null || _scanResultsDL == null
//                         ? DoNothingAction()
//                         : Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (BuildContext context) =>
//                                     PreviewPicturePage(
//                                         pictureWidget: _buildImagePP(),
//                                         pickedImage: _pickedImagePP,
//                                         resultsText: _scanResultsPP.text)));
//                   },
//                   child: Container(
//                     height: 50,
//                     width: MediaQuery.of(context).size.width / 1.2,
//                     decoration: BoxDecoration(
//                         gradient: _imageSizePP == null || _scanResultsPP == null
//                             ? LinearGradient(
//                                 colors: [
//                                   Colors.grey[400],
//                                   Colors.grey[400],
//                                 ],
//                               )
//                             : LinearGradient(
//                                 colors: [
//                                   Colors.red[300],
//                                   Colors.red[500],
//                                 ],
//                               ),
//                         borderRadius: BorderRadius.all(Radius.circular(50))),
//                     child: Center(
//                       child: Text(
//                         'Picture Preview',
//                         style: TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Container(
//                     width: MediaQuery.of(context).size.width / 1.2,
//                     height: 55,
//                     child: ListView(
//                         physics: const NeverScrollableScrollPhysics(),
//                         children: <Widget>[
//                           new Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     Navigator.pop(context);
//                                   },
//                                   child: Container(
//                                     height: 50,
//                                     width:
//                                         MediaQuery.of(context).size.width / 2.5,
//                                     decoration: BoxDecoration(
//                                         gradient: LinearGradient(
//                                           colors: [
//                                             Colors.red[300],
//                                             Colors.red[500],
//                                           ],
//                                         ),
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(50))),
//                                     child: Center(
//                                       child: Text(
//                                         'Cancel',
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     nextPagePP();
//                                   },
//                                   child: Container(
//                                     height: 50,
//                                     width:
//                                         MediaQuery.of(context).size.width / 2.5,
//                                     decoration: BoxDecoration(
//                                         gradient: LinearGradient(
//                                           colors: [
//                                             Colors.red[300],
//                                             Colors.red[500],
//                                           ],
//                                         ),
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(50))),
//                                     child: Center(
//                                       child: Text(
//                                         'Next',
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ]),
//                         ])),
//                 SizedBox(
//                   height: 10,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   showFillUpAlertDialog(BuildContext context) {
//     Widget okButton = FlatButton(
//       child: Text("ตกลง",
//           style: TextStyle(
//             color: Colors.red,
//           )),
//       onPressed: () {
//         Navigator.pop(context);
//       },
//     );

//     AlertDialog alert = AlertDialog(
//       title: Text("ข้อความ",
//           style: TextStyle(
//             color: Colors.red,
//             fontSize: 30.0,
//           )),
//       content: Text("กรุณากรอกข้อมูลให้ครบ"),
//       actions: [
//         okButton,
//       ],
//     );

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }

//   showRetryIDAlertDialog(BuildContext context) {
//     Widget retryButton = FlatButton(
//       // child: RichText(
//       //   text: TextSpan(
//       //     children: [
//       //       // TextSpan(
//       //       //   text: "Click ",
//       //       // ),
//       //       WidgetSpan(
//       //         child: Icon(Icons.add, size: 14),
//       //       ),
//       //       TextSpan(
//       //         text: "ลองอีกครั้ง",
//       //       ),
//       //     ],
//       //   ),
//       // ),
//       child: Text("ลองอีกครั้ง",
//           style: TextStyle(
//             color: Colors.blue,
//             fontWeight: FontWeight.bold,
//           )),
//       onPressed: () {
//         Navigator.pop(context);
//         _getAndScanImageID('retry');
//       },
//     );
//     Widget cancelButton = FlatButton(
//       child: Text("ยกเลิก",
//           style: TextStyle(
//             color: Colors.red,
//           )),
//       onPressed: () {
//         Navigator.pop(context);
//       },
//     );

//     AlertDialog alert = AlertDialog(
//       title: Text("ข้อความ",
//           style: TextStyle(
//             color: Colors.red,
//             fontSize: 30.0,
//           )),
//       content: Text("ไม่สามารถอ่านบัตรประจำตัวประชาชนได้กรุณาลองใหม่อีกครั้ง"),
//       actions: [
//         cancelButton,
//         retryButton,
//       ],
//     );

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }

//   showRetryDLAlertDialog(BuildContext context) {
//     Widget retryButton = FlatButton(
//       child: Text("ลองอีกครั้ง",
//           style: TextStyle(
//             color: Colors.blue,
//             fontWeight: FontWeight.bold,
//           )),
//       onPressed: () {
//         Navigator.pop(context);
//         _getAndScanImageDL('retry');
//       },
//     );
//     Widget cancelButton = FlatButton(
//       child: Text("ยกเลิก",
//           style: TextStyle(
//             color: Colors.red,
//           )),
//       onPressed: () {
//         Navigator.pop(context);
//       },
//     );

//     AlertDialog alert = AlertDialog(
//       title: Text("ข้อความ",
//           style: TextStyle(
//             color: Colors.red,
//             fontSize: 30.0,
//           )),
//       content: Text("ไม่สามารถอ่านใบขับขี่ได้กรุณาลองใหม่อีกครั้ง"),
//       actions: [
//         cancelButton,
//         retryButton,
//       ],
//     );

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }

//   showRetryPPAlertDialog(BuildContext context) {
//     Widget retryButton = FlatButton(
//       child: Text("ลองอีกครั้ง",
//           style: TextStyle(
//             color: Colors.blue,
//             fontWeight: FontWeight.bold,
//           )),
//       onPressed: () {
//         Navigator.pop(context);
//         _getAndScanImagePP('retry');
//       },
//     );
//     Widget cancelButton = FlatButton(
//       child: Text("ยกเลิก",
//           style: TextStyle(
//             color: Colors.red,
//           )),
//       onPressed: () {
//         Navigator.pop(context);
//       },
//     );

//     AlertDialog alert = AlertDialog(
//       title: Text("ข้อความ",
//           style: TextStyle(
//             color: Colors.red,
//             fontSize: 30.0,
//           )),
//       content: Text("ไม่สามารถอ่านพาสปอร์ตได้กรุณาลองใหม่อีกครั้ง"),
//       actions: [
//         cancelButton,
//         retryButton,
//       ],
//     );

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }

//   // void pickDate() {}

//   _selectDateID(BuildContext context) async {
//     DateTime lastDate = DateTime.now();
//     final DateTime picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate, // Refer step 1
//       firstDate: DateTime(1900),
//       lastDate: DateTime(int.parse(lastDate.year.toString()) + 1),
//     );

//     // const Map<int, String> monthsInYear = {
//     //   1: "January",
//     //   2: "February",
//     //   3: "March",
//     //   4: "April",
//     //   5: "May",
//     //   6: "June",
//     //   7: "July",
//     //   8: "August",
//     //   9: "September",
//     //   10: "October",
//     //   11: "November",
//     //   12: "December"
//     // };

//     String datePicker = picked.day.toString() +
//         " " +
//         monthsInYear[int.parse(picked.month.toString())] +
//         " " +
//         picked.year.toString();

//     // person.dateOfBirth = datePicker;
//     // dateOfBirthIDController.text = datePicker;

//     log("pick date: " + datePicker);
//     if (picked != null && picked != selectedDate)
//       setState(() {
//         selectedDate = picked;
//         dateOfBirthIDController.text = datePicker;
//         log("setState");
//       });
//   }

//   _selectDateDL(BuildContext context) async {
//     DateTime lastDate = DateTime.now();
//     final DateTime picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate, // Refer step 1
//       firstDate: DateTime(1900),
//       lastDate: DateTime(int.parse(lastDate.year.toString()) + 1),
//     );

//     // const Map<int, String> monthsInYear = {
//     //   1: "January",
//     //   2: "February",
//     //   3: "March",
//     //   4: "April",
//     //   5: "May",
//     //   6: "June",
//     //   7: "July",
//     //   8: "August",
//     //   9: "September",
//     //   10: "October",
//     //   11: "November",
//     //   12: "December"
//     // };

//     String datePicker = picked.day.toString() +
//         " " +
//         monthsInYear[int.parse(picked.month.toString())] +
//         " " +
//         picked.year.toString();

//     // person.dateOfBirth = datePicker;
//     // dateOfBirthIDController.text = datePicker;

//     log(datePicker);
//     if (picked != null && picked != selectedDate)
//       setState(() {
//         selectedDate = picked;
//         dateOfBirthDLController.text = datePicker;
//         log("setState");
//       });
//   }

//   _selectDatePP(BuildContext context) async {
//     DateTime lastDate = DateTime.now();
//     final DateTime picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate, // Refer step 1
//       firstDate: DateTime(1900),
//       lastDate: DateTime(int.parse(lastDate.year.toString()) + 1),
//     );

//     // const Map<int, String> monthsInYear = {
//     //   1: "January",
//     //   2: "February",
//     //   3: "March",
//     //   4: "April",
//     //   5: "May",
//     //   6: "June",
//     //   7: "July",
//     //   8: "August",
//     //   9: "September",
//     //   10: "October",
//     //   11: "November",
//     //   12: "December"
//     // };

//     String datePicker = picked.day.toString() +
//         " " +
//         monthsInYear[int.parse(picked.month.toString())] +
//         " " +
//         picked.year.toString();

//     // person.dateOfBirth = datePicker;
//     // dateOfBirthIDController.text = datePicker;

//     log(datePicker);
//     if (picked != null && picked != selectedDate)
//       setState(() {
//         selectedDate = picked;
//         dateOfBirthPPController.text = datePicker;
//         log("setState");
//       });
//   }
// }
