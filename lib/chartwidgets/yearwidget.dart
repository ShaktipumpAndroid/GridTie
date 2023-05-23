import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:grid_tie/webservice/HTTP.dart' as HTTP;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Util/utility.dart';
import '../theme/color.dart';
import '../theme/string.dart';
import '../uiwidget/robotoTextWidget.dart';
import '../webservice/APIDirectory.dart';
import '../webservice/constant.dart';
import 'model/chartdata.dart';

class YearWidget extends StatefulWidget {
  YearWidget({Key? key, required this.deviceId}) : super(key: key);
  String deviceId;

  @override
  State<YearWidget> createState() => _YearWidgetState();
}

class _YearWidgetState extends State<YearWidget> {
  late List<Response> data = [];
  late TooltipBehavior _tooltip;
  late DateTime SelectedDate, mindatime;
  bool isLoading = false;
  String selectedDateText = "",
      changeDate = "",
      plantCapacity = "",
      plantAddress = "",
      currentPowerTxt = "",
      totalEnergyTxt = "",
      totalCapacityTxt = "",
      totalIncomeTxt = "",
      dailyRevenueTxt = "",
      yearFirstDate = "",
      yearLastDate = "",
      dateFormat = "yyyy-MM-dd",
      dateFormat2 = "yyyy";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tooltip = TooltipBehavior(enable: true);
    mindatime = DateTime.now();
    SelectedDate = mindatime;
    var outputFormat = DateFormat(dateFormat);
    setState(() {
      selectedDateText = DateFormat(dateFormat2).format(SelectedDate);
      changeDate = outputFormat.format(SelectedDate);
      yearFirstDate = '$selectedDateText${'-01-01'}';
      yearLastDate = '$selectedDateText${'-12-31'}';
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
        body: Stack(children: [
      SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              datePickerWidget(),
              columnChart(),
              plantDetailWidget(),
              solarHouseDetailWidget(),
            ],
          )),
      isLoading ? Utility().dialogueWidget(context) : const SizedBox(),
    ]));
  }

  Container columnChart() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 3,
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(minimum: 0, maximum: 50, interval: 10),
            tooltipBehavior: _tooltip,
            series: <ChartSeries<Response, String>>[
              ColumnSeries<Response, String>(
                  dataSource: data,
                  xValueMapper: (Response data, _) =>
                      Utility().changeMonthFormate(data.date1),
                  yValueMapper: (Response data, _) => data.todayREnergy,
                  name: 'Peak Energy',
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
              DateTime date = SelectedDate.subtract(Duration(days: 365));

              if (date.year > 2017) {
                var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
                SelectedDate = inputFormat.parse(
                    "${DateFormat('yyyy-MM-dd').format(date)} ${DateFormat('HH:mm').format(date)}");
                var outputFormat = DateFormat(dateFormat);
                setState(() {
                  selectedDateText =
                      DateFormat(dateFormat2).format(SelectedDate);
                  changeDate = outputFormat.format(SelectedDate);
                  yearFirstDate = '$selectedDateText${'-01-01'}';
                  yearLastDate = '$selectedDateText${'-12-31'}';
                });
              } else {
                Utility().showInSnackBar(
                    value: 'Cant select Past years', context: context);
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
              var inputFormat = DateFormat('yyyy-MM-dd');
              SelectedDate =
                  inputFormat.parse("${DateFormat('yyyy-MM-dd').format(date)}");
              var outputFormat = DateFormat(dateFormat);
              changeDate = outputFormat.format(SelectedDate);
              setState(() {
                if (Utility().dateConverter(changeDate.toString(), 365) ==
                    "Tomorrow") {
                  Utility().showInSnackBar(
                      value: 'Cant select future years', context: context);
                  changeDate = outputFormat.format(DateTime.now());
                  SelectedDate = mindatime;
                } else {
                  selectedDateText =
                      DateFormat(dateFormat2).format(SelectedDate);
                  yearFirstDate = '$selectedDateText${'-01-01'}';
                  yearLastDate = '$selectedDateText${'-12-31'}';
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

  SizedBox solarHouseDetailWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3,
      child: Stack(children: <Widget>[
        Image.asset(
          'assets/images/solarplant.jpg',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3,
          fit: BoxFit.fill,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20, left: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                robotoTextWidget(
                    textval: plantAddress.trim(),
                    colorval: AppColor.whiteColor,
                    sizeval: 12,
                    fontWeight: FontWeight.w600)
              ]),
        )
      ]),
    );
  }

  Wrap plantDetailWidget() {
    return Wrap(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
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
                      detailBoxWidget(currentPower, currentPowerTxt.toString()),
                      lineWidget(),
                      detailBoxWidget(dailyRevenue, dailyRevenueTxt.toString()),
                    ],
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  SizedBox detailBoxWidget(String title, String value) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      child: Column(
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

  Future<void> yearDataAPI() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var outputFormat = DateFormat(dateFormat2);

    dynamic res = await HTTP.get(getMonthlyDeviceChart(
        sharedPreferences.getString(userID).toString(),
        yearFirstDate.toString(),
        yearLastDate.toString(),
        widget.deviceId));
    var jsonData = null;
    if (res != null && res.statusCode != null && res.statusCode == 200) {
      jsonData = convert.jsonDecode(res.body);
      ChartData chartData = ChartData.fromJson(jsonData);
      if (chartData.status.toString() == 'true') {
        data = chartData.response;

        plantAddress =
            chartData.response[chartData.response.length - 1].address;

        totalCapacityTxt =
            '${chartData.response[chartData.response.length - 1].totalRCapacity}';

        currentPowerTxt =
            '${chartData.response[chartData.response.length - 1].currentRPower} kWh';

        totalEnergyTxt =
        '${chartData.response[chartData.response.length - 1].totalREnergy} kWh';

        totalIncomeTxt =
        '${Utility().calculateRevenue('${chartData.response[chartData.response.length - 1].totalREnergy}').toString()} INR';

        dailyRevenueTxt =
        '${Utility().calculateRevenue('${chartData.response[chartData.response.length - 1].todayREnergy}').toString()} INR';
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
