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
    response: json["response"]!=null?List<Response>.from(json["response"].map((x) => Response.fromJson(x))):[],

  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
  };
}

class Response {
  String plantType;
  bool status;
  bool favPlant;
  String latitude;
  String longitude;
  String capacity;
  int pid;
  bool isActive;
  String plantName;
  DateTime createdDate;
  String plantAddress;
  dynamic muId;

  Response({
    required this.plantType,
    required this.status,
    required this.favPlant,
    required this.latitude,
    required this.longitude,
    required this.capacity,
    required this.pid,
    required this.isActive,
    required this.plantName,
    required this.createdDate,
    required this.plantAddress,
    this.muId,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    plantType: json["plant_type"],
    status: json["status"],
    favPlant: json["fav_Plant"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    capacity: json["capacity"],
    pid: json["pid"],
    isActive: json["isActive"],
    plantName: json["plantName"],
    createdDate: DateTime.parse(json["createdDate"]),
    plantAddress: json["plantAddress"],
    muId: json["muId"],
  );

  Map<String, dynamic> toJson() => {
    "plant_type": plantType,
    "status": status,
    "fav_Plant": favPlant,
    "latitude": latitude,
    "longitude": longitude,
    "capacity": capacity,
    "pid": pid,
    "isActive": isActive,
    "plantName": plantName,
    "createdDate": createdDate.toIso8601String(),
    "plantAddress": plantAddress,
    "muId": muId,
  };
}
