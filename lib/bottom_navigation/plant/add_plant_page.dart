import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grid_tie/bottom_navigation/plant/model/AddPlantModel.dart';
import 'package:grid_tie/theme/color.dart';
import 'package:grid_tie/theme/string.dart';
import 'package:grid_tie/uiwidget/robotoTextWidget.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:grid_tie/webservice/HTTP.dart' as HTTP;
import '../../Util/utility.dart';
import '../../webservice/APIDirectory.dart';
import '../../webservice/constant.dart';

class AddPlantPage extends StatefulWidget {
  const AddPlantPage({Key? key}) : super(key: key);

  @override
  State<AddPlantPage> createState() => _PlantPageState();
}

class _PlantPageState extends State<AddPlantPage> {
  TextEditingController plantNameController = TextEditingController();
  TextEditingController plantCapacityController = TextEditingController();
  TextEditingController plantAddressController = TextEditingController();
  TextEditingController plantLatitudeController = TextEditingController();
  TextEditingController plantLongitudeController = TextEditingController();
  String address = "",
      selectedGridType = grid;

  bool isLoading = false;

  final List<String> _status = [
    grid,
    hybrid,
  ];

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: robotoTextWidget(
              textval: addPlant,
              colorval: AppColor.whiteColor,
              sizeval: 16,
              fontWeight: FontWeight.w600),
          leading: const BackButton(
            color: Colors.white, // <-- SEE HERE
          ),
          backgroundColor: AppColor.themeColor,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.blue.shade800],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: const [0.2, 0.8],
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/svg/applogo.svg",
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
                selectGridType(),
                textFieldsName(),
                textFieldCapacity(),
                textFieldAddress(),
                textFieldLat(),
                textFieldLong(),
                SubmitBtnWidget()
              ],
            ),
          ),
        ));
  }

  selectGridType() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: RadioGroup<String>.builder(
          direction: Axis.horizontal,
          groupValue: selectedGridType,
          activeColor: AppColor.whiteColor,
          horizontalAlignment: MainAxisAlignment.spaceEvenly,
          onChanged: (value) {
            setState(() {
              selectedGridType = value.toString();
            });
          },
          items: _status,
          textStyle: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          itemBuilder: (item) =>
              RadioButtonBuilder(
                item,
              )),
    );
  }

  Container textFieldsName() {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromRGBO(30, 136, 229, .3),
                  blurRadius: 20,
                  offset: Offset(0, 10))
            ]),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.person,
                    color: AppColor.themeColor,
                    size: 20,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: TextField(
                    controller: plantNameController,
                    decoration: InputDecoration(
                        hintText: enterPlantName,
                        hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.normal),
                        border: InputBorder.none),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                  ),
                )
              ],
            ),
          ],
        ));
  }

  Container textFieldCapacity() {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromRGBO(30, 136, 229, .3),
                  blurRadius: 20,
                  offset: Offset(0, 10))
            ]),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Icon(
                    Icons.production_quantity_limits_sharp,
                    color: AppColor.themeColor,
                    size: 20,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: TextField(
                    controller: plantCapacityController,
                    decoration: InputDecoration(
                        hintText: enterPlantCapacity,
                        hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.normal),
                        border: InputBorder.none),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                  ),
                )
              ],
            ),
          ],
        ));
  }

  Container textFieldAddress() {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromRGBO(30, 136, 229, .3),
                  blurRadius: 20,
                  offset: Offset(0, 10))
            ]),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.location_on,
                    color: AppColor.themeColor,
                    size: 20,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                    child: TextField(
                      controller: plantAddressController,
                      decoration: InputDecoration(
                          hintText: enterPlantAddress,
                          hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.normal),
                          border: InputBorder.none),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    )),
              ],
            ),
          ],
        ));
  }

  Container textFieldLat() {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromRGBO(30, 136, 229, .3),
                  blurRadius: 20,
                  offset: Offset(0, 10))
            ]),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Icon(
                    Icons.location_on,
                    color: AppColor.themeColor,
                    size: 20,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: TextField(
                    controller: plantLatitudeController,
                    decoration: InputDecoration(
                        hintText: enterLatitude,
                        hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.normal),
                        border: InputBorder.none),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                  ),
                )
              ],
            ),
          ],
        ));
  }

  Container textFieldLong() {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromRGBO(30, 136, 229, .3),
                  blurRadius: 20,
                  offset: Offset(0, 10))
            ]),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Icon(
                    Icons.location_on,
                    color: AppColor.themeColor,
                    size: 20,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: TextField(
                    controller: plantLongitudeController,
                    decoration: InputDecoration(
                        hintText: enterLongitude,
                        hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.normal),
                        border: InputBorder.none),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                  ),
                )
              ],
            ),
          ],
        ));
  }

  SubmitBtnWidget() {
    return GestureDetector(
        onTap: () {
          addPlantValidation();
        },
        child: Container(
          height: 50,
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColor.themeColor),
          child: Center(
            child: isLoading
                ? Container(
              height: 30,
              width: 30,
              child: const CircularProgressIndicator(
                color: AppColor.whiteColor,
              ),
            )
                : robotoTextWidget(
                textval: submit,
                colorval: Colors.white,
                sizeval: 14,
                fontWeight: FontWeight.bold),
          ),
        ));
  }

  void addPlantValidation() {
    Utility().checkInternetConnection().then((connectionResult) {
      if (connectionResult) {
        if (plantNameController.text
            .toString()
            .isEmpty) {
          Utility()
              .showInSnackBar(value: enterPlantName, context: context);
        } else if (plantCapacityController.text
            .toString()
            .isEmpty) {
          Utility().showInSnackBar(value: enterPlantCapacity, context: context);
        } else if (plantAddressController.text
            .toString()
            .isEmpty) {
          Utility().showInSnackBar(value: enterPlantAddress, context: context);
        } else if (plantLatitudeController.text
            .toString()
            .isEmpty) {
          Utility().showInSnackBar(value: enterLatitude, context: context);
        } else if (plantLongitudeController.text
            .toString()
            .isEmpty) {
          Utility().showInSnackBar(value: enterLongitude, context: context);
        } else {
          addPlantAPI();
        }
      } else {
        Utility()
            .showInSnackBar(value: checkInternetConnection, context: context);
      }
    });
  }

  Future<void> addPlantAPI() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "muId": sharedPreferences.getString(userID).toString(),
      "plantName": plantNameController.text.toString(),
      "capacity": plantCapacityController.text.toString(),
      "plantAddress": plantAddressController.text.toString(),
      "latitude": plantLatitudeController.text.toString(),
      "longitude": plantLongitudeController.text.toString(),
    };

    print("AddPlantInput==============>${data.toString()}");
    var jsonData = null;
    dynamic response = await HTTP.post(addPlantApi(), data);
    print(response.statusCode);
    if (response != null && response.statusCode == 200) {
      print("response==============>${response.body.toString()}");
      setState(() {
        isLoading = false;
      });

      jsonData = convert.jsonDecode(response.body);
      AddPlantModel addPlantModel = AddPlantModel.fromJson(jsonData);

      if (addPlantModel.status == true && addPlantModel.response != null && addPlantModel.response.toString().isNotEmpty) {

        print("response==============>${response.body.toString()}");
        Navigator.of(context).pop();
      } else {
        Utility().showInSnackBar(value: addPlantModel.message, context: context);
      }
    } else {
      if (!mounted) return;
      Utility().showInSnackBar(value: 'Unable To Login', context: context);
    }
  }
}
