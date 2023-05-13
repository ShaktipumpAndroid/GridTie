// To parse this JSON data, do
//
//     final plantListModel = plantListModelFromJson(jsonString);

import 'dart:convert';

PlantListModel plantListModelFromJson(String str) => PlantListModel.fromJson(json.decode(str));

String plantListModelToJson(PlantListModel data) => json.encode(data.toJson());

class PlantListModel {
  bool status;
  String message;
  List<Response> response;

  PlantListModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory PlantListModel.fromJson(Map<String, dynamic> json) => PlantListModel(
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
  int pid;
  String plantName;
  String plantAddress;
  int createdDate;
  String latitude;
  String longitude;
  dynamic muid;
  String capacity;
  String plantType;
  bool status;
  dynamic totalEnergy;
  dynamic todayEnergy;
  dynamic islogin;
  bool favPlant;

  Response({
    required this.pid,
    required this.plantName,
    required this.plantAddress,
    required this.createdDate,
    required this.latitude,
    required this.longitude,
    this.muid,
    required this.capacity,
    required this.plantType,
    required this.status,
    this.totalEnergy,
    this.todayEnergy,
    this.islogin,
    required this.favPlant,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    pid: json["pid"],
    plantName: json["plantName"],
    plantAddress: json["plantAddress"],
    createdDate: json["createdDate"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    muid: json["muid"],
    capacity: json["capacity"],
    plantType: json["plant_type"],
    status: json["status"],
    totalEnergy: json["totalEnergy"],
    todayEnergy: json["todayEnergy"],
    islogin: json["islogin"],
    favPlant: json["favPlant"],
  );

  Map<String, dynamic> toJson() => {
    "pid": pid,
    "plantName": plantName,
    "plantAddress": plantAddress,
    "createdDate": createdDate,
    "latitude": latitude,
    "longitude": longitude,
    "muid": muid,
    "capacity": capacity,
    "plant_type": plantType,
    "status": status,
    "totalEnergy": totalEnergy,
    "todayEnergy": todayEnergy,
    "islogin": islogin,
    "favPlant": favPlant,
  };
}
