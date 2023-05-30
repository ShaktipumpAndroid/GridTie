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

  Response({
    required this.totalPCapacity,
    required this.totalMEnergy,
    required this.address,
    required this.dDate,
    required this.totalDEnergy,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    totalPCapacity: json["total_PCapacity"]!=null?json["total_PCapacity"]?.toDouble():0.0,
    totalMEnergy: json["total_PCapacity"]!=null?json["total_MEnergy"]?.toDouble():0.0,
    address: json["total_PCapacity"]!=null?json["address"]:"",
    dDate: json["total_PCapacity"]!=null?json["d_date"]:"",
    totalDEnergy: json["total_PCapacity"]!=null?json["total_DEnergy"]?.toDouble():0.0,
  );

  Map<String, dynamic> toJson() => {
    "total_PCapacity": totalPCapacity,
    "total_MEnergy": totalMEnergy,
    "address": address,
    "d_date": dDate,
    "total_DEnergy": totalDEnergy,
  };
}
