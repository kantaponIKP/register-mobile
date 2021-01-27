import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:register_demo/models/user.dart';
import 'package:register_demo/services/loginService.dart';
import 'package:register_demo/services/registerStorage.dart';
import 'package:register_demo/services/userService.dart';

import 'home.dart';

// import 'dart:developer';
// import 'dart:io';

// import 'package:openid_client/openid_client.dart' as openid;
// import 'package:register_demo/screens/home.dart';

// import 'package:uni_links/uni_links.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:openid_client/openid_client_io.dart';
// import 'dart:math' as math;

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  // StreamSubscription _sub;
  // String _latestLink = 'Unknown';
  // Uri _latestUri;

  LoginService loginService;
  UserService userService;
  User user;

  StreamSubscription userSubscription;
  RegisterStorage registerStorage;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    loginService = LoginService.getInstance();
    userService = UserService.getInstance();
    registerStorage = RegisterStorage.getInstance();

    userSubscription = userService.UserStateStream.listen((user) {
      log("listen :" + user.name);
      if (user != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => HomePage()));
      }
    });

    initPlatformState();
  }

  initPlatformState() async {
    await loginService.initPlatformStateForUriUniLinks();
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

  login() {
    log("--- login ---");
    loginService.login();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // screenSize.width * 0.1, right: screenSize.width * 0.1
    return WillPopScope(
        onWillPop: () {
          return new Future(() => false);
        },
        child: Scaffold(
          body: Container(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 120,
                ),
                Container(
                  padding: const EdgeInsets.all(50),
                  // height: 200.0,
                  // width: 200.0,
                  height: screenSize.width*0.5,
                  width: screenSize.width*0.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/iknowplusLogo.png'),
                      // fit: BoxFit.fill,
                    ),
                    // shape: BoxShape.circle,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 100),
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          login();
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (BuildContext context) =>
                          //             HomePage(userInfo: null)));
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 1.2,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  // Color(0xff6bceff),
                                  // Color(0xFF00abff),
                                  Colors.red[300],
                                  Colors.red[500],
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Center(
                            child: Text(
                              'Login'.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don't have an account ?"),
                      Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.red[400]),
                      ),
                    ],
                  ),
                  onTap: () {
                    registerStorage.clearData();
                    Navigator.pushNamed(context, '/register');
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
