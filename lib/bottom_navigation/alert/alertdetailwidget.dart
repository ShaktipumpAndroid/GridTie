
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grid_tie/bottom_navigation/alert/model/falultmodel.dart';
import 'package:grid_tie/theme/color.dart';
import 'package:grid_tie/theme/string.dart';
import 'package:grid_tie/uiwidget/robotoTextWidget.dart';


class AlertDetailsPage extends StatefulWidget {
  Response? alertList;

   AlertDetailsPage({Key? key,  this.alertList,}) : super(key: key);


  @override
  State<AlertDetailsPage> createState() => _AlertDetailsPageState();
}

class _AlertDetailsPageState extends State<AlertDetailsPage> {

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const robotoTextWidget(textval: 'Alert Details',
            colorval: AppColor.whiteColor,
            sizeval: 16, fontWeight: FontWeight.bold),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ), ),

        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.blue.shade800],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [0.2, 0.8],
            ),
          ),


          child:Stack(children: [
            Column(
              children: [
                loadDetails('assets/svg/warningicon.svg',widget.alertList!.faultName),

                loadDetails('assets/svg/scannerIcon.svg',widget.alertList!.deviceNo),

                loadDetails('assets/svg/solarhouse.svg',widget.alertList!.plantName),

                causeSolutionWidget(cause,causeDescription),
                causeSolutionWidget(solution,solutionDescription),


              ],
            ),
            Align(alignment: Alignment.bottomCenter,
            child:  GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: MediaQuery.of(context).size.height/18,
                  margin:const EdgeInsets.only(bottom: 5,left: 10,right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.themeColor),
                  child: Center(
                    child: robotoTextWidget(
                        textval: closeIssue,
                        colorval: Colors.white,
                        sizeval: 16,
                        fontWeight: FontWeight.bold),
                  ),
                )),)
          ],) ,
        ));
  }



  loadDetails(String svg, String title) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height/13,
      margin: const EdgeInsets.only(left:10,right: 10),
      child: Card(
        color: AppColor.whiteColor,
        elevation: 5,
        child:   Container(
          margin: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Stack(
                  children: <Widget>[
                    SvgPicture.asset(
                      svg,
                      width: 25,
                      height: 25,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              robotoTextWidget(
                textval: title,
                colorval: AppColor.blackColor,
                sizeval: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }

  causeSolutionWidget(String title, String description) {
    return Wrap(children: [
      Container(
        margin: const EdgeInsets.only(left:10,right: 10),
        child: Card(
          color: AppColor.whiteColor,
          elevation: 5,
          child:   Container(
            margin: const EdgeInsets.only(left: 10),
            child: Padding(padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                robotoTextWidget(
                  textval: title,
                  colorval: AppColor.blackColor,
                  sizeval: 14.0,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(child: Text(description,style: const TextStyle(color: Colors.black,
                fontSize: 12,fontWeight: FontWeight.normal),)),
              ],
            ),),
          ),
        ),
      )
    ],);
  }
  }