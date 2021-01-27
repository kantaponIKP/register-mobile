import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';

class AuthorizationFactory {
  String contentType = "application/json";
  String method = "POST";

  Uri url = Uri.parse("https://faceid.tencentcloudapi.com/");

  DateTime requestDate = DateTime.now();

  String service = "faceid";
  String secretId = "AKIDV0QJ4J9NgprhOwsPuHUxBILOLE3mAcu6";
  String secretKey = "65azKqF52vlXddXJYfgzCGuSamss13vV";

  String payload;

  String algorithm = "TC3-HMAC-SHA256";

  String getCononicalHeader() {
    return 'content-type:$contentType\nhost:${url.host}\n'; 
  }

  String getSignedHeader() {
    return 'content-type;host';
  }

  String sha256hash(String message) {
    List<int> bytes = utf8.encode(message);
    List<int> hash = sha256.convert(bytes).bytes;
    String hexes = hex.encode(hash);

    return hexes;
  } 

  String getHashedPayload() {
    return sha256hash(payload);
  }

  String getDateString() {
    DateTime utcDate = requestDate.toUtc();
    return "${utcDate.year.toString().padLeft(4, "0")}-${utcDate.month.toString().padLeft(2, "0")}-${utcDate.day.toString().padLeft(2, "0")}";
  }

  String getHashedCononicalRequest() {
    String request = getCononicalRequest();
    return sha256hash(request);
  }

  List<int> hmacSha256(List<int> keyBytes, String message) {
    var messageBytes = utf8.encode(message);

    // var hmac = new Hmac(sha256, keyBytes);
    var hmac = new Hmac(sha256, keyBytes);

    return hmac.convert(messageBytes).bytes;
  }

  String getCononicalRequest() {
    String uri = url.path;
    String query = url.query;

    String header = getCononicalHeader();
    String signedHeader = getSignedHeader();
    String hashedPayload = getHashedPayload();

    return "$method\n$uri\n$query\n$header\n$signedHeader\n$hashedPayload";
  }

  String getCredentialScope() {
    return "${getDateString()}/$service/tc3_request";
  }

  String getStringToSign() {
    int requestTimeStamp = getTimestamp();

    String credentialScope = getCredentialScope();
    String hashedCononicalRequest = getHashedCononicalRequest();

    return "$algorithm\n$requestTimeStamp\n$credentialScope\n$hashedCononicalRequest";
  }

  List<int> getSecretSigning() {
    String date = getDateString();

    List<int> key = utf8.encode("TC3$secretKey");
    List<int> secretDate = hmacSha256(key, date);
    List<int> secretService = hmacSha256(secretDate, service);
    List<int> secretSigning = hmacSha256(secretService, "tc3_request");

    return secretSigning;
  }

  String getSignature() {
    List<int> secretSigning = getSecretSigning();
    // String secretSigningHex = hex.encode(secretSigning);

    String stringToSign = getStringToSign();

    List<int> signedBytes = hmacSha256(secretSigning, stringToSign);
    return hex.encode(signedBytes);
  }

  int getTimestamp() {
    return (requestDate.toUtc().millisecondsSinceEpoch ~/ 1000);
  }

  String buildAuthorization() {
    String credentialScope = getCredentialScope();
    String signedHeaders = getSignedHeader();
    String signature = getSignature();

    return "$algorithm Credential=$secretId/$credentialScope, SignedHeaders=$signedHeaders, Signature=$signature";
  }
}