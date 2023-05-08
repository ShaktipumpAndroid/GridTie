import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/color.dart';
import '../../theme/string.dart';
import '../../uiwidget/robotoTextWidget.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({Key? key}) : super(key: key);


  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  List<String> alertList = ['Slitting Line 25Kw-2',
    '5.5 Shakti Rooftop','16.5 HO RoofTop'];

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.themeColor,
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.blue.shade800],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [0.2, 0.8],
            ),
          ),
    child: _buildPosts(context)),
    );
  }
  Widget _buildPosts(BuildContext context) {
    if (alertList.isEmpty) {
      return  Center(child: robotoTextWidget(textval: noDataFound,colorval: AppColor.whiteColor,
        sizeval: 18,fontWeight: FontWeight.w600,));
    }
    return InkWell(
        onTap: () {
          //onSelectTripDetailPage(context);
        },
        child: Container(
          margin: EdgeInsets.only(top: 40),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return ListItem(index);
            },
            itemCount: alertList.length,
            padding: const EdgeInsets.all(8),
          ),
        ));
  }

  Card ListItem(int index) {
    return Card(
      color: AppColor.whiteColor,
      elevation: 10,
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape:  const RoundedRectangleBorder(
        side: BorderSide(
          color: AppColor.greyBorder,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child:  Container(
        height: MediaQuery.of(context).size.height/13,
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Stack(
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/svg/solartower.svg',
                    width: 30,
                    height: 30,
                  ),
                  Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child:
                    SvgPicture.asset(
                      'assets/svg/deactivedot.svg',
                      width: 13,
                      height: 13,
                    ),

                  )
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            robotoTextWidget(
              textval: alertList[index],
              colorval: AppColor.blackColor,
              sizeval: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),);
  }


}