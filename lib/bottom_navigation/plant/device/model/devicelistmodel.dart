// To parse this JSON data, do
//
//     final deviceListModel = deviceListModelFromJson(jsonString);

import 'dart:convert';

DeviceListModel deviceListModelFromJson(String str) => DeviceListModel.fromJson(json.decode(str));

String deviceListModelToJson(DeviceListModel data) => json.encode(data.toJson());

class DeviceListModel {
  bool status;
  String message;
  List<Response> response;

  DeviceListModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory DeviceListModel.fromJson(Map<String, dynamic> json) => DeviceListModel(
    status: json["status"],
    message: json["message"],
    response: json["response"]!=null?List<Response>.from(json["response"].map((x) => Response.fromJson(x))):[],

  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
  };
}

class Response {
  String deviceNo;
  String inverterType;
  dynamic model;
  String plantName;
  dynamic courrentPower;
  String eTotal;
  String status;
  String remark;
  String todayEnergy;

  Response({
    required this.deviceNo,
    required this.inverterType,
    this.model,
    required this.plantName,
    this.courrentPower,
    required this.eTotal,
    required this.status,
    required this.remark,
    required this.todayEnergy,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    deviceNo: json["deviceNo"] != null?json["deviceNo"]:"",
    inverterType: json["inverterType"] ?? "",
    model: json["model"] != 0.0?json["model"]:"",
    plantName: json["plantName"] ?? "",
    courrentPower: json["courrentPower"] ?? "",
    eTotal: json["eTotal"] ?? "",
    status: json["status"] ?? "",
    remark: json["remark"] ?? "",
    todayEnergy: json["today_energy"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "deviceNo": deviceNo,
    "inverterType": inverterType,
    "model": model,
    "plantName": plantName,
    "courrentPower": courrentPower,
    "eTotal": eTotal,
    "status": status,
    "remark": remark,
    "today_energy": todayEnergy,
  };
}
