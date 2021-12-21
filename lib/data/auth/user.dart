// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:education_systems_mobile/core/security/base_auth.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User extends BaseUser {
  User({
    this.id,
    this.username,
    this.name,
    this.surname,
    this.number,
    this.type,
    this.localAddress,
  });

  int id;
  String username;
  String name;
  String surname;
  String number;
  int type;
  String localAddress;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    name: json["name"],
    surname: json["surname"],
    number: json["number"],
    type: json["type"],
    localAddress: json["localAddress"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "name": name,
    "surname": surname,
    "number": number,
    "type": type,
    "localAddress": localAddress,
  };
}
