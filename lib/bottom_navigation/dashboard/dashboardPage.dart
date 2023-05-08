import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grid_tie/theme/color.dart';
import 'package:grid_tie/uiwidget/robotoTextWidget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../Util/utility.dart';
import '../../theme/string.dart';
import 'model/chartdata.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scaffoldKey = GlobalKey();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  final List<ChartData> chartData = [
    ChartData('David', 75, AppColor.blue.shade300),
    ChartData('David', 25, AppColor.themeColor),
  ];

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
          const robotoTextWidget(
              textval: '18.0387',
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
      height: MediaQuery.of(context).size.height / 5,
      child: SfCircularChart(series: <CircularSeries>[
        // Render pie chart
        PieSeries<ChartData, String>(
          dataSource: chartData,
          pointColorMapper: (ChartData data, _) => data.color,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          dataLabelMapper: (ChartData data, _) => data.x,

          //  dataLabelSettings: const DataLabelSettings(isVisible: true)
        )
      ]),
    );
  }

  Align dailyRevenueWidget() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 8.5,
        margin: const EdgeInsets.only(top: 90, left: 20, right: 20, bottom: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromRGBO(30, 136, 229, .5),
                  blurRadius: 20,
                  offset: Offset(0, 10))
            ]),
        child: Row(
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
                  margin: const EdgeInsets.only(top: 5, left: 20),
                  child: const Align(
                    alignment: Alignment.topLeft,
                    child: robotoTextWidget(
                        textval: '18.0387',
                        colorval: Colors.black,
                        sizeval: 35,
                        fontWeight: FontWeight.normal),
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(right: 20),
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
      ),
    );
  }

  Align plantDetailWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: <Widget>[
                    robotoTextWidget(
                        textval: totalEnergy,
                        colorval: AppColor.blue,
                        sizeval: 14,
                        fontWeight: FontWeight.bold),
                    const SizedBox(
                      height: 5,
                    ),
                    const robotoTextWidget(
                        textval: '198.28 kWh',
                        colorval: Colors.black,
                        sizeval: 22,
                        fontWeight: FontWeight.normal),
                  ],
                ),
                Container(
                  width: 1,
                  height: MediaQuery.of(context).size.height / 8,
                  color: AppColor.grey,
                ),
                Column(
                  children: <Widget>[
                    robotoTextWidget(
                        textval: totalIncome,
                        colorval: AppColor.blue,
                        sizeval: 14,
                        fontWeight: FontWeight.bold),
                    const SizedBox(
                      height: 5,
                    ),
                    const robotoTextWidget(
                        textval: '3978.78 USD',
                        colorval: Colors.black,
                        sizeval: 22,
                        fontWeight: FontWeight.normal),
                  ],
                )
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
                Column(
                  children: <Widget>[
                    robotoTextWidget(
                        textval: activePlants,
                        colorval: AppColor.blue,
                        sizeval: 14,
                        fontWeight: FontWeight.bold),
                    const SizedBox(
                      height: 5,
                    ),
                    const robotoTextWidget(
                        textval: '20',
                        colorval: Colors.black,
                        sizeval: 22,
                        fontWeight: FontWeight.normal),
                  ],
                ),
                Container(
                  width: 1,
                  height: MediaQuery.of(context).size.height / 8,
                  color: AppColor.grey,
                ),
                Column(
                  children: <Widget>[
                    robotoTextWidget(
                        textval: carbonOffset,
                        colorval: AppColor.blue,
                        sizeval: 14,
                        fontWeight: FontWeight.bold),
                    const SizedBox(
                      height: 5,
                    ),
                    const robotoTextWidget(
                        textval: '19.83 Ton',
                        colorval: Colors.black,
                        sizeval: 22,
                        fontWeight: FontWeight.normal),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
