import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:grid_tie/uiwidget/robotoTextWidget.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Util/utility.dart';
import '../bottom_navigation/dashboard/model/chartdata.dart';
import '../theme/color.dart';
import '../theme/string.dart';

class DayWidget extends StatefulWidget {
  const DayWidget({Key? key}) : super(key: key);

  @override
  State<DayWidget> createState() => _DayWidgetState();
}

class _DayWidgetState extends State<DayWidget> {
  late List<ChartData> data;
  late TooltipBehavior _tooltip;
  String selectedDateText = "", changeDate = "";
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
      changeDate = outputFormat.format(SelectedDate);
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
        body: Wrap(children: [Column(
          children: [datePickerWidget(), areaChart()],
        )],));
  }

  Container areaChart() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3,
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(minimum: 0, maximum: 30, interval: 5),
          tooltipBehavior: _tooltip,
          series: <ChartSeries<ChartData, String>>[
            AreaSeries<ChartData, String>(
                dataSource: data,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                name: 'Gold',
                color: AppColor.themeColor)
          ]),
    );
  }

  datePickerWidget() {
    return Container(
      color: AppColor.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              DateTime date = SelectedDate.subtract(Duration(days: 1));
              if (date.year > 2017) {
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
                Utility().showInSnackBar(
                    value: 'Cant select past dates', context: context);
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
              _openDatePicker(context);
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
              DateTime date = SelectedDate.subtract(Duration(days: 1));
              var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
              SelectedDate = inputFormat.parse(
                  "${DateFormat('yyyy-MM-dd').format(date)} ${DateFormat('HH:mm').format(date)}");
              var outputFormat = DateFormat(dateFormat);
              setState(() {
                selectedDateText = outputFormat.format(SelectedDate);
                changeDate = outputFormat.format(SelectedDate);
              });
              print('previousDate===>${selectedDateText}');
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

  void _openDatePicker(BuildContext context) {
    BottomPicker.date(
      title: 'Select Date',
      titleStyle: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 18,
        color: AppColor.themeColor,
      ),
      onSubmit: (index) {
        print(index);
        SelectedDate = index;
        var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
        SelectedDate = inputFormat.parse(
            "${DateFormat('yyyy-MM-dd').format(index)} ${DateFormat('HH:mm').format(SelectedDate)}");
        var outputFormat = DateFormat(dateFormat);
        setState(() {
          selectedDateText = outputFormat.format(SelectedDate);
        });
      },
      onClose: () {
        print('Picker closed');
      },
      buttonText: confirm.toUpperCase(),
      buttonTextStyle: const TextStyle(
          color: AppColor.whiteColor,
          fontSize: 14,
          fontWeight: FontWeight.w800),
      pickerTextStyle: const TextStyle(
        color: AppColor.themeColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      closeIconColor: AppColor.themeColor,
      buttonSingleColor: AppColor.themeColor,
      backgroundColor: AppColor.whiteColor,
      initialDateTime: SelectedDate,
      minDateTime: DateTime(2018, 1, 1),
      maxDateTime: DateTime.now(),
    ).show(context);
  }
}
