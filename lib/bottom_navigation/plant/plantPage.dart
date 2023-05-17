import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grid_tie/bottom_navigation/plant/model/plantlistmodel.dart';
import 'package:grid_tie/bottom_navigation/plant/plantdetailwidget.dart';
import 'package:grid_tie/webservice/HTTP.dart' as HTTP;
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/color.dart';
import '../../theme/string.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../webservice/APIDirectory.dart';
import '../../webservice/constant.dart';

class PlantPage extends StatefulWidget {
  const PlantPage({Key? key}) : super(key: key);

  @override
  State<PlantPage> createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  bool isLoading = false;
  List<Response> plantList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    plantListAPI();
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
                  plantListAPI();
                },
              );
            }));
  }

  Widget _buildPosts(BuildContext context) {
    if (plantList.isEmpty) {
      return NoDataFound();
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
            itemCount: plantList.length,
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
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          color: AppColor.greyBorder,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
          height: MediaQuery.of(context).size.height / 13,
          padding: const EdgeInsets.all(10),
          child: Stack(children: <Widget>[
            Row(
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
                        child: plantList[index].status == true
                            ? loadSVG('assets/svg/activedot.svg')
                            : loadSVG('assets/svg/deactivedot.svg'),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                robotoTextWidget(
                  textval: plantList[index].plantName,
                  colorval: AppColor.blackColor,
                  sizeval: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Stack(
                children: const <Widget>[
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColor.grey,
                    size: 15,
                  )
                ],
              ),
            )
          ])),
    );
  }

  Future<void> plantListAPI() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    dynamic res = await HTTP
        .get(getPlantList(sharedPreferences.getString(userID).toString()));
    var jsonData = null;
    if (res != null && res.statusCode != null && res.statusCode == 200) {
      jsonData = convert.jsonDecode(res.body);
      PlantListModel plantListModel = PlantListModel.fromJson(jsonData);
      if (plantListModel.status.toString() == 'true') {
        plantList = plantListModel.response;
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

  Widget loadSVG(String svg) {
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
        )));
  }
}
