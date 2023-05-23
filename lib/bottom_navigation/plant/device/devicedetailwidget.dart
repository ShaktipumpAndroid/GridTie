import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grid_tie/theme/color.dart';
import 'package:grid_tie/uiwidget/robotoTextWidget.dart';
import '../../../theme/string.dart';
import '../../../chartwidgets/chartwidget.dart';

class DeviceDetailPage extends StatefulWidget {
   DeviceDetailPage({Key? key,required this.deviceId}) : super(key: key);
  String deviceId;

  @override
  State<DeviceDetailPage> createState() => _DeviceDetailPageState();
}

class _DeviceDetailPageState extends State<DeviceDetailPage> {

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children:  [
            ChartWidget(deviceId: widget.deviceId,),
          ]),
    );
  }


}
