class User {
  String sub;
  String email_verified;
  String name;
  String preferred_username;
  String given_name;
  String family_name;
  String email;

  User(
      {this.sub,
      this.email_verified,
      this.name,
      this.preferred_username,
      this.given_name,
      this.family_name,
      this.email});
  // ResponseData({this.username});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      sub: json['sub'],
      email_verified: json['email_verified'],
      name: json['name'],
      preferred_username: json['preferred_username'],
      given_name: json['given_name'],
      family_name: json['family_name'],
      email: json['email'],
    );
  }
}
