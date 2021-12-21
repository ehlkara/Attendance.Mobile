// To parse this JSON data, do
//
//     final sectionRequest = sectionRequestFromJson(jsonString);

import 'dart:convert';

SectionRequest sectionRequestFromJson(String str) => SectionRequest.fromJson(json.decode(str));

String sectionRequestToJson(SectionRequest data) => json.encode(data.toJson());

class SectionRequest {
  SectionRequest({
    this.userId,
    this.lessonCode,
  });

  int userId;
  String lessonCode;

  factory SectionRequest.fromJson(Map<String, dynamic> json) => SectionRequest(
    userId: json["userId"],
    lessonCode: json["lessonCode"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "lessonCode": lessonCode,
  };
}
