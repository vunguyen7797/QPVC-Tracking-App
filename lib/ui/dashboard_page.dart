import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/material.dart';
import 'package:qpv_client_app/components/custom_bottom_navi_bar.dart';
import 'package:qpv_client_app/helper/size_config.dart';
import 'package:qpv_client_app/ui/home_page.dart';
import 'package:qpv_client_app/ui/map_page.dart';
import 'package:qpv_client_app/ui/profile_page.dart';
import 'package:qpv_client_app/ui/recycle_points_page.dart';

import '../constant.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _bottomNavIndex = 0;
  List<IconData> iconList = [
    FlevaIcons.home_outline,
    FlevaIcons.heart_outline,
    FlevaIcons.map_outline,
    FlevaIcons.person_outline
  ];
  //List<Widget> pages = [HomePage(), RecyclePointPage(), HomePage(), HomePage()];
  List<Widget> pages = [
    HomePage(),
    RecyclePointPage(),
    MapPage(),
    ProfilePage()
  ];
  Widget body = HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: body,
        bottomNavigationBar: CustomBottomNavyBar(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            backgroundColor: Colors.white,
            selectedIndex: _bottomNavIndex,
            animationDuration: Duration(milliseconds: 500),
            enableAnimation: false,
            showElevation: true,
            onItemSelected: (i) {
              setState(() {
                _bottomNavIndex = i;
                body = pages[i];
              });
            },
            containerHeight: 6.5 * SizeConfig.heightMultiplier,
            items: [
              BottomNavyBarCustomItem(
                inactiveColor: Colors.grey,
                icon: Icon(FlevaIcons.home_outline,
                    size: 3 * SizeConfig.textMultiplier),
                activeColor: ColorPalette.PrimaryColor,
              ),
              BottomNavyBarCustomItem(
                inactiveColor: Colors.grey,
                icon: Icon(FlevaIcons.gift_outline,
                    size: 3 * SizeConfig.textMultiplier),
                activeColor: ColorPalette.PrimaryColor,
              ),
              BottomNavyBarCustomItem(
                inactiveColor: Colors.grey,
                icon: Icon(FlevaIcons.map_outline,
                    size: 3 * SizeConfig.textMultiplier),
                activeColor: ColorPalette.PrimaryColor,
              ),
              BottomNavyBarCustomItem(
                inactiveColor: Colors.grey,
                icon: Icon(FlevaIcons.person_outline,
                    size: 3 * SizeConfig.textMultiplier),
                activeColor: ColorPalette.PrimaryColor,
              ),
            ]));
  }
}
