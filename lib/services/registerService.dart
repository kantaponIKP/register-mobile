import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:register_demo/models/person.dart';

class RegisterService {
  static Future<http.Response> postRequest(
      username, email, Person person) async {
    // var url = 'http://10.0.2.2:3000/images/upload/';
    // var url = 'http://localhost:3001/api/users';
    // var url = 'http://10.0.2.2:3001/api/users/';
    var url = Uri.parse('https://register.test.iknowplus.co.th/api/users');

    Map user = {
      'username': username,
      'firstName': person.firstnameEng,
      'lastName': person.lastnameEng,
      'email': email,
    };

    Map data = {
      "user": user,
      "redirect_url": "https://mobile.test.iknowplus.co.th/app",
    };

    print("Post: " +
        username +
        " " +
        person.firstnameEng +
        " " +
        person.lastnameEng +
        " " +
        email);
    print("------Response-----");
    //encode Map to JSON
    var body = json.encode(data);
    try {
      final response = await http
          .post(url, headers: {"Content-Type": "application/json"}, body: body)
          .timeout(const Duration(seconds: 6));
      print("statusCode: ${response.statusCode}");
      print("body: ${response.body}");
      return response;
    } on TimeoutException catch (_) {
      print('Timeout');
    } on Error catch (e) {
      print('Error: $e');
    }
    return null;
  }
  
}
