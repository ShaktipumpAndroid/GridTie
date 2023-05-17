import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Util/utility.dart';
import '../bottom_navigation/dashboard/model/chartdata.dart';
import '../theme/color.dart';
import '../uiwidget/robotoTextWidget.dart';

class YearWidget extends StatefulWidget {
  const YearWidget({Key? key}) : super(key: key);


  @override
  State<YearWidget> createState() => _YearWidgetState();
}

class _YearWidgetState extends State<YearWidget> {
  late List<ChartData> data;
  late TooltipBehavior _tooltip;
  String selectedDateText = "",changeDate ="";
  late DateTime SelectedDate, mindatime;
  String dateFormat = "dd/MM/yyyy";

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
    mindatime = DateTime.now();
    SelectedDate = mindatime;
    var outputFormat = DateFormat(dateFormat);
    setState(() {
      selectedDateText = outputFormat.format(SelectedDate);
      changeDate  = outputFormat.format(SelectedDate);
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
        body:  Wrap(children: [Column(
              children: [
                datePickerWidget(),
                columnChart()
              ],
            )]));
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
  datePickerWidget() {
    return Container(
      color: AppColor.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              DateTime date = SelectedDate.subtract(Duration(days:365));

              if(date.year>2017){
                var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
                SelectedDate = inputFormat.parse(
                    "${DateFormat('yyyy-MM-dd').format(date)} ${DateFormat('HH:mm').format(date)}");
                var outputFormat = DateFormat(dateFormat);
                setState(() {
                  selectedDateText = outputFormat.format(SelectedDate);
                  changeDate = outputFormat.format(SelectedDate);
                });
                print('previousDate===>${selectedDateText}');
              }else{
                Utility().showInSnackBar(value: 'Cant select Past years', context: context);

              }

            },
            icon: const Icon(
              Icons.arrow_circle_left_sharp,
              size: 30,
              color: AppColor.themeColor,
            ),
          ),
          GestureDetector(
            onTap: () {
              //   _openDatePicker(context);
            },
            child: Container(
              width: 150,
              height: 35,
              //Same as `blurRadius` i guess
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Align(
                alignment: Alignment.center,
                child: robotoTextWidget(
                    textval: selectedDateText.toString(),
                    colorval: AppColor.themeColor,
                    sizeval: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              DateTime date = SelectedDate.add(Duration(days: 365));
              print('date${date.year}');
              var inputFormat = DateFormat('dd/MM/yyyy');
              SelectedDate =
                  inputFormat.parse("${DateFormat('dd/MM/yyyy').format(date)}");
              var outputFormat = DateFormat(dateFormat);
              changeDate = outputFormat.format(SelectedDate);
              setState(() {

                if (Utility().dateConverter(changeDate.toString(),365) ==
                    "Tomorrow") {
                  Utility().showInSnackBar(value: 'Cant select future years', context: context);
                  changeDate = selectedDateText;
                  SelectedDate = mindatime;
                } else {
                  selectedDateText = outputFormat.format(SelectedDate);
                  print(selectedDateText);
                }
              });
            },
            icon: const Icon(
              Icons.arrow_circle_right_sharp,
              size: 30,
              color: AppColor.themeColor,
            ),
          )
        ],
      ),
    );
  }
}