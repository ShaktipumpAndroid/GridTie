import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grid_tie/bottom_navigation/alert/alertdetailwidget.dart';
import 'package:grid_tie/webservice/HTTP.dart' as HTTP;
import 'package:grid_tie/webservice/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Util/utility.dart';
import '../../theme/color.dart';
import '../../theme/string.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../webservice/APIDirectory.dart';
import 'model/falultmodel.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({Key? key}) : super(key: key);

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  bool isLoading = false;
  List<Response> alertList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    alertListAPI();
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
        body: RefreshIndicator(
            child: Container(
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
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _buildPosts(context)),
            onRefresh: () {
              return Future.delayed(
                const Duration(seconds: 3),
                () {
                  alertListAPI();
                },
              );
            }));
  }

  Widget _buildPosts(BuildContext context) {
    if (alertList.isEmpty) {
      return NoDataFound();
    }
    return Container(
      margin: EdgeInsets.only(top: 40),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ListItem(index);
        },
        itemCount: alertList.length,
        padding: const EdgeInsets.all(8),
      ),
    );
  }

  Widget ListItem(int index) {
    return Wrap(children: [
      Container(
          child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => AlertDetailsPage(
                              alertList: alertList[index],
                            )),
                    (Route<dynamic> route) => true);
              },
              child: Card(
                  color: AppColor.whiteColor,
                  elevation: 10,
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(
                      color: AppColor.greyBorder,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: Stack(children: <Widget>[
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
                                child: loadSVG('assets/svg/deactivedot.svg'),
                              )
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Stack(
                            children: <Widget>[
                              faultDetail(index),
                            ],
                          ),
                        ),

                        /* Align(
              alignment: Alignment.centerRight,
              child: Stack(
                children: <Widget>[
                 Icon(Icons.arrow_forward_ios_rounded,color: AppColor.grey,size: 15,)
                ],
              ),
            )*/
                      ])))))
    ]);
  }

  Future<void> alertListAPI() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    dynamic res = await HTTP
        .get(getFaultList(sharedPreferences.getString(userID).toString()));
    var jsonData = null;
    if (res != null && res.statusCode != null && res.statusCode == 200) {
      jsonData = convert.jsonDecode(res.body);
      FaultListModel alertListModel = FaultListModel.fromJson(jsonData);
      if (alertListModel.status.toString() == 'true') {
        alertList = alertListModel.response;
      }
      setState(() {
        isLoading = false;
      });
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  SvgPicture loadSVG(String svg) {
    return SvgPicture.asset(
      svg,
      width: 13,
      height: 13,
    );
  }

  SizedBox NoDataFound() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
          child: Container(
        height: MediaQuery.of(context).size.height / 10,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromRGBO(30, 136, 229, .5),
                  blurRadius: 20,
                  offset: Offset(0, 10))
            ]),
        child: Align(
          alignment: Alignment.center,
          child: robotoTextWidget(
              textval: noDataFound,
              colorval: AppColor.themeColor,
              sizeval: 14,
              fontWeight: FontWeight.bold),
        ),
      )),
    );
  }

  Container faultDetail(int index) {
    return Container(
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width / 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: robotoTextWidget(
                    textval: alertList[index].faultName.toString(),
                    colorval: AppColor.themeColor,
                    sizeval: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                robotoTextWidget(
                  textval:
                      '${Utility().changeDateFormate(alertList[index].date.toString())}',
                  colorval: AppColor.blackColor,
                  sizeval: 11.0,
                  fontWeight: FontWeight.normal,
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          robotoTextWidget(
            textval: 'Device No:- ${alertList[index].deviceNo}',
            colorval: AppColor.blackColor,
            sizeval: 12.0,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }
}
