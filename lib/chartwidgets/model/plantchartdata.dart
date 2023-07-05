// To parse this JSON data, do
//
//     final plantChartData = plantChartDataFromJson(jsonString);

import 'dart:convert';

PlantChartData plantChartDataFromJson(String str) => PlantChartData.fromJson(json.decode(str));

String plantChartDataToJson(PlantChartData data) => json.encode(data.toJson());

class PlantChartData {
  bool status;
  String message;
  List<Response> response;

  PlantChartData({
    required this.status,
    required this.message,
    required this.response,
  });

  factory PlantChartData.fromJson(Map<String, dynamic> json) => PlantChartData(
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
  dynamic totalPCapacity;
  dynamic totalMEnergy;
  String address;
  String dDate;
  dynamic totalDEnergy;
  dynamic current_Energy;

  Response({
    required this.totalPCapacity,
    required this.totalMEnergy,
    required this.address,
    required this.dDate,
    required this.totalDEnergy,
    required this.current_Energy,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    totalPCapacity: json["total_PCapacity"]!="null"?json["total_PCapacity"]:0,
    totalMEnergy: json["total_MEnergy"]!="null"?json["total_MEnergy"]?.round():0,
    address: json["address"]!="null"?json["address"] : "",
    dDate: json["d_date"]!="null"?json["d_date"]:"",
    totalDEnergy: json["total_DEnergy"]!="null"?json["total_DEnergy"]?.round():0,
    current_Energy: json["current_Energy"]!="null"?json["current_Energy"]:0,
  );

  Map<String, dynamic> toJson() => {
    "total_PCapacity": totalPCapacity,
    "total_MEnergy": totalMEnergy,
    "address": address,
    "d_date": dDate,
    "total_DEnergy": totalDEnergy,
    "current_Energy": current_Energy,
  };
}
