import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grid_tie/Util/utility.dart';
import 'package:grid_tie/bottom_navigation/plant/plantdetailwidget.dart';
import 'package:grid_tie/theme/color.dart';
import 'package:grid_tie/theme/string.dart';

import 'package:grid_tie/uiwidget/robotoTextWidget.dart';

import 'home/homepage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool isPasswordVisible = false;
  TextEditingController emailUserNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
           color: AppColor.themeColor
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 80,),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(child: SvgPicture.asset(
                "assets/svg/applogo.svg",
                width: 150,
                height: 150,
              ),),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 60,),
                         Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [BoxShadow(
                                  color: Color.fromRGBO(30, 136, 229, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10)
                              )]
                          ),
                          child: emailPasswordWdget(),
                        ),
                         const SizedBox(height: 40,),
                    GestureDetector(
                      onTap: (){
                         signIn();
                      },
                      child: Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppColor.themeColor
                          ),
                          child:  Center(
                            child: robotoTextWidget(textval: login, colorval:Colors.white, sizeval: 14, fontWeight: FontWeight.bold),),
                          )),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Column emailPasswordWdget() {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200))
          ),
          child:  TextField(
            controller:  emailUserNameController,
            maxLines: 1,
            decoration: InputDecoration(
                hintText: emailUserName,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200))
          ),
          child:  TextField(
            controller:  passwordController,
            maxLines: 1,
            maxLength: 10,
            obscureText:  !isPasswordVisible,
            decoration: InputDecoration(
                hintText: password,
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
      if(connectionResult){
        if(emailUserNameController.text.toString().isEmpty){
          Utility().showInSnackBar(
              value: emailNameValidation,
              context: context);
        }else  if(passwordController.text.toString().isEmpty){
          Utility().showInSnackBar(
              value: passwordValidation,
              context: context);
        }else{
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => const HomePage()),
                  (Route<dynamic> route) => false);
        }

      }else{
        Utility().showInSnackBar(
            value: checkInternetConnection,
            context: context);
      }

    });

   }

}
