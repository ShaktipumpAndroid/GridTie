// To parse this JSON data, do
//
//     final globleModel = globleModelFromJson(jsonString);

import 'dart:convert';

GlobleModel globleModelFromJson(String str) => GlobleModel.fromJson(json.decode(str));

String globleModelToJson(GlobleModel data) => json.encode(data.toJson());

class GlobleModel {
  bool status;
  String message;

  GlobleModel({
    required this.status,
    required this.message,
  });

  factory GlobleModel.fromJson(Map<String, dynamic> json) => GlobleModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
