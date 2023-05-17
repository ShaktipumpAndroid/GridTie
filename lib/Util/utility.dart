
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/color.dart';
import '../theme/string.dart';
import '../uiwidget/robotoTextWidget.dart';
import '../webservice/constant.dart';

class Utility {

  bool isActiveConnection = false;
   Future<bool> checkInternetConnection() async {

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isActiveConnection = true;
      return  Future<bool>.value(isActiveConnection);
      }
    } on SocketException catch (_) {
      isActiveConnection = false;
      return  Future<bool>.value(isActiveConnection);
    }
    return  Future<bool>.value(isActiveConnection);
  }

 void showInSnackBar({required String value,required context}) {
   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       content: Text(value),
       duration: const Duration(milliseconds: 3000),
     ),
   );
 }
  String dateConverter(String myDate, int days) {
    String date;
    DateTime convertedDate =
    DateFormat("dd/MM/yyyy").parse(myDate.toString());
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - days);
    final tomorrow = DateTime(now.year, now.month, now.day + days);

    final dateToCheck = convertedDate;
    final checkDate = DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    if (checkDate == today) {
      date = "Today";
    } else if (checkDate == yesterday) {
      date = "Yesterday";
    } else if (checkDate == tomorrow) {
      date = "Tomorrow";
    } else {
      date = myDate;
    }
    return date;
  }


  String changeDateFormate(String date) {
    var inputFormat = DateFormat("yyyy-MM-dd HH:mm:ssZ");
    var inputDate = inputFormat.parse(date); // <-- dd/MM 24H format

    var outputFormat = DateFormat('dd MMM yyyy HH:mm a');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  Future<String> isUserLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.get(userID)!=null && sharedPreferences.get(userID).toString().isNotEmpty){
     return "true";

    }else{
      return "false";
    }
  }

  void showToast(String toast_msg) {
    Fluttertoast.showToast(
        msg: toast_msg,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 9);
  }
}