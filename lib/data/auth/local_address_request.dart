// To parse this JSON data, do
//
//     final localAddressRequest = localAddressRequestFromJson(jsonString);

import 'dart:convert';

LocalAddressRequest localAddressRequestFromJson(String str) => LocalAddressRequest.fromJson(json.decode(str));

String localAddressRequestToJson(LocalAddressRequest data) => json.encode(data.toJson());

class LocalAddressRequest {
  LocalAddressRequest({
    this.userId,
    this.localAddress,
  });

  int userId;
  String localAddress;

  factory LocalAddressRequest.fromJson(Map<String, dynamic> json) => LocalAddressRequest(
    userId: json["userId"],
    localAddress: json["localAddress"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "localAddress": localAddress,
  };
}
