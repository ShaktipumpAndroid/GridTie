import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grid_tie/bottom_navigation/dashboard/model/dashboardModel.dart';
import 'package:grid_tie/theme/color.dart';
import 'package:grid_tie/uiwidget/robotoTextWidget.dart';
import 'package:grid_tie/webservice/HTTP.dart' as HTTP;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../Util/utility.dart';
import '../../theme/string.dart';
import '../../webservice/APIDirectory.dart';
import '../../webservice/constant.dart';
import '../../chartwidgets/model/chartdata.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late GlobalKey<ScaffoldState> _scaffoldKey;
  bool isLoading = false;
  String? currentPowerTxt = "0",
      totalEnergyTxt = "0",
      totalIncomeTxt = "0",
      activePlantTxt = "0",
      dailyRevenueTxt = "0",
      totalCapacityTxt = "0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scaffoldKey = GlobalKey();
    dashBoardAPI();

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
              color: AppColor.whiteColor,
              child: Stack(children: <Widget>[
                currentPowerWidget(),
                dailyRevenueWidget(),
                plantDetailWidget(),
                ListView()
                // this list view is not used anywhere its just used for refresh indicator
              ]),
            ),
            onRefresh: () {
              return Future.delayed(
                const Duration(seconds: 3),
                () {
                  Utility()
                      .showInSnackBar(value: pageRefreshed, context: context);
                },
              );
            }));
  }

  Container currentPowerWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,
      decoration: const BoxDecoration(
          color: AppColor.themeColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
      child: Column(
        children: [
          pieChartWidget(),
          robotoTextWidget(
              textval: currentPowerTxt.toString(),
              colorval: AppColor.whiteColor,
              sizeval: 40,
              fontWeight: FontWeight.bold),
          robotoTextWidget(
              textval: currentPower,
              colorval: AppColor.whiteColor,
              sizeval: 16,
              fontWeight: FontWeight.bold),
        ],
      ),
    );
  }

  Container pieChartWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 70),
      height: MediaQuery.of(context).size.height / 8,
      child: Container() /*SfCircularChart(series: <CircularSeries>[
        // Render pie chart
        PieSeries<ChartData, String>(
          dataSource: chartData,
          pointColorMapper: (ChartData data, _) => data.color,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          dataLabelMapper: (ChartData data, _) => data.x,

          // dataLabelSettings: const DataLabelSettings(isVisible: true)
        )
      ]),*/
    );
  }

  Align dailyRevenueWidget() {
    return Align(
      alignment: Alignment.center,
      child: Wrap(
        children: [
          Container(
            margin:
                const EdgeInsets.only(top: 90, left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromRGBO(30, 136, 229, .5),
                      blurRadius: 20,
                      offset: Offset(0, 10))
                ]),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 20, left: 20),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: robotoTextWidget(
                            textval: dailyRevenue,
                            colorval: Colors.blue,
                            sizeval: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin:
                      const EdgeInsets.only(top: 5, left: 20, bottom: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: robotoTextWidget(
                            textval: dailyRevenueTxt.toString(),
                            colorval: Colors.black,
                            sizeval: 25,
                            fontWeight: FontWeight.normal),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20, top: 10),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: SvgPicture.asset(
                      'assets/svg/solar_panels.svg',
                      width: 50,
                      height: 80,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Align plantDetailWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 3,
        margin: EdgeInsets.only(left: 10,right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                detailBoxWidget(totalEnergy, totalEnergyTxt.toString()),
                lineWidget(),
                detailBoxWidget(totalIncome, totalIncomeTxt.toString()),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(20),
              height: 1,
              color: AppColor.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                detailBoxWidget(activePlants, activePlantTxt.toString()),
                lineWidget(),
                detailBoxWidget(totalCapacity, totalCapacityTxt.toString()),
              ],
            )
          ],
        ),
      ),
    );
  }


  SizedBox detailBoxWidget(String title, String value) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          robotoTextWidget(
              textval: title,
              colorval: AppColor.blue,
              sizeval: 14,
              fontWeight: FontWeight.bold),
          const SizedBox(
            height: 5,
          ),
          robotoTextWidget(
              textval: value,
              colorval: Colors.black,
              sizeval: 16,
              fontWeight: FontWeight.normal),
        ],
      ),
    );
  }


  Container lineWidget() {
    return Container(
      width: 1,
      height: MediaQuery.of(context).size.height / 8,
      color: AppColor.grey,
    );
  }

  Future<void> dashBoardAPI() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    dynamic res = await HTTP.get(
        getDashboardDetails(sharedPreferences.getString(userID).toString()));
    var jsonData = null;
    if (res != null && res.statusCode != null && res.statusCode == 200) {
      jsonData = convert.jsonDecode(res.body);
      DashboardModel dashboardModel = DashboardModel.fromJson(jsonData);
      if (dashboardModel.status.toString() == 'true') {
        currentPowerTxt =
            '${dashboardModel.response.currentPower.toStringAsFixed(2)} kWh';
        totalEnergyTxt =
            '${dashboardModel.response.totalEnergy.toStringAsFixed(2)} kWh';

        activePlantTxt = dashboardModel.response.onlinePlant.toString();

        totalCapacityTxt =
        '${dashboardModel.response.totalCapacity.toStringAsFixed(2)} kWh';

        totalIncomeTxt =
            '${Utility().calculateRevenue(dashboardModel.response.totalEnergy.toString()).toString()} INR';


        dailyRevenueTxt =
            '${Utility().calculateRevenue(dashboardModel.response.todayEnergy.toString()).toString()} INR';
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


}
