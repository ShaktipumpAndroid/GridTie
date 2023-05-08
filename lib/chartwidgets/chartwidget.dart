import 'package:flutter/material.dart';
import 'package:grid_tie/chartwidgets/daywidget.dart';
import 'package:grid_tie/chartwidgets/monthwidget.dart';
import 'package:grid_tie/chartwidgets/yearwidget.dart';
import 'package:grid_tie/theme/color.dart';
import 'package:grid_tie/theme/string.dart';
import 'package:grid_tie/uiwidget/robotoTextWidget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../bottom_navigation/dashboard/model/chartdata.dart';

class ChartWidget extends StatefulWidget {
  const ChartWidget({Key? key}) : super(key: key);

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.7,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: AppColor.themeColor,
              title: robotoTextWidget(textval: plantDetail, colorval: AppColor.whiteColor,
                  sizeval: 18, fontWeight: FontWeight.normal),
              bottom:  TabBar(
                isScrollable: false,
                indicatorColor: AppColor.whiteColor,
                indicatorPadding: const EdgeInsets.all(5),
                tabs: [
                  Tab(child: robotoTextWidget(textval: day, colorval: AppColor.whiteColor, sizeval: 14, fontWeight: FontWeight.normal)),
                  Tab(child: robotoTextWidget(textval: month, colorval: AppColor.whiteColor, sizeval: 14, fontWeight: FontWeight.normal)),
                  Tab(child: robotoTextWidget(textval: year, colorval: AppColor.whiteColor, sizeval: 14, fontWeight: FontWeight.normal)),
                ],
              )),
          body:  const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
             DayWidget(),
              MonthWidget(),
              YearWidget(),
            ],
          ),
        ),
      ),
    );
  }

}
