import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grid_tie/theme/color.dart';
import 'package:grid_tie/uiwidget/robotoTextWidget.dart';
import '../../theme/string.dart';
import '../../chartwidgets/chartwidget.dart';

class PlantDetailPage extends StatefulWidget {
  const PlantDetailPage({Key? key}) : super(key: key);

  @override
  State<PlantDetailPage> createState() => _PlantDetailPageState();
}

class _PlantDetailPageState extends State<PlantDetailPage> {

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ChartWidget(),
            plantDetailWidget(),
            solarHouseDetailWidget(),
          ]),
    ));
  }

  SizedBox solarHouseDetailWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3,
      child: Stack(children: <Widget>[
        SvgPicture.asset(
          'assets/svg/solarhouseplant.svg',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3,

        ),
        Container(
          margin: EdgeInsets.only(bottom: 20,left: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                robotoTextWidget(
                    textval: 'Capacity:- 25.0 kwp',
                    colorval: Colors.greenAccent,
                    sizeval: 18,
                    fontWeight: FontWeight.w600),
                robotoTextWidget(
                    textval: 'Creation Time:- 2022-10-27',
                    colorval:  Colors.greenAccent,
                    sizeval: 18,
                    fontWeight: FontWeight.w600),
                robotoTextWidget(
                    textval: 'Address:- India, Sector 3, Pithampur',
                    colorval:  Colors.greenAccent,
                    sizeval: 18,
                    fontWeight: FontWeight.w600)
              ]),
        )
      ]),
    );
  }

  SizedBox plantDetailWidget() {
    return  SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 4.5,
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
                  height: MediaQuery.of(context).size.height / 12,
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
                        textval: peakPower,
                        colorval: AppColor.blue,
                        sizeval: 14,
                        fontWeight: FontWeight.bold),
                    const SizedBox(
                      height: 5,
                    ),
                    const robotoTextWidget(
                        textval: '16650',
                        colorval: Colors.black,
                        sizeval: 22,
                        fontWeight: FontWeight.normal),
                  ],
                ),
                Container(
                  width: 1,
                  height: MediaQuery.of(context).size.height / 12,
                  color: AppColor.grey,
                ),
                Column(
                  children: <Widget>[
                    robotoTextWidget(
                        textval: totalCapacity,
                        colorval: AppColor.blue,
                        sizeval: 14,
                        fontWeight: FontWeight.bold),
                    const SizedBox(
                      height: 5,
                    ),
                    const robotoTextWidget(
                        textval: '195.0',
                        colorval: Colors.black,
                        sizeval: 22,
                        fontWeight: FontWeight.normal),
                  ],
                )
              ],
            )
          ],
        ),
      );

  }
}
