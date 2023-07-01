// To parse this JSON data, do
//
//     final addPlantModel = addPlantModelFromJson(jsonString);

import 'dart:convert';

AddPlantModel addPlantModelFromJson(String str) => AddPlantModel.fromJson(json.decode(str));

String addPlantModelToJson(AddPlantModel data) => json.encode(data.toJson());

class AddPlantModel {
  bool status;
  String message;
  Response response;

  AddPlantModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory AddPlantModel.fromJson(Map<String, dynamic> json) => AddPlantModel(
    status: json["status"],
    message: json["message"],
    response: Response.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": response.toJson(),
  };
}

class Response {
  int pid;
  String plantName;
  String capacity;
  String plantAddress;
  bool isActive;
  String latitude;
  String longitude;

  Response({
    required this.pid,
    required this.plantName,
    required this.capacity,
    required this.plantAddress,
    required this.isActive,
    required this.latitude,
    required this.longitude,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    pid: json["pid"],
    plantName: json["plantName"],
    capacity: json["capacity"],
    plantAddress: json["plantAddress"],
    isActive: json["isActive"],
    latitude: json["latitude"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "pid": pid,
    "plantName": plantName,
    "capacity": capacity,
    "plantAddress": plantAddress,
    "isActive": isActive,
    "latitude": latitude,
    "longitude": longitude,
  };
}
