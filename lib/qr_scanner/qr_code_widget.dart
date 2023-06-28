import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grid_tie/theme/color.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../theme/string.dart';
import '../uiwidget/robotoTextWidget.dart';

class QRScannerWidget extends StatefulWidget {
  const QRScannerWidget({Key? key}) : super(key: key);

  @override
  State<QRScannerWidget> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerWidget> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  TextEditingController barCodeTextController = TextEditingController();
  bool isFlashOn = false, isCameraFlip = false, isLoading = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: robotoTextWidget(textval: addDevice,
          colorval: AppColor.whiteColor,
          sizeval: 16, fontWeight: FontWeight.w600),),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(flex: 1, child: _buildQrView(context)),
              Container(
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await controller?.toggleFlash();
                        setState(() {
                          if (isFlashOn) {
                            isFlashOn = false;
                          } else {
                            isFlashOn = true;
                          }
                        });
                      },
                      icon: isFlashOn
                          ? const Icon(
                              Icons.flash_auto_sharp,
                              color: AppColor.whiteColor,
                            )
                          : const Icon(Icons.flash_off_sharp,
                              color: AppColor.whiteColor),
                    ),
                    IconButton(
                      onPressed: () async {
                        await controller?.flipCamera();
                        setState(() {
                          if (isCameraFlip) {
                            isCameraFlip = false;
                          } else {
                            isCameraFlip = true;
                          }
                        });
                      },
                      icon: const Icon(Icons.flip_camera_android,
                          color: AppColor.whiteColor),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    scannedQRText() ,
                    DeviceNameText(),
                    const SizedBox(height: 50,),
                    GestureDetector(
                        onTap: () {
                          //signIn();
                        },
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppColor.themeColor),
                          child: Center(
                            child: isLoading
                                ? const SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(
                                      color: AppColor.whiteColor,
                                    ),
                                  )
                                : robotoTextWidget(
                                    textval: submit,
                                    colorval: Colors.white,
                                    sizeval: 14,
                                    fontWeight: FontWeight.bold),
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 200 ||
            MediaQuery.of(context).size.height < 200)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.blue,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        //  barCodeTextController = scanData.code as TextEditingController;
        print(
            'barcode text =====>Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}');

        barCodeTextController.text = result!.code.toString();
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Container scannedQRText() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10,top: 20),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade400,
        ),
        borderRadius: const BorderRadius.all(
            Radius.circular(10) //                 <--- border radius here
            ),
      ),
      child: TextField(
        controller: barCodeTextController,
        maxLines: 1,
        decoration:  InputDecoration(
            prefixIcon: const Icon(
              Icons.qr_code_scanner,
              color: AppColor.themeColor,
            ),
            hintText: enterCode,
            hintStyle: const TextStyle(
                color: Colors.black, fontSize: 14, fontFamily: 'Roboto'),
            border: InputBorder.none),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Container DeviceNameText() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10,top: 20),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade400,
        ),
        borderRadius: const BorderRadius.all(
            Radius.circular(10) //                 <--- border radius here
        ),
      ),
      child: TextField(
        controller: barCodeTextController,
        maxLines: 1,
        decoration:  InputDecoration(
            prefixIcon: SvgPicture.asset(
              'assets/svg/solardevice.svg',
              width: 30,
              height: 30,
            ),
            hintText: enterCode,
            hintStyle: const TextStyle(
                color: Colors.black, fontSize: 14, fontFamily: 'Roboto'),
            border: InputBorder.none),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget loadSVG(String svg) {
    return SvgPicture.asset(
      svg,
      width: 20,
      height: 20,
    );
  }
}
