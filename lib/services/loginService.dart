import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:openid_client/openid_client.dart' as openid;
import 'package:openid_client/openid_client.dart';
import 'package:register_demo/models/user.dart';
import 'package:register_demo/services/userService.dart';
import 'package:register_demo/screens/login.dart';
import 'dart:async';
import 'package:uni_links/uni_links.dart';
import 'dart:math' as math;

import 'package:url_launcher/url_launcher.dart';

class LoginService {
  static LoginService _instance;
  static LoginService getInstance() {
    if (_instance == null) {
      _instance = LoginService();
    }
    return _instance;
  }

  LoginService() {
    uriSubscription = getUriLinksStream().listen((Uri uri) async {
      print('LoginPage got uri: ${uri.toString()}');

      print('LoginPage path = ${uri.path}');

      if (uri.path.startsWith('/app/login')) {
        var userInfo = await this.authenticateFallback(uri);
        if (userInfo.toString() != null) {
          // login
          var user = userService.convertUser(userInfo);
          // userService.user = user;
        }
      }
    }, onError: (err) {
      print('got err: $err');
    });
  }

  StreamSubscription<Uri> uriSubscription = null;
  UserService userService = UserService.getInstance();
  User user;

  initPlatformStateForUriUniLinks() async {
    Uri initialUri;
    String initialLink;
    try {
      initialUri = await getInitialUri();
      print('initial uri: ${initialUri?.path}'
          ' ${initialUri?.queryParametersAll}');
      initialLink = initialUri?.toString();
    } on PlatformException {
      initialUri = null;
      initialLink = 'Failed to get initial uri.';
    } on FormatException {
      initialUri = null;
      initialLink = 'Bad parse the initial link as Uri.';
    }

    log("_latestUri: $initialUri");
    log("_latestLink: $initialLink");
  }

  Uri issuerUri =
      Uri.parse('https://keycloak.dev.iknowplus.co.th/auth/realms/Iknowplus');
  String clientId = 'mobile';
  String clientSecret = '342e477f-fbe5-43aa-81be-d7f902f95755';
  List<String> openidScopes = ['email', 'profile', 'roles', 'openid'];

  // Future<User> login() async {
  login() async {
    log("Login...");
    var userInfo = await authenticate();
    log("User Info: $userInfo");
  }

  Credential userCredential;

  Future<UserInfo> authenticateFallback(Uri uri) async {
    print(uri);
    uri = Uri.parse(uri.toString().replaceFirst("#", "?"));

    var flow = await createLoginFlow(uri.queryParameters['state']);
    log("authen callback");
    userCredential = await flow.callback(uri.queryParameters);
    log("userCredential");

    try {
      UserInfo userInfo = await userCredential.getUserInfo();
      log("userInfo: " + userInfo.toString());
      return userInfo;
    } on HttpException catch (e) {
      print(e.message);
      return null;
    }
  }

  Issuer issuer;
  Client openidClient;

  Future<Issuer> getIssuer() async {
    if (issuer == null) {
      issuer = await Issuer.discover(issuerUri);
    }

    return issuer;
  }

  Future<Client> getClient() async {
    var issuer = await getIssuer();

    if (openidClient == null) {
      openidClient = new Client(issuer, clientId, clientSecret: clientSecret);
    }

    return openidClient;
  }

  String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  math.Random _rnd = math.Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<openid.Flow> createLoginFlow([String state]) async {
    var openidClient = await getClient();

    if (state == null) {
      state = getRandomString(32);
    }

    var flow = openid.Flow.authorizationCode(openidClient, state: state);
    flow.redirectUri =
        Uri.parse("https://mobile.test.iknowplus.co.th/app/login");

    return flow;
  }

  urlLauncher(Uri uri) async {
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString(), forceWebView: false);
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }

  authenticate() async {
    // create a function to open a browser with an url

    log("authen...");
    var flow = await createLoginFlow();
    urlLauncher(flow.authenticationUri);

    return null;
  }

  logout() {
    // userService.user = new User();
    Uri uri = userCredential.generateLogoutUrl(
        redirectUri:
            Uri.parse("https://mobile.test.iknowplus.co.th/app/logout"));

    urlLauncher(uri);
  }
}
