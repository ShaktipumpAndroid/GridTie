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
  bool isPasswordVisible = false;
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
                fontWeight: FontWeight.w800)),
        body: SizedBox(
          child: Container(
            width: double.infinity,

            decoration: const BoxDecoration(color: AppColor.themeColor),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          child: Container(
                            margin: const EdgeInsets.only(top: 80),
                            child: Column(
                              children: [
                                robotoTextWidget(
                                    textval: mobileNumberDesc,
                                    colorval: Colors.grey,
                                    sizeval: 12,
                                    fontWeight: FontWeight.w600),
                                MobileTextWdget(),


                                GestureDetector(
                                    onTap: () {
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
                                            ? Container(
                                          height: 30,
                                          width: 30,
                                          child: const CircularProgressIndicator(
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
                          )),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Container MobileTextWdget() {
    return Container(
        margin: const EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 35),
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
                      primary: AppColor.whiteColor,
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
                      confirmotp(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppColor.themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    child: robotoTextWidget(
                      textval: confirm,
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
    Utility().showToast("OTP Send SuccessFully");

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => const EnterOTPPage()),
        (Route<dynamic> route) => true);
  }
}
