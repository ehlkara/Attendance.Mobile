// To parse this JSON data, do
//
//     final lessonListResponse = lessonListResponseFromJson(jsonString);

import 'dart:convert';

LessonListResponse lessonListResponseFromJson(String str) => LessonListResponse.fromJson(json.decode(str));

String lessonListResponseToJson(LessonListResponse data) => json.encode(data.toJson());

class LessonListResponse {
  LessonListResponse({
    this.lessons,
  });

  List<Lesson> lessons;

  factory LessonListResponse.fromJson(Map<String, dynamic> json) => LessonListResponse(
    lessons: List<Lesson>.from(json["lessons"].map((x) => Lesson.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "lessons": List<dynamic>.from(lessons.map((x) => x.toJson())),
  };
}

class Lesson {
  Lesson({
    this.id,
    this.title,
    this.code,
    this.date,
    this.professorId,
    this.isActive
  });

  int id;
  String title;
  String code;
  DateTime date;
  int professorId;
  bool isActive;

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
    id: json["id"],
    title: json["title"],
    code: json["code"],
    date: DateTime.parse(json["date"]),
    professorId: json["professorId"],
    isActive: json["isActive"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "code": code,
    "date": date.toIso8601String(),
    "professorId": professorId,
    "isActive":isActive
  };
}
