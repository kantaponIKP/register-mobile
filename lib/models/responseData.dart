class ResponseData {
  final String error;
  final String username;
  final String url;

  ResponseData({this.error,this.username,this.url});
  // ResponseData({this.username});
  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      error: json['error'],
      username: json['username'],
      url: json['url'],
    );
  }
}
