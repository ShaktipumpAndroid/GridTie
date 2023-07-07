import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grid_tie/Util/utility.dart';
import 'package:grid_tie/theme/string.dart';
import 'package:grid_tie/uiwidget/robotoTextWidget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:grid_tie/chartwidgets/model/chartdata.dart' as DevicePrefix;
import 'package:grid_tie/chartwidgets/model/plantchartdata.dart' as PlantPrefix;

import '../theme/color.dart';



class YChartFullScreen extends StatefulWidget {
  bool isPlant;
  double maximumInterval = 50;
  late List<DevicePrefix.Response> deviceData = [];
  late List<PlantPrefix.Response> plantData = [];

  YChartFullScreen({Key? key, required this.isPlant, required this.maximumInterval, required this.deviceData , required this.plantData}) : super(key: key);

  @override
  State<YChartFullScreen> createState() => YChartFullScreenState();
}

class YChartFullScreenState extends State<YChartFullScreen> {

  late ZoomPanBehavior zoomPanBehavior;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    zoomPanBehavior = ZoomPanBehavior(enablePinching: true);
    _tooltip = TooltipBehavior(
      enable: true,
      format: "point.y W",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
              Navigator.of(context).pop();
            }
          ),
          backgroundColor: AppColor.themeColor,
          title: robotoTextWidget(textval: fullscreen, colorval: AppColor.whiteColor,
              sizeval: 18, fontWeight: FontWeight.normal),
        ),
        body: Stack(children: [
          SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  columnChart(),
                ],
              )),
        ]));
  }

  Container columnChart() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.2,
        margin: const EdgeInsets.only(left: 20, right: 20),
        padding: EdgeInsets.all(10),
        child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis:  widget.isPlant?NumericAxis(minimum: 0, maximum: widget.maximumInterval, interval: widget.maximumInterval/ 10):NumericAxis(minimum: 0, maximum: widget.maximumInterval, interval: widget.maximumInterval/10),
            tooltipBehavior: _tooltip,
            zoomPanBehavior: zoomPanBehavior,
            series: widget.isPlant?<ChartSeries<PlantPrefix.Response, String>>[
              ColumnSeries<PlantPrefix.Response, String>(
                  dataSource: widget.plantData,
                  xValueMapper: (PlantPrefix.Response data, _) =>
                      Utility().changeMonthFormate(data.dDate),
                  yValueMapper: (PlantPrefix.Response data, _) => data.totalMEnergy,
                  name: 'Peak Energy',
                  color: AppColor.chartColour)
            ]:<ChartSeries<DevicePrefix.Response, String>>[
              ColumnSeries<DevicePrefix.Response, String>(
                  dataSource: widget.deviceData,
                  xValueMapper: (DevicePrefix.Response data, _) =>
                      Utility().changeMonthFormate(data.date1),
                  yValueMapper: (DevicePrefix.Response data, _) => data.todayREnergy,
                  name: 'Peak Energy',
                  color: AppColor.chartColour)
            ]));
  }
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

}
