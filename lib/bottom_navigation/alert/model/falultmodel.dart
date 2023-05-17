// To parse this JSON data, do
//
//     final faultListModel = faultListModelFromJson(jsonString);

import 'dart:convert';

FaultListModel faultListModelFromJson(String str) => FaultListModel.fromJson(json.decode(str));

String faultListModelToJson(FaultListModel data) => json.encode(data.toJson());

class FaultListModel {
  bool status;
  String message;
  List<Response> response;

  FaultListModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory FaultListModel.fromJson(Map<String, dynamic> json) => FaultListModel(
    status: json["status"],
    message: json["message"],
    response: List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
  };
}

class Response {
  String faultCode;
  String faultName;
  DateTime date;
  String deviceNo;
  String faultBit;
  String status;
  String remark;
  String plantName;

  Response({
    required this.faultCode,
    required this.faultName,
    required this.date,
    required this.deviceNo,
    required this.faultBit,
    required this.status,
    required this.remark,
    required this.plantName,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    faultCode: json["faultCode"],
    faultName: json["faultName"],
    date: DateTime.parse(json["date"]),
    deviceNo: json["deviceNo"],
    faultBit: json["faultBit"],
    status: json["status"],
    remark: json["remark"],
    plantName: json["plantName"],
  );

  Map<String, dynamic> toJson() => {
    "faultCode": faultCode,
    "faultName": faultName,
    "date": date.toIso8601String(),
    "deviceNo": deviceNo,
    "faultBit": faultBit,
    "status": status,
    "remark": remark,
    "plantName": plantName,
  };
}
