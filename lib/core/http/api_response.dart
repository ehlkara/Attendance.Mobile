// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

ApiResponse apiResponseFromJson(String str) => ApiResponse.fromJson(json.decode(str));

String apiResponseToJson(ApiResponse data) => json.encode(data.toJson());

class ApiResponse {
  ApiResponse({
    this.statusCode,
    this.results,
    this.result,
    this.error,
    this.hasError,
  });

  int statusCode;
  dynamic results;
  dynamic result;
  Error error;
  bool hasError;

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
    statusCode: json["statusCode"],
    results: json["results"],
    result: json["result"],
    error: json["error"] != null ? Error.fromJson(json["error"]): null,
    hasError: json["hasError"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "results": results,
    "result": result,
    "error": error.toJson(),
    "hasError": hasError,
  };
}
class Error{
  Error({this.message, this.statusCode});
  String message;
  int statusCode;
  factory Error.fromJson(Map<String, dynamic> json) => Error(
    message: json["message"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "statusCode": statusCode,
  };
}

