import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grid_tie/bottom_navigation/plant/device/devicePage.dart';
import 'package:grid_tie/bottom_navigation/plant/model/globleModel.dart';
import 'package:grid_tie/bottom_navigation/plant/model/plantlistmodel.dart';
import 'package:grid_tie/chartwidgets/chartwidget.dart';
import 'package:grid_tie/webservice/HTTP.dart' as HTTP;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Util/utility.dart';
import '../../theme/color.dart';
import '../../theme/string.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../webservice/APIDirectory.dart';
import '../../webservice/constant.dart';
import 'add_plant_page.dart';

class PlantPage extends StatefulWidget {
  const PlantPage({Key? key}) : super(key: key);

  @override
  State<PlantPage> createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage>with WidgetsBindingObserver {
  bool isLoading = false;
  List<Response> plantList = [];
  late int selectedIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     retrievePlantList();
  }


  void retrievePlantList() {
    Utility().checkInternetConnection().then((connectionResult) {
      if (connectionResult) {
        plantListAPI();
      }else {
        Utility()
            .showInSnackBar(value: checkInternetConnection, context: context);
      }
    });
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
                  retrievePlantList();
                },
              );
            }),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder:(context)=> AddPlantPage(isRegister: false,)))
                .then((value)=>{ plantListAPI()});
          },
          label: robotoTextWidget(
              textval: addPlant,
              colorval: AppColor.whiteColor,
              sizeval: 12,
              fontWeight: FontWeight.bold),
          icon: const Icon(Icons.add),
          backgroundColor: AppColor.themeColor,
        ));
  }

  Widget _buildPosts(BuildContext context) {
    if (plantList.isEmpty) {
      return NoDataFound();
    }
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ListItem(index);
        },
        itemCount: plantList.length,
        padding: const EdgeInsets.all(8),
      ),
    );
  }

  Wrap ListItem(int index) {
    return Wrap(children: [
      Card(
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
          child: Stack(
            children: [
              Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(right: 150),
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
                        Flexible(
                            child: robotoTextWidget(
                          textval: plantList[index].plantName,
                          colorval: AppColor.blackColor,
                          sizeval: 14.0,
                          fontWeight: FontWeight.w600,
                        )),
                      ],
                    ),
                  ])),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(top: 10, right: 10, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ChartWidget(
                                          deviceId:
                                              plantList[index].pid.toString(),
                                          isPlant: true)),
                              (Route<dynamic> route) => true);
                        },
                        child:
                            IconWidget('assets/svg/plantreports.svg', reports),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (BuildContext context) => DevicePage(
                                      plantId:
                                          plantList[index].pid.toString())),
                              (Route<dynamic> route) => true);
                        },
                        child:
                            IconWidget('assets/svg/solardevice.svg', devices),
                      ),
                      GestureDetector(
                        onTap: () {
                          selectedIndex = index;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                dialogue_removePlant(context),
                          );
                        },
                        child: IconWidget('assets/svg/delete.svg', deletePlant),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),),
    ]);
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
          margin: const EdgeInsets.only(left: 20, right: 20),
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

  SizedBox IconWidget(String svg, String txt) {
    return SizedBox(
      width: 50,
      child: Column(
        children: [
          SvgPicture.asset(
            svg,
            width: 30,
            height: 30,
          ),
          const SizedBox(
            height: 5,
          ),
          robotoTextWidget(
              textval: txt,
              colorval: Colors.black,
              sizeval: 10,
              fontWeight: FontWeight.w400)
        ],
      ),
    );
  }

  Widget dialogue_removePlant(BuildContext context) {
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
              removePlantConfirmation,
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
                      Navigator.of(context).pop();

                     removePlantAPI();
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

  Future<void> removePlantAPI() async {
    dynamic res = await HTTP.get(removePlant(plantList[selectedIndex].pid));
    var jsonData = null;
    if (res != null && res.statusCode != null && res.statusCode == 200) {
      jsonData = convert.jsonDecode(res.body);
      print("jsonData====>$jsonData");
      GlobleModel globleModel = GlobleModel.fromJson(jsonData);
      if (globleModel.status.toString() == 'true') {
        setState(() {
          plantList.removeAt(selectedIndex);
        });
        Utility().showInSnackBar(value: plantDeleted,context: context);
      }
    }
  }
}
