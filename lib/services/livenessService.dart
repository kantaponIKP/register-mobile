import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:register_demo/services/tencentHttpService.dart';

class LivenessService {

  // static final Charset UTF8 = StandardCharsets.UTF_8;
  TencentHttpService tencentHttpService;

  static final String secretId = "AKIDV0QJ4J9NgprhOwsPuHUxBILOLE3mAcu6";
  static final String secretKey = "65azKqF52vlXddXJYfgzCGuSamss13vV";
  static final String ctJson = "application/json; charset=utf-8";

  // Map<String, String> requestHeaders = {
  //   'Content-type': 'application/json',
  //   'Accept': 'application/json',
  //   'Authorization':
  //       'TC3-HMAC-SHA256 Credential=AKIDV0QJ4J9NgprhOwsPuHUxBILOLE3mAcu6/2020-11-05/faceid/tc3_request, SignedHeaders=content-type;host, Signature=f60dc321ab5b373f7b68c0272f59d13961acdac2d2123f0fa88da73d2b085106',
  //   'Host': 'faceid.tencentcloudapi.com',
  //   'X-TC-Action': 'LivenessCompare',
  //   'X-TC-Version': '2018-03-01',
  //   'X-TC-Timestamp': '1604565840',
  //   'X-TC-Region': 'ap-bangkok',
  //   'X-TC-Language': 'en-US'
  // };


  static silent({String imageBase64, String videoBase64}) async {
    var tencentApi = TencentHttpService.getInstance();

    var url = Uri.parse("https://faceid.tencentcloudapi.com/");
    var livenessType = 'SILENT';

    Map data = {
      'ImageBase64': imageBase64,
      'VideoBase64': videoBase64,
      'LivenessType': livenessType,
    };

    print("Post: " +
        imageBase64 +
        " " +
        videoBase64 +
        " " +
        livenessType
        );

    print("------Response-----");

    final response = await tencentApi.postJson(
      jsonPayload: data,
      action: "LivenessCompare",
      service: "faceid",
      uri: url,
    );

    print("statusCode: ${response.statusCode}");
    print("body: ${response.body}");
    return response;
  }
}
