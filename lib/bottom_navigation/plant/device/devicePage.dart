import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grid_tie/bottom_navigation/plant/device/DeviceListPage.dart';
import 'package:grid_tie/qr_scanner/qr_code_widget.dart';
import '../../../theme/color.dart';
import '../../../theme/string.dart';
import '../../../uiwidget/robotoTextWidget.dart';

class DevicePage extends StatefulWidget {
  DevicePage({Key? key,required this.plantId}) : super(key: key);
  String plantId;

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                backgroundColor: AppColor.themeColor,
                title: robotoTextWidget(textval: deviceList, colorval: AppColor.whiteColor,
                    sizeval: 18, fontWeight: FontWeight.normal),
                bottom:  TabBar(
                  isScrollable: false,
                  indicatorColor: AppColor.whiteColor,
                  indicatorPadding: const EdgeInsets.all(5),
                  tabs: [
                    Tab(child: robotoTextWidget(textval: onlineDevices, colorval: AppColor.whiteColor, sizeval: 14, fontWeight: FontWeight.normal)),
                    Tab(child: robotoTextWidget(textval: offlineDevices, colorval: AppColor.whiteColor, sizeval: 14, fontWeight: FontWeight.normal)),

                  ],
                )),
            body:    TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                DeviceListPage(plantId: widget.plantId,status:"0"),
                DeviceListPage(plantId: widget.plantId,status:"1"),

              ],
            ),
          ),
        ),
      ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) =>  QRScannerWidget(plantId: widget.plantId,)),
                    (Route<dynamic> route) => true);
          },
          label:robotoTextWidget(textval: addDevice, colorval: AppColor.whiteColor, sizeval: 12, fontWeight: FontWeight.bold),
          icon: const Icon(Icons.add),
          backgroundColor: AppColor.themeColor,
        )
    );
  }

}