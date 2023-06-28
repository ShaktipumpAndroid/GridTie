import 'package:flutter/material.dart';
import 'package:grid_tie/Util/utility.dart';
import 'package:grid_tie/main.dart';

import 'package:grid_tie/webservice/HTTP.dart' as HTTP;
import 'dart:convert' as convert;
import 'package:grid_tie/theme/color.dart';
import 'package:grid_tie/uiwidget/robotoTextWidget.dart';
import 'package:grid_tie/webservice/APIDirectory.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/string.dart';
import '../webservice/constant.dart';
import 'model/registeruserresponse.dart';

class RegisterUserPage extends StatefulWidget {
  const RegisterUserPage({Key? key}) : super(key: key);

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  bool isPasswordVisible = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  var isLoading = false;

  @override
  void initState() {
    //    TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColor.themeColor,
          elevation: 0,
          title: robotoTextWidget(
              textval: registerTitle,
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
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 10),
                    child: Center(
                      child: Icon(
                        Icons.account_circle, color: AppColor.whiteColor,
                        size: 60,),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 2,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60))),
                      child: SingleChildScrollView(
                        child: Container(
                          margin: const EdgeInsets.only(top: 25),
                          child: Column(
                            children: [
                              robotoTextWidget(
                                  textval: registerDec,
                                  colorval: Colors.grey,
                                  sizeval: 12,
                                  fontWeight: FontWeight.w600),
                              RegisterTextWidget(),

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
                                        ? const SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(
                                        color: AppColor.whiteColor,
                                      ),
                                    )
                                        : robotoTextWidget(
                                        textval: submit,
                                        colorval: Colors.white,
                                        sizeval: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container RegisterTextWidget() {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
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
                      Icons.account_circle_outlined,
                      color: AppColor.themeColor,
                      size: 20,
                    ),
                  ),

                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: TextField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                          hintText: firstName,
                          hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.normal),
                          border: InputBorder.none),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                    ),
                  )
                ],
              ),
            ),

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
                      Icons.account_circle_outlined,
                      color: AppColor.themeColor,
                      size: 20,
                    ),
                  ),

                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: TextField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                          hintText: lastName,
                          hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.normal),
                          border: InputBorder.none),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                    ),
                  )
                ],
              ),
            ),

            Container(
              padding:
              const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 5),
              decoration: BoxDecoration(
                  border:
                  Border(bottom: BorderSide(color: Colors.grey.shade200))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.account_circle_outlined,
                      color: AppColor.themeColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                          hintText: username,
                          hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.normal),
                          border: InputBorder.none),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                    ),
                  )
                ],
              ),
            ),

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
                      Icons.email_outlined,
                      color: AppColor.themeColor,
                      size: 20,
                    ),
                  ),

                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: email,
                          hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.normal),
                          border: InputBorder.none),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                    ),
                  )
                ],
              ),
            ),

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
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                    ),
                  )
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.only(
                  left: 10, top: 5, bottom: 5, right: 5),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.account_circle_outlined,
                      color: AppColor.themeColor,
                      size: 20,
                    ),
                  ),

                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: TextField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: passwordMessage,
                        hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.normal),
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
                  )
                ],
              ),
            ),

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
                      Icons.home,
                      color: AppColor.themeColor,
                      size: 20,
                    ),
                  ),

                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                          hintText: homeAddress,
                          hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.normal),
                          border: InputBorder.none),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                    ),
                  )
                ],
              ),
            )

          ],
        ));
  }

  Future<void> signIn() async {

    Utility().checkInternetConnection().then((connectionResult) {
      if (connectionResult) {
        if (firstNameController.text
            .toString()
            .isEmpty) {
          Utility()
              .showInSnackBar(value: firstName, context: context);
        } else if (lastNameController.text
            .toString()
            .isEmpty) {
          Utility().showInSnackBar(
              value: lastName, context: context);
        } else if (usernameController.text
            .toString()
            .isEmpty) {
          Utility().showInSnackBar(
              value: username, context: context);
        } else if (emailController.text
            .toString()
            .isEmpty) {
          Utility().showInSnackBar(
              value: email, context: context);
        } else if (!emailController.text.toString().contains('@') && !emailController.text.toString().contains('.com')){
          Utility().showInSnackBar(
              value: emailVaildation, context: context);
        }else if (mobileNoController.text
            .toString()
            .isEmpty) {
          Utility().showInSnackBar(
              value: mobileNumber, context: context);
        }else if (mobileNoController.text
            .toString().length != 10) {
          Utility().showInSnackBar(
              value: invaildMobileNo, context: context);
        } else if (passwordController.text
            .toString()
            .isEmpty) {
          Utility().showInSnackBar(
              value: passwordMessage, context: context);
        } else if (addressController.text
            .toString()
            .isEmpty) {
          Utility().showInSnackBar(
              value: homeAddress, context: context);
        } else {
          print("Value===>${usernameController.text
              .toString()} , ${passwordController.text
              .toString()} , ${mobileNoController.text
              .toString()} , ${emailController.text.toString()} "
              ", ${firstNameController.text.toString()}  , ${lastNameController
              .text.toString()} , ${addressController.text.toString()}");

          registerNewUser();
          // loginAPI();

        }
      } else {
        Utility()
            .showInSnackBar(value: checkInternetConnection, context: context);
      }
    });
  }

  Future<void> registerNewUser() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Map data = {
      "userId": 0,
      "userName": usernameController.text.toString(),
      "userPass": passwordController.text.toString(),
      "email": emailController.text.toString(),
      "mobile": mobileNoController.text.toString(),
      "firstName": firstNameController.text.toString(),
      "middleName": "",
      "lastName": lastNameController.text.toString(),
      "address": addressController.text.toString(),
      "roleId": 3,
      "createdBy": "users"
    };
    print("RegisterInput==============>${data.toString()}");
    var jsonData = null;
    dynamic response = await HTTP.post(registerUserApi(),data);
    print(response.statusCode);
    if (response != null && response.statusCode == 200) {
      print("response==============>${response.body.toString()}");
      setState(() {
        isLoading = false;
      });

      jsonData = convert.jsonDecode(response.body);

      RegisterUserResponse registerUserResponse = RegisterUserResponse.fromJson(jsonData);

      if (registerUserResponse.status) {
        Utility().showToast("New User registered SuccessFully");

        sharedPreferences.setString(
            userID, registerUserResponse.response!.userId.toString());
        sharedPreferences.setString(
            userName, registerUserResponse.response!.userName.toString());
        sharedPreferences.setString(
            userEmail, registerUserResponse.response!.email.toString());
        sharedPreferences.setString(
            userMobile, registerUserResponse.response!.mobile.toString());
        sharedPreferences.setString(
            userRoleId, registerUserResponse.response!.roleId.toString());

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) =>
                const LoginPage()),
                (Route<dynamic> route) => true);
      } else {
        Utility().showToast(registerUserResponse.message);
      }
    }
  }

}