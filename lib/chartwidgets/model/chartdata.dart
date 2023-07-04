// To parse this JSON data, do
//
//     final chartData = chartDataFromJson(jsonString);

import 'dart:convert';

ChartData chartDataFromJson(String str) => ChartData.fromJson(json.decode(str));

String chartDataToJson(ChartData data) => json.encode(data.toJson());

class ChartData {
  bool status;
  String message;
  List<Response> response;

  ChartData({
    required this.status,
    required this.message,
    required this.response,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) => ChartData(
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
  dynamic totalREnergy;
  dynamic todayREnergy;
  dynamic totalRCapacity;
  dynamic currentRPower;
  String address;
  dynamic todayPEnergy;
  dynamic totalPEnergy;
  dynamic cPPower;
  String deviceNo;
  String date1;

  Response({
    required this.totalREnergy,
    required this.todayREnergy,
    this.totalRCapacity,
    required this.currentRPower,
    required this.address,
    this.todayPEnergy,
    this.totalPEnergy,
    required this.cPPower,
    required this.deviceNo,
    required this.date1,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    totalREnergy: json["total_REnergy"]!=null?json["total_REnergy"]:0,
    todayREnergy: json["today_REnergy"]!=null?json["today_REnergy"]?.round():0,
    totalRCapacity: json["total_RCapacity"]!=null?json["total_RCapacity"]:0,
    currentRPower: json["currentRPower"]!=null?json["currentRPower"]*10000:0,
    address:json["address"]!=null&& json["address"].toString().isNotEmpty?json["address"]:"",
    todayPEnergy: json["today_PEnergy"]!=null?json["today_PEnergy"]*10000:0,
    totalPEnergy: json["total_PEnergy"]!=null?json["total_PEnergy"]*10000:0,
    cPPower: json["cP_Power"]!=null?json["cP_Power"]:0.0,
    deviceNo: json["deviceNo"] ?? "",
    date1:json["date1"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "total_REnergy": totalREnergy,
    "today_REnergy": todayREnergy,
    "total_RCapacity": totalRCapacity,
    "currentRPower": currentRPower,
    "address": address,
    "today_PEnergy": todayPEnergy,
    "total_PEnergy": totalPEnergy,
    "cP_Power": cPPower,
    "deviceNo": deviceNo,
    "date1": date1,
  };
}
