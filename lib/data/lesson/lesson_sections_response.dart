// To parse this JSON data, do
//
//     final lessonSectionsListResponse = lessonSectionsListResponseFromJson(jsonString);

import 'dart:convert';

LessonSectionsListResponse lessonSectionsListResponseFromJson(String str) => LessonSectionsListResponse.fromJson(json.decode(str));

String lessonSectionsListResponseToJson(LessonSectionsListResponse data) => json.encode(data.toJson());

class LessonSectionsListResponse {
  LessonSectionsListResponse({
    this.lessons,
  });

  List<Lesson> lessons;

  factory LessonSectionsListResponse.fromJson(Map<String, dynamic> json) => LessonSectionsListResponse(
    lessons: List<Lesson>.from(json["lessons"].map((x) => Lesson.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "lessons": List<dynamic>.from(lessons.map((x) => x.toJson())),
  };
}

class Lesson {
  Lesson({
    this.userId,
    this.lessonTitle,
    this.lessonCode,
    this.lessonDate,
    this.statusType,
    this.userLessonMapId,
    this.lessonId,
    this.professorId
  });

  int userId;
  String lessonTitle;
  String lessonCode;
  DateTime lessonDate;
  int statusType;
  int userLessonMapId;
  int lessonId;
  int professorId;

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
    userId: json["userId"],
    lessonTitle: json["lessonTitle"],
    lessonCode: json["lessonCode"],
    lessonDate: DateTime.parse(json["lessonDate"]),
    statusType: json["statusType"],
    userLessonMapId: json["userLessonMapId"],
    lessonId: json["lessonId"],
    professorId: json["professorId"]
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "lessonTitle": lessonTitle,
    "lessonCode": lessonCode,
    "lessonDate": lessonDate.toIso8601String(),
    "statusType": statusType,
    "userLessonMapId": userLessonMapId,
    "lessonId":lessonId,
    "professorId":professorId
  };
}
