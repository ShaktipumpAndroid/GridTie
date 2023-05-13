
import 'package:flutter/foundation.dart';


const scheme = 'http';
const host = 'localhost';
const port = '5001';
const mobileHost = '192.168.29.211';

const webBaseUrl = '$scheme://$host:$port';
const mobileBaseUrl = '$scheme://$mobileHost:$port';

const deployedLambdaUrl = "https://solar10.shaktisolarrms.com//ShaktiGridTieInverter/";

getBaseURL() {
  String baseUrl = deployedLambdaUrl;
    /*if (kIsWeb) {
      print("1");
      baseUrl = webBaseUrl;
    } else {
      print("2");
      baseUrl = mobileBaseUrl;

  }*/
  return baseUrl;
}

userLogin() {
  return Uri.parse('${getBaseURL()}/gt_user/appIn');
}



