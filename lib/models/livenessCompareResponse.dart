class LivenessCompareResponse {
  // final response
  final Response response;
  // final String description;
  // final String sim;
  // final String bestFrameBase64;
  // final String requestId;
  // final ErrorResponse error;

  LivenessCompareResponse(
      {this.response,
      // this.description,
      // this.sim,
      // this.bestFrameBase64,
      // this.requestId,
      // this.error
      });

  factory LivenessCompareResponse.fromJson(Map<String, dynamic> parsedJson) {
    return LivenessCompareResponse(
      response: Response.fromJson(parsedJson['Response'])
        // response: parsedJson['Response'],

        // description: parsedJson['Description'],
        // sim: parsedJson['Sim'],
        // bestFrameBase64: parsedJson['BestFrameBase64'],
        // requestId: parsedJson['RequestId'],
        // error: ErrorResponse.fromJson(parsedJson['Error'])
        );
  }
}
class Response{
  final String result;
  final String description;
  final String sim;
  final String bestFrameBase64;
  final String requestId;
  final ErrorResponse error;
  Response(
      {
      this.result,
      this.description,
      this.sim,
      this.bestFrameBase64,
      this.requestId,
      this.error
      });

  factory Response.fromJson(Map<String, dynamic> parsedJson) {
    return Response(
        result: parsedJson['Result'],
        description: parsedJson['Description'],
        sim: "${parsedJson['Sim']}",
        bestFrameBase64: parsedJson['BestFrameBase64'],
        requestId: parsedJson['RequestId'],
        error: ErrorResponse.fromJson(parsedJson['Error'])
        );
  }

}

class ErrorResponse {
  final String code;
  final String message;
  ErrorResponse({
    this.code,
    this.message,
  });
  factory ErrorResponse.fromJson(Map<String, dynamic> parsedJson) {
    String code = "";
    String message = "";

    if (parsedJson != null) {
      code = parsedJson['Code'];
      message = parsedJson['Message'];
    }

    return ErrorResponse(
        code: code, message: message);
  }
}
