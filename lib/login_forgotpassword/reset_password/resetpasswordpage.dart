import 'package:flutter/material.dart';
import 'package:grid_tie/theme/color.dart';
import 'package:grid_tie/theme/string.dart';

import '../../Util/utility.dart';
import '../../uiwidget/robotoTextWidget.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ResetPasswordPage> {
  bool isLoading = false, isScreenVisible = false;
  bool isPasswordVisible = false;
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor:  AppColor.themeColor,
            elevation: 0,
            title:  robotoTextWidget(textval: forgotPasswordTitle, colorval: AppColor.whiteColor, sizeval: 15, fontWeight: FontWeight.w800)),
        body: SizedBox(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: AppColor.themeColor),
            child: Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                        child: robotoTextWidget(textval: forgotPasswordTitle, colorval: AppColor.whiteColor, sizeval: 15, fontWeight: FontWeight.w400)
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
                                child: PasswordTextWdget(),
                              ),

                              const SizedBox(height: 10,),
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
                                          textval: change,
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

  Column PasswordTextWdget() {
    return Column(
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
    );
  }

  Future<void> signIn() async {

    Utility().checkInternetConnection().then((connectionResult) {
      if (connectionResult) {
        if (mobileNoController.text
            .toString()
            .isEmpty) {
          Utility()
              .showInSnackBar(value: mobileNoMessage, context: context);
        } else if (confirmPassController.text
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
          // loginAPI();
        }
      } else {
        Utility()
            .showInSnackBar(value: checkInternetConnection, context: context);
      }
    });

  }

}