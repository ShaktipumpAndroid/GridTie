import 'dart:math';
import 'package:grid_tie/login_forgotpassword/otppage/model/otpreponse.dart';
import 'package:grid_tie/main.dart';
import 'package:grid_tie/webservice/APIDirectory.dart';
import 'package:grid_tie/webservice/HTTP.dart' as HTTP;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grid_tie/theme/color.dart';
import 'package:grid_tie/theme/string.dart';

import '../../Util/utility.dart';
import '../otppage/otppage.dart';
import '../../uiwidget/robotoTextWidget.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _RegisterMobileState();
}

class _RegisterMobileState extends State<ForgotPasswordPage> {
  bool isLoading = false, isScreenVisible = false;

  int _randomNumber1 = 0;

  TextEditingController mobileNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: AppColor.themeColor,
            elevation: 0,
            title: robotoTextWidget(
                textval: forgotPasswordTitle,
                colorval: AppColor.whiteColor,
                sizeval: 15,
                fontWeight: FontWeight.w800),
          leading: IconButton(
              icon: new Icon(Icons.arrow_back, color: AppColor.whiteColor,),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );}
          ),
        ),
        body: SizedBox(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: AppColor.themeColor),

            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/svg/applogo.svg",
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height/2,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(60),
                                  topRight: Radius.circular(60))),
                          child: SingleChildScrollView(
                            child: Container(
                              margin: const EdgeInsets.only(top: 80),
                              child: Column(

                                children: [
                                  Text(mobileNumberDesc, textAlign: TextAlign.center,style: const TextStyle(color:Colors.grey,
                                  fontSize: 12,fontWeight: FontWeight.w600)),
                                  MobileTextWidget(),
                                  GestureDetector(
                                      onTap: () {
                                        Random random = Random();
                                        _randomNumber1 = random.nextInt(9999 - 1000 )+1000;
                                        signIn();
                                      },
                                      child: Container(
                                        height: 50,
                                        margin:
                                        const EdgeInsets.symmetric(horizontal: 50),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: AppColor.themeColor),
                                        child: Center(
                                          child: isLoading
                                              ? const SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: CircularProgressIndicator(
                                              color: AppColor.whiteColor,
                                            ),
                                          )
                                              : robotoTextWidget(
                                              textval: sendOTP,
                                              colorval: Colors.white,
                                              sizeval: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  // ignore: non_constant_identifier_names
  Container MobileTextWidget() {
    return Container(
        margin: const EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromRGBO(30, 136, 229, .3),
                  blurRadius: 20,
                  offset: Offset(0, 10))
            ]),
        child: Column(
          children: <Widget>[
            Container(
              padding:
                  const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 5),
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade200))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.phone_android_sharp,
                      color: AppColor.themeColor,
                      size: 20,
                    ),
                  ),

                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: TextField(
                      controller: mobileNoController,
                      decoration: InputDecoration(
                          hintText: mobileNumber,
                          hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.normal),
                          border: InputBorder.none),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Future<void> signIn() async {
    Utility().checkInternetConnection().then((connectionResult) {

      if (connectionResult) {
        if (mobileNoController.text.toString().isEmpty) {
          Utility().showInSnackBar(value: mobileNoMessage, context: context);
        } else if ( mobileNoController.text.toString().length != 10) {
          Utility().showInSnackBar(value: invaildMobileNo, context: context);
        } else {

          showDialog(
            context: context,
            builder: (BuildContext context) => dialogueOtp(context),
          );

          // loginAPI();
        }
      } else {
        Utility()
            .showInSnackBar(value: checkInternetConnection, context: context);
      }
    });
  }

  Widget dialogueOtp(BuildContext context) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Container(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                appName,
                style: const TextStyle(
                    color: AppColor.themeColor,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              sendOtpMessage,
              style: const TextStyle(
                  color: AppColor.themeColor,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 12),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    child: robotoTextWidget(
                      textval: cancel,
                      colorval: AppColor.darkGrey,
                      sizeval: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      confirmotp(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    child: robotoTextWidget(
                      textval: OK,
                      colorval: AppColor.whiteColor,
                      sizeval: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            )
          ]),
        ));
  }

  Future<void> confirmotp(BuildContext context) async {

    sendOtpAPI();

  }

  Future<void> sendOtpAPI() async {
    setState(() {
      isLoading = true;
    });

    var jsonData = null;
    dynamic response = await HTTP.get(sendOTPAPI(mobileNoController.text.toString(),_randomNumber1));
    print(response.statusCode);
    if (response != null && response.statusCode == 200) {
      print("response==============>${response.body.toString()}");
      setState(() {
        isLoading = false;
      });

      jsonData = convert.jsonDecode(response.body);

      OtpResponse otpResponse = OtpResponse.fromJson(jsonData);

      if (otpResponse.status.compareTo("Success") == 0 ) {
        Utility().showToast("OTP Send SuccessFully");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) =>  EnterOTPPage(otp: _randomNumber1, mobile: mobileNoController.text.toString())),
                (Route<dynamic> route) => true);
      } else {
        Utility().showInSnackBar(value: otpResponse.description, context: context);

      }
    }
  }
}
