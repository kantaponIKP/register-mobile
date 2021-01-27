// //Open Browser

// import 'dart:async';
// import 'dart:developer';

// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:register_demo/models/person.dart';
// import 'package:register_demo/services/registerService.dart';
// import 'package:uni_links/uni_links.dart';
// import 'package:url_launcher/url_launcher.dart';
// // import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

// class RegisterThirdPage extends StatefulWidget {
//   final String url;

//   const RegisterThirdPage({Key key, this.url}) : super(key: key);

//   @override
//   _RegisterThirdPageState createState() => _RegisterThirdPageState();
// }

// class _RegisterThirdPageState extends State<RegisterThirdPage> {
//   String _latestLink = 'Unknown';
//   Uri _latestUri;

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () {
//       initPlatformState();
//     });
//   }

//   TextEditingController usernameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   // var _response;
//   String registerStatus = '';
//   String queryParameter = 'register';
//   var _responseText;
//   Future<void> _launched;
//   static const String toLaunch = 'https://www.iknowplus.co.th/';

//   @override
//   void dispose() {
//     // _bloc.dispose();
//     super.dispose();
//   }

//   Future<void> _launchInBrowser(String url) async {
//     if (await canLaunch(url)) {
//       await launch(
//         url,
//         forceSafariVC: false,
//         forceWebView: false,
//         headers: <String, String>{'my_header_key': 'my_header_value'},
//       );
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
//     if (snapshot.hasError) {
//       return Text('Error: ${snapshot.error}');
//     } else {
//       return const Text('');
//     }
//   }

//   initPlatformState() async {
//     await initPlatformStateForUriUniLinks();
//   }

//   initPlatformStateForUriUniLinks() async {
//     getUriLinksStream().listen((Uri uri) {
//       print('RegisterThirdPage got uri: ${uri.toString()}');

//       print('RegisterThirdPage path = ${uri.path}');

//       registerStatus = uri.queryParameters[queryParameter];
//       log("registerStatus: " + uri.queryParameters[queryParameter]);

//       // if (uri.toString()!=null){
//       if (registerStatus == "success") {
//         showSuccessAlertDialog(context);
//         // Navigator.pushNamed(context, '/login');
//       } else {
//         showFailAlertDialog(context);
//       }
//     }, onError: (err) {
//       print('got err: $err');
//     });

//     // Get the latest Uri
//     Uri initialUri;
//     String initialLink;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       initialUri = await getInitialUri();
//       print('initial uri: ${initialUri?.path}'
//           ' ${initialUri?.queryParametersAll}');
//       initialLink = initialUri?.toString();
//     } on PlatformException {
//       initialUri = null;
//       initialLink = 'Failed to get initial uri.';
//     } on FormatException {
//       initialUri = null;
//       initialLink = 'Bad parse the initial link as Uri.';
//     }

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     //if (!mounted) return;

//     setState(() {
//       _latestUri = initialUri;
//       _latestLink = initialLink;
//     });

//     log("_latestUri: $_latestUri");
//     log("_latestLink: $_latestLink");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () {
//           return new Future(() => false);
//         },
//         child: Scaffold(
//           body: Container(
//             child: ListView(
//               children: <Widget>[
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: MediaQuery.of(context).size.height / 12,
//                   decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           // colors: [Color(0xff6bceff), Color(0xff6bceff)],
//                           // colors: [Color(0xff6bceff), Colors.lightBlue[400]],
//                           colors: [Colors.red[800], Colors.red[400]]),
//                       borderRadius:
//                           BorderRadius.only(bottomRight: Radius.circular(90))),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Align(
//                         alignment: Alignment.bottomLeft,
//                         child: Padding(
//                           padding: const EdgeInsets.only(bottom: 8, left: 36),
//                           child: Text(
//                             'FIDO Register',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   padding: EdgeInsets.only(top: 40),
//                   child: Column(
//                     children: <Widget>[
//                       Container(
//                         width: MediaQuery.of(context).size.width / 1.2,
//                         height: 100,
//                         padding: EdgeInsets.only(
//                             top: 4, left: 16, right: 16, bottom: 4),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.all(Radius.circular(20)),
//                             // color: Colors.white,
//                             color: Colors.grey[100],
//                             boxShadow: [
//                               BoxShadow(color: Colors.black12, blurRadius: 5)
//                             ]),
//                         child: TextField(
//                           enabled: false,
//                           keyboardType: TextInputType.multiline,
//                           maxLines: null,
//                           controller: usernameController,
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                             hintText:
//                                 'ขั้นตอนต่อไปทำการลงทะเบียน FIDO \nเพื่อเปิดการใช้งาน Passwordless\nโดยต้องทำการผ่าน Browser',
//                             hintStyle: TextStyle(color: Colors.grey[600]),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 35,
//                       ),
//                       InkWell(
//                         onTap: () {
//                           //do open browser
//                           _launchInBrowser(widget.url);
//                         },
//                         child: Container(
//                           height: 50,
//                           width: MediaQuery.of(context).size.width / 1.2,
//                           decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Color(0xff6bceff),
//                                   Color(0xFF00abff),
//                                 ],
//                               ),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(50))),
//                           child: Center(
//                             child: Text(
//                               // 'Sign Up'.toUpperCase(),
//                               'Open Browser',
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       InkWell(
//                         onTap: () {
//                           //route to login
//                           // Navigator.pushNamed(context, '/login');
//                           Navigator.popUntil(context, (route) => route.isFirst);
//                         },
//                         child: Container(
//                           height: 50,
//                           width: MediaQuery.of(context).size.width / 1.2,
//                           decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Colors.red[300],
//                                   Colors.red[500],
//                                 ],
//                               ),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(50))),
//                           child: Center(
//                             child: Text(
//                               // 'Sign Up'.toUpperCase(),
//                               'Cancel',
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }

//   // showSuccessAlertDialog(BuildContext context,{barrierDismissible: false}) {
//   //   return WillPopScope(
//   //     onWillPop: () {},
//   //     child: new AlertDialog(
//   //       title: new Text('ข้อความ'),
//   //       content: new Text('การลงทะเบียนสำเร็จ'),
//   //       actions: <Widget>[
//   //         new FlatButton(
//   //           onPressed: () {
//   //             // Navigator.pushNamed(context, '/login');
//   //           },
//   //           child: new Text('ตกลง'),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
//   showSuccessAlertDialog(BuildContext context) {
//     Widget okButton = FlatButton(
//       child: Text("ตกลง",
//           style: TextStyle(
//             color: Colors.red,
//             fontSize: 30.0,
//           )),
//       onPressed: () {
//         // Navigator.pushNamed(context, '/login');
//         Navigator.popUntil(context, (route) => route.isFirst);
//       },
//     );

//     AlertDialog alert = AlertDialog(
//       title: Text("ข้อความ",
//           style: TextStyle(
//             color: Colors.red,
//             fontSize: 30.0,
//           )),
//       content: Text("การลงทะเบียนสำเร็จ"),
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

//   showFailAlertDialog(BuildContext context) {
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
//       content: Text("การลงทะเบียนไม่สำเร็จ"),
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
