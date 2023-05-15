import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grid_tie/webservice/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:grid_tie/webservice/HTTP.dart'as HTTP;
import 'dart:convert' as convert;
import '../../theme/color.dart';
import '../../theme/string.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../webservice/APIDirectory.dart';
import '../plant/model/plantlistmodel.dart';
import '../plant/plantdetailwidget.dart';

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
        body:RefreshIndicator(
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
                child:isLoading
                    ? const Center(
                  child: CircularProgressIndicator(),
                ) : _buildPosts(context)),
            onRefresh: () {
              return Future.delayed(
                const Duration(seconds: 3), () {
                alertListAPI();
              },
              );
            }));
  }

  Widget _buildPosts(BuildContext context) {
    if (alertList.isEmpty) {
      return Center(
          child: robotoTextWidget(
            textval: noDataFound,
            colorval: AppColor.whiteColor,
            sizeval: 18,
            fontWeight: FontWeight.w600,
          ));
    }
    return InkWell(
        onTap: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => const PlantDetailPage()),
                  (Route<dynamic> route) => true);
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

  Widget ListItem(int index) {
    return alertList[index].status==false?Card(
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
        height: MediaQuery.of(context).size.height / 13,
        padding: const EdgeInsets.all(10),
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
                    child: alertList[index].status==false?loadSVG('assets/svg/deactivedot.svg'):loadSVG('assets/svg/deactivedot.svg'),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            robotoTextWidget(
              textval: alertList[index].plantName,
              colorval: AppColor.blackColor,
              sizeval: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    ):const SizedBox(height: 0,width: 0,);
  }

  Future<void> alertListAPI() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    dynamic res = await HTTP.get(getPlantList(sharedPreferences.getString(userID).toString()));
    var jsonData = null;
    if (res != null && res.statusCode != null && res.statusCode == 200) {
      jsonData = convert.jsonDecode(res.body);
      PlantListModel alertListModel = PlantListModel.fromJson(jsonData);
      if(alertListModel.status.toString()=='true'){
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

  SvgPicture loadSVG(String svg){
    return SvgPicture.asset(
      svg,
      width: 13,
      height: 13,
    );
  }


}