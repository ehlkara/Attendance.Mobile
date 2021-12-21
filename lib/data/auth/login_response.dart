// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.id,
    this.fullName,
    this.number,
    this.accessToken,
    this.userType,
  });

  int id;
  String fullName;
  String number;
  String accessToken;
  int userType;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    id: json["id"],
    fullName: json["fullName"],
    number: json["number"],
    accessToken: json["accessToken"],
    userType: json["userType"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "number": number,
    "accessToken": accessToken,
    "userType": userType,
  };
}
