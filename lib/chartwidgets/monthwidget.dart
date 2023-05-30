import 'dart:convert' as convert;

import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:grid_tie/webservice/APIDirectory.dart';
import 'package:grid_tie/webservice/HTTP.dart' as HTTP;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Util/utility.dart';
import '../theme/color.dart';
import '../theme/string.dart';
import '../uiwidget/robotoTextWidget.dart';
import '../webservice/constant.dart';
import 'package:grid_tie/chartwidgets/model/chartdata.dart' as DevicePrefix;
import 'package:grid_tie/chartwidgets/model/plantchartdata.dart' as PlantPrefix;

class MonthWidget extends StatefulWidget {
  MonthWidget({Key? key, required this.deviceId,required this.isPlant}) : super(key: key);
  String deviceId;
  bool isPlant;

  @override
  State<MonthWidget> createState() => _MonthWidgetState();
}

class _MonthWidgetState extends State<MonthWidget> {
  late List<DevicePrefix.Response> deviceData = [];
  late List<PlantPrefix.Response> plantData = [];
  late TooltipBehavior _tooltip;
  late DateTime SelectedDate, mindatime;
  bool isLoading = false;
  String selectedDateText = "",
      changeDate = "",
      plantCapacity = "",
      plantAddress = "",
      currentPowerTxt = "",
      totalEnergyTxt = "",
      todayEnergyTxt = "",
      totalCapacityTxt = "",
      totalIncomeTxt = "",
      todayIncomeTxt = "",
      firstMonthDate = "",
      lastMonthDate = "",
      dateFormat = "MM/dd/yyyy",
      dateFormat2 = "MM-yyyy";

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
      firstMonthDate =
          outputFormat.format(Utility().findFirstDateOfTheMonth(SelectedDate));
      lastMonthDate =
          outputFormat.format(Utility().findLastDateOfTheMonth(SelectedDate));
    });
    monthDataAPI();
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
            primaryYAxis: widget.isPlant?NumericAxis(minimum: 0, maximum: 300, interval: 50):NumericAxis(minimum: 0, maximum: 50, interval: 10),
            tooltipBehavior: _tooltip,
            series: widget.isPlant?<ChartSeries<PlantPrefix.Response, String>>[
              ColumnSeries<PlantPrefix.Response, String>(
                  dataSource: plantData,
                  xValueMapper: (PlantPrefix.Response data, _) =>
                      Utility().changeMonthFormate(data.dDate),
                  yValueMapper: (PlantPrefix.Response data, _) => data.totalDEnergy,
                  name: 'Peak Energy',
                  color: AppColor.themeColor)
            ]:<ChartSeries<DevicePrefix.Response, String>>[
              ColumnSeries<DevicePrefix.Response, String>(
                  dataSource: deviceData,
                  xValueMapper: (DevicePrefix.Response data, _) =>
                      Utility().changeMonthFormate(data.date1),
                  yValueMapper: (DevicePrefix.Response data, _) => data.todayREnergy,
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
              DateTime date = SelectedDate.subtract(Duration(days: 30));
              if (date.year > 2017) {
                var inputFormat = DateFormat('MM/dd/yyyy HH:mm');
                SelectedDate = inputFormat.parse(
                    "${DateFormat('MM/dd/yyyy').format(date)} ${DateFormat('HH:mm').format(date)}");
                var outputFormat = DateFormat(dateFormat);
                setState(() {
                  selectedDateText =
                      DateFormat(dateFormat2).format(SelectedDate);
                  changeDate = outputFormat.format(SelectedDate);
                  firstMonthDate = outputFormat
                      .format(Utility().findFirstDateOfTheMonth(SelectedDate));
                  lastMonthDate = outputFormat
                      .format(Utility().findLastDateOfTheMonth(SelectedDate));
                });

                monthDataAPI();
              } else {
                Utility().showInSnackBar(
                    value: 'Cant select past months', context: context);
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
              DateTime date = SelectedDate.add(Duration(days: 30));
              var inputFormat = DateFormat('MM/dd/yyyy');
              SelectedDate =
                  inputFormat.parse("${DateFormat('MM/dd/yyyy').format(date)}");
              var outputFormat = DateFormat(dateFormat);
              changeDate = outputFormat.format(SelectedDate);
              setState(() {
                if (Utility().monthYearConverter(changeDate.toString(), 30) ==
                    "Tomorrow") {
                  Utility().showInSnackBar(
                      value: 'Cant select future months', context: context);
                  changeDate = outputFormat.format(DateTime.now());
                  SelectedDate = mindatime;
                  firstMonthDate = outputFormat
                      .format(Utility().findFirstDateOfTheMonth(mindatime));
                  lastMonthDate = outputFormat
                      .format(Utility().findLastDateOfTheMonth(mindatime));
                } else {
                  selectedDateText =
                      DateFormat(dateFormat2).format(SelectedDate);
                  firstMonthDate = outputFormat
                      .format(Utility().findFirstDateOfTheMonth(SelectedDate));
                  lastMonthDate = outputFormat
                      .format(Utility().findLastDateOfTheMonth(SelectedDate));
                  monthDataAPI();
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
        var inputFormat = DateFormat('MM/dd/yyyy HH:mm');
        SelectedDate = inputFormat.parse(
            "${DateFormat('MM/dd/yyyy').format(index)} ${DateFormat('HH:mm').format(SelectedDate)}");
        var outputFormat = DateFormat(dateFormat2);
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
                    textval: '$currentPower:- $currentPowerTxt',
                    colorval: AppColor.whiteColor,
                    sizeval: 12,
                    fontWeight: FontWeight.w600),
                robotoTextWidget(
                    textval: '$address:- $plantAddress',
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
                 /* Container(
                    margin: const EdgeInsets.all(20),
                    height: 1,
                    color: AppColor.grey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      detailBoxWidget(todayEnergy, todayEnergyTxt.toString()),
                      lineWidget(),
                      detailBoxWidget(todayIncome, todayIncomeTxt.toString()),
                    ],
                  )*/
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

  Future<void> monthDataAPI() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    if(widget.isPlant){
      plantDataAPI();
    }else{

      DeviceDataAPI();
    }

  }

  void DeviceDataAPI() async{
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    var outputFormat = DateFormat(dateFormat2);

    dynamic res = await HTTP.get(getMonthlyDeviceChart(
        sharedPreferences.getString(userID).toString(),
        firstMonthDate.toString(),
        lastMonthDate.toString(),
        widget.deviceId));
    var jsonData = null;
    if (res != null && res.statusCode != null && res.statusCode == 200) {
      jsonData = convert.jsonDecode(res.body);
      DevicePrefix.ChartData chartData = DevicePrefix.ChartData.fromJson(jsonData);
      if (chartData.status.toString() == 'true'&& chartData.response.isNotEmpty) {
        deviceData = chartData.response;

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

        todayEnergyTxt = '${chartData.response[chartData.response.length - 1].todayREnergy} kWh';

        todayIncomeTxt =
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

  void plantDataAPI() async{
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    var outputFormat = DateFormat(dateFormat2);
    dynamic res = await HTTP.get(getMonthlyPlantChart( sharedPreferences.getString(userID).toString(),
        firstMonthDate.toString(),
        lastMonthDate.toString(),
        widget.deviceId));
    var jsonData = null;
    if (res != null && res.statusCode != null && res.statusCode == 200) {
      jsonData = convert.jsonDecode(res.body);
      PlantPrefix.PlantChartData plantChartData =  PlantPrefix.PlantChartData.fromJson(jsonData);
      if (plantChartData.status.toString() == 'true' && plantChartData.response.isNotEmpty) {
        plantData = plantChartData.response;

        plantAddress =
            plantChartData.response[plantChartData.response.length - 1].address;

        totalCapacityTxt =
        '${plantChartData.response[plantChartData.response.length - 1].totalPCapacity}';

       /* currentPowerTxt =
        '${plantChartData.response[plantChartData.response.length - 1].currentRPower} kWh';*/

        totalEnergyTxt =
        '${plantChartData.response[plantChartData.response.length - 1].totalMEnergy} kWh';

        totalIncomeTxt =
        '${Utility().calculateRevenue('${plantChartData.response[plantChartData.response.length - 1].totalMEnergy}').toString()} INR';

        todayEnergyTxt = '${plantChartData.response[plantChartData.response.length - 1].totalDEnergy} kWh';

        todayIncomeTxt =
        '${Utility().calculateRevenue('${plantChartData.response[plantChartData.response.length - 1].totalDEnergy}').toString()} INR';
      }
      setState(() {
        isLoading = false;
      });
      }else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }

  }
}
