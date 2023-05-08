
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  String dateConverter(String myDate) {
    String date;
    DateTime convertedDate =
    DateFormat("dd/MM/yyyy").parse(myDate.toString());
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

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
}