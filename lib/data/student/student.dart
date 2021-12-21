// To parse this JSON data, do
//
//     final address = addressFromJson(jsonString);

import 'dart:convert';

Student studentFromJson(String str) => Student.fromJson(json.decode(str));

String studentToJson(Student data) => json.encode(data.toJson());

class Student {
  Student({
    this.id,
    this.title,

  });

  int id;
  String title;


  factory Student.fromJson(Map<String, dynamic> json) => Student(
    id: json["id"],
    title: json["title"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,

  };
}
