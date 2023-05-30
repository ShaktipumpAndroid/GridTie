
import 'package:flutter/foundation.dart';


const scheme = 'http';
const host = 'localhost';
const port = '5001';
const mobileHost = '192.168.29.211';

const webBaseUrl = '$scheme://$host:$port';
const mobileBaseUrl = '$scheme://$mobileHost:$port';

const deployedLambdaUrl = "https://solar10.shaktisolarrms.com/ShaktiGridTieInverter/";

getBaseURL() {
  String baseUrl = deployedLambdaUrl;
    if (kIsWeb) {
      print("1");
      baseUrl = deployedLambdaUrl;
    } else {
      print("2");
      baseUrl = deployedLambdaUrl;

  }
  return baseUrl;
}

userLogin() {
  return Uri.parse('${getBaseURL()}gt_user/appIn');
}


getDashboardDetails(String userId) {
  return Uri.parse('${getBaseURL()}dashboard/list?userId=$userId');
}

getPlantList(String userId) {
  return Uri.parse('${getBaseURL()}plant/list?userId=$userId');
}
getFaultList(String userId) {
  return Uri.parse('${getBaseURL()}fault/checkFaultToday?userId=$userId');
}


getDeviceList(String userId,String status,String plantId) {
  return Uri.parse('${getBaseURL()}TDevice/list?userId=$userId&status=$status&plant=$plantId');
}

getDailyDeviceChart(String userId,String date, String deviceId) {
  return Uri.parse('${getBaseURL()}statistics/deviceReport?userId=${userId}&startD=${date}&deviceno=${deviceId}');
}
getMonthlyDeviceChart(String userId,String firstDate,String lastDate, String deviceId) {
  return Uri.parse('${getBaseURL()}statistics/dMonthReport?userId=${userId}&strDate=${firstDate}&endDate=${lastDate}&deviceno=${deviceId}');
}

getYearlyDeviceChart(String userId,String firstDate,String lastDate, String deviceId) {
  return Uri.parse('${getBaseURL()}statistics/dYearReport?userId=${userId}&strDate=${firstDate}&endDate=${lastDate}&deviceno=${deviceId}');
}

getDailyPlantChart(String userId,String date, String deviceId) {
  return Uri.parse('${getBaseURL()}statistics/report?userId=${userId}&startD=${date}&plantID=${deviceId}');
}

getMonthlyPlantChart(String userId,String firstDate,String lastDate, String deviceId) {
  return Uri.parse('${getBaseURL()}statistics/pMonthReport?userId=${userId}&startD=${firstDate}&endDate=${lastDate}&plantID=${deviceId}');
}

getYearlyPlantChart(String userId,String firstDate,String lastDate, String deviceId) {
  return Uri.parse('${getBaseURL()}statistics/pYearReport?userId=${userId}&strDate=${firstDate}&endDate=${lastDate}&plantID=${deviceId}');
}
//ShaktiGridTieInverter/statistics/pMonthReport?userId=2&startD=2023-05-29&plantID=122