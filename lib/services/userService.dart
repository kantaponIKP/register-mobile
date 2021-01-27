import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:register_demo/models/user.dart';

class UserService {
  static UserService _instance;
  static UserService getInstance() {
    if (_instance == null) {
      _instance = UserService();
    }
    return _instance;
  }

  StreamController<User> userStateController = StreamController<User>();

  Stream<User> get UserStateStream {
    return userStateController.stream;
  }

  User _user;
  User get user {
    return _user;
  }

  set user(User value) { 
    // if(_user != null){
    //   return;
    // }

    _user = value;
    userStateController.add(_user);
  }

  User convertUser(var userInfo) {
    try {
      log("initUser");
      var tempUserInfo = userInfo.toString().replaceAll("{", "");
      tempUserInfo = tempUserInfo.replaceAll("}", "");
      tempUserInfo = tempUserInfo.replaceAll(" ", "");
      String jsonData = "{";
      var splitUser = tempUserInfo.split(",");
      for (int i = 0; i < splitUser.length; i++) {
        // log("i: $i");
        // log("splitUser "+splitUser[i]);
        var splitIner = splitUser[i].split(":");
        jsonData = jsonData + '"';
        jsonData = jsonData + splitIner[0];
        jsonData = jsonData + '": "';
        jsonData = jsonData + splitIner[1];
        if (i < splitUser.length - 1) {
          jsonData = jsonData + '",';
        }
      }
      jsonData = jsonData + '"}';
      log("$jsonData");

      user = User.fromJson(json.decode(jsonData));
    } catch (e) {
      user = new User();
    }

    return user;
  }
}
