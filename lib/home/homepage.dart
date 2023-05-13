import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grid_tie/uiwidget/robotoTextWidget.dart';

import '../bottom_navigation/alert/alertPage.dart';
import '../bottom_navigation/dashboard/dashboardPage.dart';
import '../bottom_navigation/plant/plantPage.dart';
import '../bottom_navigation/profile/profilePage.dart';
import '../login/model/userdetail.dart';
import '../theme/color.dart';
import '../theme/string.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;

  final pages = [
    const DashboardPage(),
    const PlantPage(),
    const AlertPage(),
    const ProfilePage(),
  ];

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height/12,
        decoration: const BoxDecoration(
          color: AppColor.btnColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() {
                      pageIndex = 0;
                    });
                  },
                  icon: pageIndex == 0
                      ? loadSVG("assets/svg/houseactive.svg")
                      : loadSVG("assets/svg/housedeactive.svg"),
                ),
                pageIndex == 0
                    ? titleText(home,Colors.white,FontWeight.bold)
                    : titleText(home,Colors.grey,FontWeight.normal)
              ],
            ),
            Column(
              children: [
                IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() {
                      pageIndex = 1;
                    });
                  },
                  icon: pageIndex == 1
                      ? loadSVG("assets/svg/plantactive.svg")
                      : loadSVG("assets/svg/plantdeactive.svg"),
                ),
                pageIndex == 1
                    ? titleText(plant,Colors.white,FontWeight.bold)
                    : titleText(plant,Colors.grey,FontWeight.normal)

              ],
            ),
            Column(
              children: [
                IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      setState(() {
                        pageIndex = 2;
                      });
                    },
                    icon: pageIndex == 2
                        ? loadSVG("assets/svg/aleractive.svg")
                        : loadSVG("assets/svg/alertdeactive.svg")),
                pageIndex == 2
                    ? titleText(alert,Colors.white,FontWeight.bold)
                    : titleText(alert,Colors.grey,FontWeight.normal)
              ],
            ),
            Column(
              children: [
                IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      setState(() {
                        pageIndex = 3;
                      });
                    },
                    icon: pageIndex == 3
                        ? loadSVG("assets/svg/profileactive.svg")
                        : loadSVG("assets/svg/profiledeactive.svg")),
                pageIndex == 3
                    ? titleText(profile,Colors.white,FontWeight.bold)
                    : titleText(profile,Colors.grey,FontWeight.normal)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget loadSVG(String svg) {
    return SvgPicture.asset(
      svg,
      width: 50,
      height: 50,
    );
  }

 Widget titleText(String title, Color color, FontWeight fontWeight) {
    return FittedBox(
        child:  robotoTextWidget(textval: title, colorval:color,
         sizeval: 14, fontWeight: fontWeight));
  }

}
