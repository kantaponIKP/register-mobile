import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:register_demo/models/user.dart';
import 'package:register_demo/services/loginService.dart';
import 'package:register_demo/services/userService.dart';

class HomePage extends StatefulWidget {
  final userInfo;

  // final String email;

  const HomePage({Key key, this.userInfo}) : super(key: key);

  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  LoginService loginService = LoginService.getInstance();
  UserService userService = UserService.getInstance();
  User user;
  String username = '';
  String email = '';

  void initState() {
    super.initState();
    // loginService = LoginService.getInstance();
    // log("-----HomePage init------");
    // log("Homepage userInfo: " + widget.userInfo.toString());
    // initUser();
    // if (widget.userInfo != null) {
    //   initUser();
    // }
    // userService = UserService.getInstance();
    username = userService.user.given_name;
    email = userService.user.email;
    // username = '';
    // email = '';
  }

  // initUser() {
  //   try {
  //     log("initUser");
  //     var tempUserInfo = widget.userInfo.toString().replaceAll("{", "");
  //     tempUserInfo = tempUserInfo.replaceAll("}", "");
  //     tempUserInfo = tempUserInfo.replaceAll(" ", "");
  //     String jsonData = "{";
  //     var splitUser = tempUserInfo.split(",");
  //     for (int i = 0; i < splitUser.length; i++) {
  //       // log("i: $i");
  //       // log("splitUser "+splitUser[i]);
  //       var splitIner = splitUser[i].split(":");
  //       jsonData = jsonData + '"';
  //       jsonData = jsonData + splitIner[0];
  //       jsonData = jsonData + '": "';
  //       jsonData = jsonData + splitIner[1];
  //       if (i < splitUser.length - 1) {
  //         jsonData = jsonData + '",';
  //       }
  //     }
  //     jsonData = jsonData + '"}';
  //     log("$jsonData");

  //     user = User.fromJson(json.decode(jsonData));
  //   } catch (e) {
  //     user = new User();
  //   }

  //   setState(() {
  //     username = user.given_name;
  //     email = user.email;
  //   });
  // }

  void logout(context) {
    // Navigator.pushNamed(context, '/login');
    loginService.logout();
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: Colors.red,
                    size: 50.0,
                  ),
                ),
                accountName: Text(username),
                accountEmail: Text(email),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
                title: Text("Profile Settings"),
                onTap: () {},
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
                title: Text("Settings"),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.help_outline,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
                title: Text("About us"),
                onTap: () {},
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.cached,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
                title: Text("Recenceter"),
                onTap: () {
                  // Navigator.pushNamed(context, '/login');
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
                title: Text("Logout"),
                onTap: () {
                  logout(context);
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("Home Page"),
          centerTitle: true,
        ),

        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Color(0xff6bceff),
        //   onPressed: () {
        //   },
        //   child: Icon(Icons.add,color:Colors.white),
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                // color: Color(0xff6bceff),
                color: Colors.red[400],
              ),
              title: Text(
                'Home',
                style: TextStyle(
                  // color: Color(0xff6bceff),
                  color: Colors.red[400],
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Search'),
            ),
          ],
        ),
        body: ListView(children: <Widget>[
          SizedBox(
            height: 25,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: ListTile(
              leading: Icon(Icons.event_available),
              title: Text("Lorem"),
              // trailing: Text("-200",style: TextStyle(color: Colors.red),),
              subtitle: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
            ),
          ),
          ListTile(
            leading: Icon(Icons.event_available),
            title: Text("Nullam"),
            // trailing: Text("+400",style: TextStyle(color: Colors.green),),
            subtitle: Text("Nullam laoreet nunc eget pellentesque consequat."),
          ),
          // Column(
          //   children: [
          //     SizedBox(
          //       height: 30,
          //     ),
          //     InkWell(
          //       onTap: () {
          //         Navigator.pushNamed(context, '/register');
          //       },
          //       child: Container(
          //         height: 45,
          //         width: MediaQuery.of(context).size.width / 2,
          //         decoration: BoxDecoration(
          //             gradient: LinearGradient(
          //               colors: [
          //                 Color(0xff6bceff),
          //                 Color(0xFF00abff),
          //               ],
          //             ),
          //             borderRadius: BorderRadius.all(Radius.circular(50))),
          //         child: Center(
          //           child: Text(
          //             // 'Sign Up'.toUpperCase(),
          //             'Register',
          //             style: TextStyle(
          //                 color: Colors.white, fontWeight: FontWeight.bold),
          //           ),
          //         ),
          //       ),
          //     )
          //   ],
          // ),
        ]));
  }
}
