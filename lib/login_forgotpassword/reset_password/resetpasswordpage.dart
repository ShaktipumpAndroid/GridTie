import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grid_tie/login_forgotpassword/forgot_password/forgot_password_page.dart';
import 'package:grid_tie/login_forgotpassword/reset_password/model/updatepasswordresponse.dart';
import 'package:grid_tie/main.dart';
import 'package:grid_tie/theme/color.dart';
import 'package:grid_tie/theme/string.dart';
import 'package:grid_tie/webservice/APIDirectory.dart';

import 'package:grid_tie/webservice/HTTP.dart' as HTTP;
import 'dart:convert' as convert;
import '../../Util/utility.dart';
import '../../uiwidget/robotoTextWidget.dart';

class ResetPasswordPage extends StatefulWidget {
  String mobileNumber;
   ResetPasswordPage({Key? key, required this.mobileNumber}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ResetPasswordPage> {
  bool isLoading = false, isScreenVisible = false;
  bool isPasswordVisible = false;

  TextEditingController confirmPassController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColor.themeColor,
              elevation: 0,
              title: robotoTextWidget(
                  textval: resetPasswordTitle,
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
                                    robotoTextWidget(
                                        textval: resetPasswordDesc,
                                        colorval: Colors.grey,
                                        sizeval: 12,
                                        fontWeight: FontWeight.w600),
                                    PasswordTextWdget(),
                                    editMobileWidget(),
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
                                                textval: change,
                                                colorval: Colors.white,
                                                sizeval: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Container PasswordTextWdget() {
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
            padding: const EdgeInsets.only(left: 10, top: 5,bottom: 5,right: 5),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
            child: TextField(
              controller: confirmPassController,
              maxLines: 1,
              decoration: InputDecoration(
                  hintText: password,
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
          ),

          Container(
            padding: const EdgeInsets.only(left: 10, top: 5,bottom: 5,right: 5),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
            child: TextField(
              controller: passwordController,

              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                hintText: confimpassword,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(
                          () {
                        isPasswordVisible = !isPasswordVisible;
                      },
                    );
                  },
                ),
                alignLabelWithHint: false,
              ),
              textInputAction: TextInputAction.done,
            ),
          ),
        ],
      ),
    );
  }

  Container editMobileWidget() {
    return Container(
        height: 45,
        margin: const EdgeInsets.all(10),

        child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            robotoTextWidget(textval: editMobile, colorval:  Colors.grey, sizeval: 12, fontWeight: FontWeight.normal),
            SizedBox(
              width: 5,
            ),
            InkWell(
              child: robotoTextWidget(textval: edit, colorval: AppColor.themeColor, sizeval: 12, fontWeight: FontWeight.normal),
              onTap: (){
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => const ForgotPasswordPage()),
                        (Route<dynamic> route) => true);

              },
            ),

          ],
        ) ,
    );
  }
  Future<void> signIn() async {

    Utility().checkInternetConnection().then((connectionResult) {
      if (connectionResult) {
       if (confirmPassController.text
            .toString()
            .isEmpty) {
          Utility()
              .showInSnackBar(value: passwordMessage, context: context);
        }else if (passwordController.text
            .toString()
            .isEmpty) {
          Utility().showInSnackBar(
              value: confirmPasswordMessage, context: context);
        } else if(confirmPassController.text.compareTo(passwordController.text) != 0) {

          Utility().showInSnackBar(
              value: passwordNotMatch, context: context);

        } else{
            updatePassword();
          // loginAPI();
        }
      } else {
        Utility()
            .showInSnackBar(value: checkInternetConnection, context: context);
      }
    });

  }

  Future<void> updatePassword() async {
    setState(() {
      isLoading = true;
    });

    Map data = {
      "mobile": widget.mobileNumber,
      "newPass": passwordController.text.toString()
    };

    print("RegisterInput==============>${data.toString()}");
    var jsonData = null;
    dynamic response = await HTTP.put(updatePasswordApi(),data);
    print(response.statusCode);
    if (response != null && response.statusCode == 200) {
      print("response==============>${response.body.toString()}");
      setState(() {
        isLoading = false;
      });

      jsonData = convert.jsonDecode(response.body);

      UpdatePasswordResponse updatePasswordResponse = UpdatePasswordResponse.fromJson(jsonData);

      if (updatePasswordResponse.status) {
        Utility().showToast(updatePasswordResponse.message);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) =>
                const LoginPage()),
                (Route<dynamic> route) => true);
      } else {
        Utility().showToast(updatePasswordResponse.message);
      }
    }
  }

}