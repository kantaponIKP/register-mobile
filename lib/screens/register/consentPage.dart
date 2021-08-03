import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:register_demo/models/user.dart';
import 'package:register_demo/services/loginService.dart';
import 'package:register_demo/services/registerStorage.dart';
import 'package:register_demo/services/userService.dart';

import '../home.dart';

// import 'dart:developer';
// import 'dart:io';

// import 'package:openid_client/openid_client.dart' as openid;
// import 'package:register_demo/screens/home.dart';

// import 'package:uni_links/uni_links.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:openid_client/openid_client_io.dart';
// import 'dart:math' as math;
const consentHeaderText =
    "หนังสือให้ความยินยอมในการเก็บข้อมูล ใช้เปิดเผยข้อมูลส่วนบุคคล";
const consentBodyText = "บริษัทได้รับข้อมูลส่วนบุคคลของผู้ลงทะเบียน และได้เก็บรวบรวมและประมวลผลตามหนังสือให้ความยินยอมการเก็บรวบรวม ประมวลผล ใช้ " +
    "และเปิดเผยข้อมูลส่วนบุคคลฉบับนี้โดยบริษัทได้จัดเก็บรวบรวมและประมวลผลข้อมูลส่วนบุคคลเท่าที่จําเป็นตามวัตถุประสงค์ในการเก็บรวบรวม ประมวลผล ใช้ และเปิดเผยข้อมูลส่วนบุคคลของบริษัท ทั้งนี้ ได้จําแนกประเภทของข้อมูลส่วนบุคคล ดังนี้" +
    "\n\n" +
    "การเก็บรวบรวมข้อมูล\n" +
    "1. ได้รับข้อมูลส่วนบุคคลโดยตรง\n" +
    " บริษัทได้รับข้อมูลส่วนบุคคลของผู้สมัครงานโดยตรง โดยเก็บรวบรวมข้อมูลส่วนบุคคล จากกระบวนการสรรหาและรับ" +
    "สมัครงาน หรือหนังสือให้ความยินยอม ทั้งนี้ ในบางกรณีบริษัทอาจจะได้รับข้อมูลจากบุคคลที่สามในกรณีอื่นด้วย\n" +
    " 2. ได้รับข้อมูลส่วนบุคคลของบุคคลอื่นโดยตรง\n" +
    " ข้อมูลส่วนบุคคลของบุคคลอื่นที่ผู้สมัครงานได้ให้ไว้กับบริษัท ซึ่งอาจจะให้ข้อมูลส่วนบุคคลที่เกี่ยวกับบุคคลอื่น ได้แก่" +
    "บุคคลติดต่อกรณีฉุกเฉิน ซึ่งบริษัทใช้ข้อมูลเหล่านั้นเพื่อการติดต่อในกรณีที่เกี่ยวกับการสมัครงานเท่านั้น\n" +
    " 3. บริษัทอาจรวบรวมข้อมูลส่วนบุคคลจากองค์กรอื่น\n" +
    " บริษัทอาจรวบรวมข้อมูลจากองค์กรอื่นเพื่อกระบวนการสรรหาและคัดเลือกพนักงาน ได้แก่ กรณีที่ผู้สมัครงานมีการ" +
    "สมัครงานผ่านตัวแทนรับจ้างจัดหางาน หรือเว็บไซต์หางาน เป็นต้น\n" +
    "4. บริษัทอาจจัดเก็บบันทึกข้อมูลการเข้าออกเว็บไซต์ (Log Files) ของท่าน โดยจะจัดเก็บข้อมูลดังนี้ หมายเลขไอพี (IP" +
    "Address) หรือ เวลาการเข้าใช้งาน เป็นต้น\n";

class ConsentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ConsentPageState();
  }
}

class _ConsentPageState extends State<ConsentPage> {
  LoginService loginService;
  UserService userService;
  User user;

  StreamSubscription userSubscription;
  RegisterStorage registerStorage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Additional disposal code
    super.dispose();

    userSubscription.cancel();
    // if (uriSubscription != null) {
    // uriSubscription.cancel();
    // }
  }

  String groupValue = "";

  login() {
    log("--- login ---");
    loginService.login();
  }

  onPressedSignUp() {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // screenSize.width * 0.1, right: screenSize.width * 0.1
    return SafeArea(
        minimum: const EdgeInsets.only(bottom: 45),
        child: Scaffold(
            appBar: AppBar(
              //  backgroundColor: Colors.white,
              title: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    "ข้อตกลงและเงื่อนไขความยินยอมขอใช้บริการ",
                    //  style: TextStyle(color: Colors.black)
                  )),
              // ,
              // iconTheme: IconThemeData(color: Colors.red),
              // centerTitle: true,
              // leading: IconButton(
              //   icon: Icon(Icons.arrow_back),
              //   onPressed: () => backNavigator(),
              // ),
            ),
            body: Container(
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.all(20.0),
                    child: Card(
                        child: Container(
                      margin: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(consentHeaderText,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            height: screenSize.height * 0.5,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Container(child: Text(consentBodyText)),
                            ),
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text("เงื่อนไขการเปิดเผยข้อมูลส่วนบุคคล")),
                          Container(
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  title: const Text('ยินยอม'),
                                  contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                                  dense:true,
                                  leading: Radio(
                                    value: "0",
                                    groupValue: groupValue,
                                    onChanged: (value) {
                                      groupValue = value;
                                      setState(() {});
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: const Text('ไม่ยินยอม เฉพาะบริษัทนอกกลุ่มธุรกิจ'),
                                  contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                                  dense:true,
                                  leading: Radio(
                                    value: "1",
                                    groupValue: groupValue,
                                    onChanged: (value) {
                                      groupValue = value;
                                      setState(() {});
                                    },
                                  ),
                                ),
                                Container(
                                  child: ListTile(
                                    title: const Text('ไม่ยินยอม'),
                                    contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                                    dense:true,
                                    leading: Radio(
                                      value: "2",
                                      groupValue: groupValue,
                                      onChanged: (value) {
                                        groupValue = value;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
                child: ElevatedButton(
                    // color: Colors.redAccent,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      onPressedSignUp();
                    },
                    child: Text("ยืนยัน",
                        style: TextStyle(
                          fontSize: 16,
                          // color: Colors.white
                        ))))));
  }
}
