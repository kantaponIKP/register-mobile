import 'package:flutter/material.dart';
import 'package:register_demo/screens/login.dart';
import 'package:register_demo/screens/register/stepperPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.redAccent,
        accentColor: Colors.red[400],
      ),
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => StepperPage(),
      },
    ); 
  }
}
