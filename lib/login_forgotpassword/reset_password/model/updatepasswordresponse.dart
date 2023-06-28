// To parse this JSON data, do
//
//     final updatePasswordResponse = updatePasswordResponseFromJson(jsonString);

import 'dart:convert';

UpdatePasswordResponse updatePasswordResponseFromJson(String str) => UpdatePasswordResponse.fromJson(json.decode(str));

String updatePasswordResponseToJson(UpdatePasswordResponse data) => json.encode(data.toJson());

class UpdatePasswordResponse {
  bool status;
  String message;
  int response;

  UpdatePasswordResponse({
    required this.status,
    required this.message,
    required this.response,
  });

  factory UpdatePasswordResponse.fromJson(Map<String, dynamic> json) => UpdatePasswordResponse(
    status: json["status"],
    message: json["message"],
    response: json["response"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": response,
  };
}
