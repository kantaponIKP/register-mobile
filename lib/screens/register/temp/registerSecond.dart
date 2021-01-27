// //Username
// //Email

// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:register_demo/models/person.dart';
// import 'package:register_demo/models/responseData.dart';
// import 'package:register_demo/screens/register/temp/registerThird.dart';
// import 'package:register_demo/services/registerService.dart';

// class RegisterSecondPage extends StatefulWidget {
//   final Person person;

//   const RegisterSecondPage({Key key, this.person}) : super(key: key);

//   @override
//   _RegisterSecondPageState createState() => _RegisterSecondPageState();
// }

// class _RegisterSecondPageState extends State<RegisterSecondPage> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   ResponseData responseData;
//   String url = '';
//   String diglogText = '';
//   String _diglogText = '';
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   static const String toLaunch = 'https://www.iknowplus.co.th/';

//   registerKeycloak() async {
//     log("register");
//     var username = usernameController.text;
//     var email = emailController.text;
//     if (usernameController.text == '' || emailController.text == '') {
//       showFillUpAlertDialog(context);
//       return;
//     }

//     // Post API
//     final response =
//         await RegisterService.postRequest(username, email, widget.person);

//     log("---log---");
//     log("Status code: " + response.statusCode.toString());
//     log("body : " + response.body);

//     try {
//       responseData = ResponseData.fromJson(json.decode(response.body));

//       if (response.statusCode == 201) {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (BuildContext context) =>
//                     RegisterThirdPage(url: responseData.url)));
//         return;
//       } else if (response.statusCode == 409) {
//         if (responseData.error == "User already exists!") {
//           diglogText = 'Username ถูกใช้งานแล้ว กรุณากรอกใหม่อีกครั้ง';
//         } else if (responseData.error == "Email already exists!") {
//           diglogText = 'Email ถูกใช้งานแล้ว กรุณากรอกใหม่อีกครั้ง';
//         } else {
//           diglogText = 'การลงทะเบียนไม่สำเร็จ';
//         }
//       } else {
//         diglogText = 'การลงทะเบียนไม่สำเร็จ';
//       }
//     } catch (e) {
//       diglogText = 'การลงทะเบียนไม่สำเร็จ';
//     }

//     setState(() {
//       _diglogText = diglogText;
//     });

//     showResponseAlertDialog(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: ListView(
//           children: <Widget>[
//             Container(
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height / 12,
//               decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                       begin: Alignment.topCenter, end: Alignment.bottomCenter,
//                       // colors: [Color(0xff6bceff), Color(0xff6bceff)],
//                       // colors: [Color(0xff6bceff), Colors.lightBlue[400]],
//                       colors: [Colors.red[800], Colors.red[400]]),
//                   borderRadius:
//                       BorderRadius.only(bottomRight: Radius.circular(90))),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Align(
//                     alignment: Alignment.bottomLeft,
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 8, left: 36),
//                       child: Text(
//                         'Register 2/2',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // ------------------ Field -------------------------
//             Container(
//               // height: MediaQuery.of(context).size.height / 1,
//               width: MediaQuery.of(context).size.width,
//               padding: EdgeInsets.only(top: 40),
//               child: Column(
//                 children: <Widget>[
//                   Container(
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
//                       controller: usernameController,
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         hintText: 'Username',
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Container(
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
//                       controller: emailController,
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         hintText: 'Email',
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 35,
//                   ),
//                   Container(
//                       width: MediaQuery.of(context).size.width / 1.2,
//                       height: 55,
//                       child: ListView(
//                           physics: const NeverScrollableScrollPhysics(),
//                           children: <Widget>[
//                             new Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   InkWell(
//                                     onTap: () {
//                                       Navigator.pop(context);
//                                     },
//                                     child: Container(
//                                       height: 50,
//                                       width: MediaQuery.of(context).size.width /
//                                           2.5,
//                                       decoration: BoxDecoration(
//                                           gradient: LinearGradient(
//                                             colors: [
//                                               // Color(0xff6bceff),
//                                               // Color(0xFF00abff),
//                                               Colors.red[300],
//                                               Colors.red[500],
//                                             ],
//                                           ),
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(50))),
//                                       child: Center(
//                                         child: Text(
//                                           'Back',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   InkWell(
//                                     onTap: () {
//                                       registerKeycloak();
//                                       // Navigator.push(
//                                       //     context,
//                                       //     MaterialPageRoute(
//                                       //         builder: (BuildContext context) =>
//                                       //             RegisterThirdPage(
//                                       //                 url: url)));
//                                     },
//                                     child: Container(
//                                       height: 50,
//                                       width: MediaQuery.of(context).size.width /
//                                           2.5,
//                                       decoration: BoxDecoration(
//                                           gradient: LinearGradient(
//                                             colors: [
//                                               // Color(0xff6bceff),
//                                               // Color(0xFF00abff),
//                                               Colors.red[300],
//                                               Colors.red[500],
//                                             ],
//                                           ),
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(50))),
//                                       child: Center(
//                                         child: Text(
//                                           'Confirm',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ]),
//                           ])),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   showFillUpAlertDialog(BuildContext context) {
//     Widget okButton = FlatButton(
//       child: Text("ตกลง",
//           style: TextStyle(
//             color: Colors.red,
//             fontSize: 30.0,
//           )),
//       onPressed: () {
//         Navigator.pop(context);
//       },
//     );

//     AlertDialog alert = AlertDialog(
//       title: Text("ข้อความ"),
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

//   showResponseAlertDialog(BuildContext context) {
//     Widget okButton = FlatButton(
//       child: Text("ตกลง",
//           style: TextStyle(
//             color: Colors.red,
//             fontSize: 30.0,
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
//       content: Text(_diglogText),
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
// }
