import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grid_tie/Util/utility.dart';
import 'package:grid_tie/main.dart';
import 'package:grid_tie/theme/color.dart';
import 'package:grid_tie/theme/string.dart';
import 'package:grid_tie/webservice/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../uiwidget/robotoTextWidget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);


  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  bool isSelected=false;
   String UserName ="",UserEmail="";
  late SharedPreferences sharedPreferences;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserDetails();
  }


  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300 ,
      body: Stack(
        children: [
          headingWidget(),
          profileWidget(),
          pictureWidget(),

        ],
      ),
    );

  }

  headingWidget() {
    return  Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.37,
      decoration: const BoxDecoration(
        color: AppColor.themeColor,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35) ,bottomRight: Radius.circular(35)),
      ),
      child: Container(
        margin: EdgeInsets.only(left: 20, top: MediaQuery.of(context).size.height * 0.15),
        child: const Text("Profile" ,
          style:  TextStyle(fontSize: 30 , color: Colors.white),
        ),
      ),
    );
  }

  pictureWidget() {
    return  Align(alignment: Alignment.center,
    child: Container(
        width: 150,
        height: 150,

        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height/3),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        child:  const Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100)),),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile_images.jpg',),

            )
        )
    ),);
  }

  profileWidget() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/ 3.5, left: 20,right: 20),
      width: MediaQuery.of(context).size.width ,
      height: MediaQuery.of(context).size.height/1.7,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all( Radius.circular(10) ),
      ),
      child: Card(
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all( Radius.circular(10)),
        ),
        child: Column(
          children: [
            personalDetails(),
            optionWidget(),
          ],
        ),
      ),
    );
  }

  personalDetails() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height/6,

      child: Column(
        children: [

           Center( child:  Container(
             margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/10),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.end,
               children:  [
                 robotoTextWidget(textval: UserName, colorval: AppColor.themeColor,
                     sizeval: 16, fontWeight: FontWeight.bold),
                 robotoTextWidget(textval:UserEmail, colorval: AppColor.themeColor,
                     sizeval: 12, fontWeight: FontWeight.normal)
               ],
             ),
           ),)
        ],
      ),
    );
  }

  optionWidget() {
    return Container(
      margin: EdgeInsets.only(top:  MediaQuery.of(context).size.height/80),
      height: MediaQuery.of(context).size.height/ 3,
      width:  MediaQuery.of(context).size.width/ 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           lineWidget(),
          detailWidget(about,aboutDesc,"assets/svg/aboutIcon.svg",aboutUSUrl),
          const SizedBox( height: 5,
          ),
          lineWidget(),
          detailWidget(privacyPolicy,privacyPolicyDesc,"assets/svg/privacyIcon.svg",privacyPolicyUrl),
          const SizedBox( height: 5,),
          lineWidget(),
          detailWidget(termsConditions,termsConditionsDesc,"assets/svg/termsConditionsIcon.svg",termsConditionUrl),
          lineWidget(),
          detailWidget(logout,logoutDesc,"assets/svg/logout.svg",""),

        ],
      ),
    );
  }

  lineWidget() {
   return Container( decoration: BoxDecoration(
      border: Border( bottom: BorderSide(
        color: Colors.grey.shade200,
        width: 1,
      ),),
    ),);
  }

  detailWidget(String title, String description, String svg, String url) {
    return InkWell(
      onTap: (){
        if(url.isNotEmpty){
          launchUrl(
            Uri.parse(url),
            mode: LaunchMode.externalApplication,
          );
        }else{
          if(title==logout){
            showDialog(
              context: context,
              builder: (BuildContext context) => dialogueLogout(context),
            );
          }
        }
      },
      child: Container(
        width:  MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/13,
        margin: const EdgeInsets.only(right: 10,left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(svg,width: 20,height: 20,),
                const SizedBox(width: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    robotoTextWidget(textval:title, colorval: AppColor.darkGrey, sizeval: 15, fontWeight: FontWeight.bold),
                    robotoTextWidget(textval:description, colorval: AppColor.darkGrey, sizeval: 10, fontWeight: FontWeight.normal)
                  ],
                ),
              ],
            ),

            const Icon( Icons.arrow_forward_ios_rounded , size: 20, color: AppColor.darkGrey,),
          ],
        ),
      ),
    );
  }

  Widget dialogueLogout(BuildContext context) {
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
              logoutConfirmation,
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
                     confirmLogout(context);
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
  Future<void> confirmLogout(BuildContext context) async {
    Utility().showToast("Logout SuccessFully");
    sharedPreferences.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage()),
            (Route<dynamic> route) => false);
  }

  Future<void> getuserDetails() async {
     sharedPreferences = await SharedPreferences.getInstance();

     setState(() {
       UserName = sharedPreferences.getString(userName).toString();
       UserEmail = sharedPreferences.getString(userEmail).toString();
     });
  }

}