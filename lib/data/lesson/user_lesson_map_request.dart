// To parse this JSON data, do
//
//     final userLessonMapRequest = userLessonMapRequestFromJson(jsonString);

import 'dart:convert';

UserLessonMapRequest userLessonMapRequestFromJson(String str) => UserLessonMapRequest.fromJson(json.decode(str));

String userLessonMapRequestToJson(UserLessonMapRequest data) => json.encode(data.toJson());

class UserLessonMapRequest {
  UserLessonMapRequest({
    this.userLessonMapId,
    this.statusType,
  });

  int userLessonMapId;
  int statusType;

  factory UserLessonMapRequest.fromJson(Map<String, dynamic> json) => UserLessonMapRequest(
    userLessonMapId: json["userLessonMapId"],
    statusType: json["statusType"],
  );

  Map<String, dynamic> toJson() => {
    "userLessonMapId": userLessonMapId,
    "statusType": statusType,
  };
}
