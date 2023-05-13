import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grid_tie/theme/color.dart';
import 'package:grid_tie/theme/string.dart';

import '../../uiwidget/robotoTextWidget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);


  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  bool isSelected=false;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();


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
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/ 4.8,
          left:  MediaQuery.of(context).size.width/3.5),
      width: 150,
      height: 150,

      decoration: const BoxDecoration(

        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      child:  const Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile_images.jpg'),

          )
      )
    );
  }

  profileWidget() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/ 3.5, left: 25,right: 25),
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
      width: MediaQuery.of(context).size.width / 1.2,
      height: MediaQuery.of(context).size.height/6,

      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
                 margin: const EdgeInsets.only(right: 10,top: 10),
                height: 20, width: 20,
                child: SvgPicture.asset("assets/svg/editingIcon.svg"))),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
               robotoTextWidget(textval: 'shakti', colorval: AppColor.themeColor,
                   sizeval: 16, fontWeight: FontWeight.bold),
                robotoTextWidget(textval: 'shaktiPumps@gmail.com', colorval: AppColor.themeColor,
                    sizeval: 12, fontWeight: FontWeight.normal)
              ],
            ),
          )
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
          detailWidget(about,aboutDesc,"assets/svg/aboutIcon.svg"),
          const SizedBox( height: 5,
          ),
          lineWidget(),
          detailWidget(privacyPolicy,privacyPolicyDesc,"assets/svg/privacyIcon.svg"),
          const SizedBox( height: 5,),
          lineWidget(),
          detailWidget(termsConditions,termsConditionsDesc,"assets/svg/termsConditionsIcon.svg"),
          lineWidget(),
          detailWidget(logout,logoutDesc,"assets/svg/logout.svg"),

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

  detailWidget(String title, String description, String svg) {
    return Container(
      width:  MediaQuery.of(context).size.width/ 1,
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
    );
  }


}