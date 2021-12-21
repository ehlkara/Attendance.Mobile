// To parse this JSON data, do
//
//     final studentAttendanceListResponse = studentAttendanceListResponseFromJson(jsonString);

import 'dart:convert';

StudentAttendanceListResponse studentAttendanceListResponseFromJson(String str) => StudentAttendanceListResponse.fromJson(json.decode(str));

String studentAttendanceListResponseToJson(StudentAttendanceListResponse data) => json.encode(data.toJson());

class StudentAttendanceListResponse {
  StudentAttendanceListResponse({
    this.studentAttendances,
  });

  List<StudentAttendance> studentAttendances;

  factory StudentAttendanceListResponse.fromJson(Map<String, dynamic> json) => StudentAttendanceListResponse(
    studentAttendances: List<StudentAttendance>.from(json["studentAttendances"].map((x) => StudentAttendance.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "studentAttendances": List<dynamic>.from(studentAttendances.map((x) => x.toJson())),
  };
}

class StudentAttendance {
  StudentAttendance({
    this.number,
    this.fullName,
    this.statusType,
  });

  String number;
  String fullName;
  int statusType;

  factory StudentAttendance.fromJson(Map<String, dynamic> json) => StudentAttendance(
    number: json["number"],
    fullName: json["fullName"],
    statusType: json["statusType"],
  );

  Map<String, dynamic> toJson() => {
    "number": number,
    "fullName": fullName,
    "statusType": statusType,
  };
}
