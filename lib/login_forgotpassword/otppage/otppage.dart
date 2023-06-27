import 'package:flutter/material.dart';
import 'package:grid_tie/login_forgotpassword/reset_password/resetpasswordpage.dart';
import 'package:grid_tie/theme/color.dart';
import 'package:grid_tie/theme/string.dart';

import '../../Util/utility.dart';
import '../../uiwidget/robotoTextWidget.dart';

class EnterOTPPage extends StatefulWidget {
  const EnterOTPPage({Key? key}) : super(key: key);

  @override
  State<EnterOTPPage> createState() => _EnterOTPPageState();
}

class _EnterOTPPageState extends State<EnterOTPPage> {
  bool isLoading = false, isScreenVisible = false;
  bool isPasswordVisible = false;

  TextEditingController otpController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor:  AppColor.themeColor,
            elevation: 0,
            title:  robotoTextWidget(textval: enterOtp, colorval: AppColor.whiteColor, sizeval: 15, fontWeight: FontWeight.w800)),
        body: SizedBox(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: AppColor.themeColor),
            child: Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                        child: robotoTextWidget(textval: verfiyOTP, colorval: AppColor.whiteColor, sizeval: 16, fontWeight: FontWeight.w400)
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60))),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 60,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Color.fromRGBO(30, 136, 229, .3),
                                          blurRadius: 20,
                                          offset: Offset(0, 10))
                                    ]),
                                child: MobileTextWdget(),
                              ),

                              SizedBox(height: 10,),
                              const SizedBox(
                                height: 40,
                              ),
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
                                          textval: verify,
                                          colorval: Colors.white,
                                          sizeval: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),


                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),

            ],),
          ),
        ));
  }

  Column MobileTextWdget() {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 10, top: 5,bottom: 5,right: 5),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
          child: TextField(
            controller: otpController,
            decoration: InputDecoration(
                hintText: enterOtp,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),
        ),

      ],
    );
  }

  Future<void> signIn() async {

    Utility().checkInternetConnection().then((connectionResult) {
      if (connectionResult) {
        if (otpController.text
            .toString()
            .isEmpty) {
          Utility()
              .showInSnackBar(value: otpMessage, context: context);
        } else{
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => const ResetPasswordPage()),
                  (Route<dynamic> route) => true);
          // loginAPI();
        }
      } else {
        Utility()
            .showInSnackBar(value: checkInternetConnection, context: context);
      }
    });

  }

}