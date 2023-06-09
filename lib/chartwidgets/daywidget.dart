import 'dart:convert' as convert;
import 'dart:ffi';
import 'dart:math';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:grid_tie/chartwidgets/model/chartdata.dart' as DevicePrefix;
import 'package:grid_tie/chartwidgets/model/plantchartdata.dart' as PlantPrefix;
import 'package:grid_tie/uiwidget/robotoTextWidget.dart';
import 'package:grid_tie/webservice/HTTP.dart' as HTTP;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../Util/utility.dart';
import '../theme/color.dart';
import '../theme/string.dart';
import '../webservice/APIDirectory.dart';
import '../webservice/constant.dart';



class DayWidget extends StatefulWidget {
  DayWidget({Key? key, required this.deviceId,required this.isPlant}) : super(key: key);
  String deviceId;
  bool isPlant;

  @override
  State<DayWidget> createState() => _DayWidgetState();
}

class _DayWidgetState extends State<DayWidget> {
  late List<DevicePrefix.Response> deviceData = [];
  late List<PlantPrefix.Response> plantData = [];

  late TooltipBehavior _tooltip;
  String selectedDateText = "",
      changeDate = "",
      plantCapacity = "",
      plantAddress = "",
      currentPowerTxt = "",
      totalEnergyTxt = "",
      todayEnergyTxt = "",
      totalCapacityTxt = "",
      totalIncomeTxt = "",
      todayIncomeTxt = "";
  late DateTime SelectedDate, mindatime;
  String dateFormat = "yyyy-MM-dd", dateFormat2 = "yyyy-MM-dd";
  bool isLoading = true;
  double maximumInterval = 50;
  late ZoomPanBehavior zoomPanBehavior;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tooltip = TooltipBehavior(enable: true);
    mindatime = DateTime.now();
    SelectedDate = mindatime;
    var outputFormat = DateFormat(dateFormat);
    setState(() {
      selectedDateText = outputFormat.format(SelectedDate);
      changeDate = outputFormat.format(SelectedDate);
    });
    zoomPanBehavior = ZoomPanBehavior(enablePinching: true);
    dailyDataAPI();
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
              areaChart(),
              plantDetailWidget(),
              solarHouseDetailWidget(),
            ],
          )),
      isLoading ? Utility().dialogueWidget(context) : const SizedBox(),
    ]));
  }

  Container areaChart() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3,
      child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          primaryYAxis:  widget.isPlant?NumericAxis(minimum: 0, maximum: maximumInterval, interval:maximumInterval/ 10):NumericAxis(minimum: 0, maximum: maximumInterval, interval: maximumInterval/10),
          tooltipBehavior: _tooltip,
          zoomPanBehavior: zoomPanBehavior,
          series: widget.isPlant?<ChartSeries<PlantPrefix.Response, String>>[
            AreaSeries<PlantPrefix.Response, String>(
                dataSource: plantData,
                xValueMapper: (PlantPrefix.Response data, _) =>
                    Utility().changeTimeFormate1(data.dDate),
                yValueMapper: (PlantPrefix.Response data, _) =>  data.current_Energy,
                borderDrawMode: BorderDrawMode.all,
                borderColor: AppColor.themeColor,
                borderWidth: 2,
                markerSettings: MarkerSettings(isVisible: true,height: 3,width: 3,color: AppColor.themeColor,borderColor: AppColor.themeColor,borderWidth: 1),
                name: 'Peak Energy',
                color: AppColor.chartColour)
          ]:<ChartSeries<DevicePrefix.Response, String>>[
            AreaSeries<DevicePrefix.Response, String>(
                dataSource: deviceData,
                xValueMapper: (DevicePrefix.Response data, _) =>
                  Utility().changeTimeFormate1(data.date1),
                yValueMapper: (DevicePrefix.Response data, _) => data.currentRPower,
                borderDrawMode: BorderDrawMode.top,
                borderColor: AppColor.themeColor,
                borderWidth: 2,
                markerSettings: MarkerSettings(isVisible: true,height: 3,width: 3,color: AppColor.themeColor,borderColor: AppColor.themeColor,borderWidth: 1),
                name: 'Peak Energy',
                color: AppColor.chartColour)
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
                  dailyDataAPI();
                });
              } else {
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
              DateTime date = SelectedDate.add(Duration(days: 1));
              var inputFormat = DateFormat('dd/MM/yyyy');
              SelectedDate =
                  inputFormat.parse("${DateFormat('dd/MM/yyyy').format(date)}");
              var outputFormat = DateFormat(dateFormat);
              changeDate = outputFormat.format(SelectedDate);
              setState(() {
                if (Utility().dateConverter(changeDate.toString(), 1) ==
                    "Tomorrow") {
                  Utility().showInSnackBar(
                      value: 'Cant select future dates', context: context);
                  changeDate = selectedDateText;
                  SelectedDate = mindatime;
                } else {
                  selectedDateText = outputFormat.format(SelectedDate);
                  dailyDataAPI();
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
        var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
        SelectedDate = inputFormat.parse(
            "${DateFormat('yyyy-MM-dd').format(index)} ${DateFormat('HH:mm').format(SelectedDate)}");
        var outputFormat = DateFormat(dateFormat);
        setState(() {
          selectedDateText = outputFormat.format(SelectedDate);
          dailyDataAPI();
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
                !widget.isPlant?robotoTextWidget(
                    textval: '$currentPower:- $currentPowerTxt',
                    colorval: AppColor.whiteColor,
                    sizeval: 12,
                    fontWeight: FontWeight.w600):SizedBox(),
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
                  Container(
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

  Future<void> dailyDataAPI()  async {
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
    dynamic res = await HTTP.get(getDailyDeviceChart(
        sharedPreferences.getString(userID).toString(),
        outputFormat.format(SelectedDate).toString(),
        widget.deviceId));
    var jsonData = null;
    if (res != null && res.statusCode != null && res.statusCode == 200) {
      jsonData = convert.jsonDecode(res.body);
      DevicePrefix.ChartData chartData =  DevicePrefix.ChartData.fromJson(jsonData);
      if (chartData.status.toString() == 'true' && chartData.response.isNotEmpty) {
        deviceData = chartData.response;

        plantAddress = chartData.response[chartData.response.length - 1].address;

        currentPowerTxt = '${chartData.response[chartData.response.length - 1].currentRPower.toStringAsFixed(2)} kWh';

        totalEnergyTxt = '${chartData.response[chartData.response.length - 1].totalREnergy.toStringAsFixed(2)} kWh';

        totalIncomeTxt = '${Utility().calculateRevenue('${chartData.response[chartData.response.length - 1].totalREnergy.toStringAsFixed(2)}').toString()} INR';

        todayEnergyTxt = '${chartData.response[chartData.response.length - 1].todayREnergy.toStringAsFixed(2)} kWh';

        todayIncomeTxt =
        '${Utility().calculateRevenue('${chartData.response[chartData.response.length - 1].todayREnergy.toStringAsFixed(2)}').toString()} INR';

        retriveDeviceMaxNumber(deviceData);
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
    dynamic res = await HTTP.get(getDailyPlantChart(
        sharedPreferences.getString(userID).toString(),
        outputFormat.format(SelectedDate).toString(),
        widget.deviceId));
    var jsonData = null;
    if (res != null && res.statusCode != null && res.statusCode == 200) {
      jsonData = convert.jsonDecode(res.body);
      PlantPrefix.PlantChartData plantChartData =  PlantPrefix.PlantChartData.fromJson(jsonData);
      if (plantChartData.status.toString() == 'true' && plantChartData.response.isNotEmpty) {
        plantData = plantChartData.response;

        plantAddress = plantChartData.response[plantChartData.response.length - 1].address;

     //   currentPowerTxt = '${plantChartData.response[plantChartData.response.length - 1].currentRPower} kWh';

        totalEnergyTxt = '${plantChartData.response[plantChartData.response.length - 1].totalMEnergy.toStringAsFixed(2)} kWh';

        totalIncomeTxt = '${Utility().calculateRevenue('${plantChartData.response[plantChartData.response.length - 1].totalMEnergy.toStringAsFixed(2)}').toString()} INR';

        todayEnergyTxt = '${plantChartData.response[plantChartData.response.length - 1].totalDEnergy.toStringAsFixed(2)} kWh';

        todayIncomeTxt =
        '${Utility().calculateRevenue('${plantChartData.response[plantChartData.response.length - 1].totalDEnergy.toStringAsFixed(2)}').toString()} INR';
        retrivePlantMaxNumber(plantData);
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

  void retriveDeviceMaxNumber(List<DevicePrefix.Response>deviceData) {
    var largestGeekValue = deviceData[0].currentRPower;
    var smallestGeekValue = deviceData[0].currentRPower;

    // Using forEach loop to find
    // the largest and smallest
    // numbers in the list
    deviceData.forEach((gfg) => {
      if (gfg.currentRPower > largestGeekValue) {largestGeekValue = gfg.currentRPower},
      if (gfg.currentRPower < smallestGeekValue) {smallestGeekValue = gfg.currentRPower},
    });

    // Printing the values
   // print("Smallest value in the list : $smallestGeekValue");
   // print("Largest value in the list : $largestGeekValue");

    maximumInterval = largestGeekValue;

    print('maximumInterval===>$maximumInterval');
  }

  void retrivePlantMaxNumber(List<PlantPrefix.Response>plantData) {
    var largestGeekValue = plantData[0].current_Energy;
    var smallestGeekValue = plantData[0].current_Energy;

    // Using forEach loop to find
    // the largest and smallest
    // numbers in the list
    plantData.forEach((gfg) => {
      if (gfg.current_Energy > largestGeekValue) {largestGeekValue = gfg.current_Energy},
      if (gfg.current_Energy < smallestGeekValue) {smallestGeekValue = gfg.current_Energy},
    });

    // Printing the values
   // print("Smallest value in the list : $smallestGeekValue");
   // print("Largest value in the list : $largestGeekValue");

    maximumInterval = largestGeekValue;

  }

}
