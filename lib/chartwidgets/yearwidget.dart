import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../bottom_navigation/dashboard/model/chartdata.dart';
import '../theme/color.dart';

class YearWidget extends StatefulWidget {
  const YearWidget({Key? key}) : super(key: key);


  @override
  State<YearWidget> createState() => _YearWidgetState();
}

class _YearWidgetState extends State<YearWidget> {
  late List<ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = [
      ChartData('CHN', 12, AppColor.themeColor),
      ChartData('GER', 15, AppColor.themeColor),
      ChartData('RUS', 18, AppColor.themeColor),
      ChartData('BRZ', 6.4, AppColor.themeColor),
      ChartData('IND', 14, AppColor.themeColor)
    ];
    _tooltip = TooltipBehavior(enable: true);
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
        body: Column(
              children: [
                columnChart()
              ],
            ));
  }
  Container columnChart() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/3,
        margin: const EdgeInsets.only(left: 20,right: 20),
        child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
            tooltipBehavior: _tooltip,
            series: <ChartSeries<ChartData, String>>[
              ColumnSeries<ChartData, String>(
                  dataSource: data,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  name: 'Gold',
                  color: AppColor.themeColor)
            ]));
  }
}