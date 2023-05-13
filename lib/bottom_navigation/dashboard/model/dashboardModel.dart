// To parse this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString);

import 'dart:convert';

DashboardModel dashboardModelFromJson(String str) => DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  bool status;
  String message;
  Response response;

  DashboardModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
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
  int totalPlant;
  int onlinePlant;
  int offlinePlant;
  int alarmPlant;
  dynamic onlinePlantPercent;
  dynamic offlinePlantPercent;
  dynamic alarmPlantPercent;
  int totalInverter;
  int onlineInverter;
  int alarmInverter;
  dynamic onlineInverterPercent;
  dynamic offlineInverterPercent;
  dynamic alarmInverterPercent;
  dynamic totalEnergy;
  dynamic todayEnergy;
  dynamic totalCapacity;
  dynamic currentPower;
  int notmonitered;
  dynamic monthlyEnergy;
  dynamic yearlyEnergy;
  int offlineInverter;

  Response({
    required this.totalPlant,
    required this.onlinePlant,
    required this.offlinePlant,
    required this.alarmPlant,
    required this.onlinePlantPercent,
    required this.offlinePlantPercent,
    required this.alarmPlantPercent,
    required this.totalInverter,
    required this.onlineInverter,
    required this.alarmInverter,
    required this.onlineInverterPercent,
    required this.offlineInverterPercent,
    required this.alarmInverterPercent,
    required this.totalEnergy,
    required this.todayEnergy,
    required this.totalCapacity,
    required this.currentPower,
    required this.notmonitered,
    this.monthlyEnergy,
    this.yearlyEnergy,
    required this.offlineInverter,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    totalPlant: json["total_Plant"],
    onlinePlant: json["online_Plant"],
    offlinePlant: json["offline_Plant"],
    alarmPlant: json["alarm_Plant"],
    onlinePlantPercent: json["online_Plant_Percent"],
    offlinePlantPercent: json["offline_Plant_Percent"],
    alarmPlantPercent: json["alarm_Plant_Percent"],
    totalInverter: json["total_Inverter"],
    onlineInverter: json["online_Inverter"],
    alarmInverter: json["alarm_Inverter"],
    onlineInverterPercent: json["online_Inverter_Percent"],
    offlineInverterPercent: json["offline_Inverter_Percent"],
    alarmInverterPercent: json["alarm_Inverter_Percent"],
    totalEnergy: json["total_Energy"],
    todayEnergy: json["today_Energy"],
    totalCapacity: json["total_Capacity"],
    currentPower: json["currentPower"],
    notmonitered: json["notmonitered"],
    monthlyEnergy: json["monthly_Energy"],
    yearlyEnergy: json["yearly_Energy"],
    offlineInverter: json["offline_Inverter"],
  );

  Map<String, dynamic> toJson() => {
    "total_Plant": totalPlant,
    "online_Plant": onlinePlant,
    "offline_Plant": offlinePlant,
    "alarm_Plant": alarmPlant,
    "online_Plant_Percent": onlinePlantPercent,
    "offline_Plant_Percent": offlinePlantPercent,
    "alarm_Plant_Percent": alarmPlantPercent,
    "total_Inverter": totalInverter,
    "online_Inverter": onlineInverter,
    "alarm_Inverter": alarmInverter,
    "online_Inverter_Percent": onlineInverterPercent,
    "offline_Inverter_Percent": offlineInverterPercent,
    "alarm_Inverter_Percent": alarmInverterPercent,
    "total_Energy": totalEnergy,
    "today_Energy": todayEnergy,
    "total_Capacity": totalCapacity,
    "currentPower": currentPower,
    "notmonitered": notmonitered,
    "monthly_Energy": monthlyEnergy,
    "yearly_Energy": yearlyEnergy,
    "offline_Inverter": offlineInverter,
  };
}
