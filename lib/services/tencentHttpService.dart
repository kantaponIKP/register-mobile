import 'package:register_demo/tencent/SignatureFactory.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class TencentHttpService {
  static TencentHttpService _instance;

  static TencentHttpService getInstance() {
    if (_instance == null) {
      _instance = TencentHttpService();
    }
    return _instance;
  }

  Future<http.Response> post(
      {String service,
      String action,
      Uri uri,
      String contentType,
      String payload}) async {
    AuthorizationFactory auth = AuthorizationFactory();
    auth.contentType = contentType;
    auth.method = "POST";
    auth.payload = payload;
    auth.service = service;
    auth.url = uri;

    Map<String, String> headers = {
      'Content-Type': contentType,
      'Authorization': auth.buildAuthorization(),
      'X-TC-Action': action,
      'X-TC-Version': '2018-03-01',
      'X-TC-Timestamp': auth.getTimestamp().toString(),
      'X-TC-Region': 'ap-bangkok',
      'X-TC-Language': 'en-US'
    };

    http.Response response =
        await http.post(uri, headers: headers, body: payload);
    return response;
  }

  Future<http.Response> postJson(
      {String service, String action, Uri uri, Map jsonPayload}) async {
    var body = json.encode(jsonPayload);

    http.Response response = await post(
        action: action,
        contentType: "application/json; charset=utf-8",
        payload: body,
        service: service,
        uri: uri);

    return response;
  }
}
