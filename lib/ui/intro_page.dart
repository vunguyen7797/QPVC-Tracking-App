import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qpv_client_app/blocs/user_bloc.dart';
import 'package:qpv_client_app/components/custom_bounce_on_tap.dart';
import 'package:qpv_client_app/helper/size_config.dart';
import 'package:qpv_client_app/ui/info_verify_page.dart';
import 'package:qpv_client_app/ui/verification_options_page.dart';

import '../constant.dart';
import 'dashboard_page.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int numFaces = 0;
  String address = "";

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 0)).then((_) {
      final UserBloc userBloc = Provider.of<UserBloc>(context);
      numFaces = userBloc.numOfFaces;
      address = userBloc.address;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            height: h * 0.80,
            child: Carousel(
              dotVerticalPadding: h * 0.00,
              dotColor: Colors.grey,
              dotIncreasedColor: ColorPalette.AccentColor,
              autoplay: false,
              dotBgColor: Colors.transparent,
              dotSize: 6,
              dotSpacing: 15,
              images: [page1(), page2()],
            ),
          ),
          SizedBox(
            height: 4 * SizeConfig.heightMultiplier,
          ),
          CustomBounceAnimation(
            onTap: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          numFaces == 0 || numFaces == null
                              ? VerificationOptionsPage()
                              : address != ""
                                  ? DashboardPage()
                                  : InfoVerifyPage()));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20.0 * SizeConfig.widthMultiplier),
              child: Container(
                height: 7 * SizeConfig.heightMultiplier,
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: ColorPalette.SecondaryColor.withOpacity(0.4),
                        offset: Offset(0, 1),
                        blurRadius: 10,
                        spreadRadius: 1)
                  ],
                  borderRadius:
                      BorderRadius.circular(5 * SizeConfig.heightMultiplier),
                  color: ColorPalette.PrimaryColor,
                ),
                child: Center(
                  child: Text(
                    'Get Started',
                    overflow: TextOverflow.clip,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'RubikMedium',
                      fontSize: 1.75 * SizeConfig.textMultiplier,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 0.15,
          ),
        ],
      ),
    );
  }

  Widget page1() {
    double h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Container(
            alignment: Alignment.center,
            height: h * 0.38,
            child: Image(
              image: AssetImage('res/images/welcome.png'),
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Text(
              'Face ID Drive-thru Pick Up',
              style: TextStyle(
                  fontSize: 3 * SizeConfig.textMultiplier,
                  color: ColorPalette.PrimaryTextColor,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'RubikBold'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8, bottom: 8),
            height: 3,
            width: 150,
            decoration: BoxDecoration(
                color: ColorPalette.AccentColor,
                borderRadius: BorderRadius.circular(40)),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text(
              'Ship, track and pick up parcels with Face ID drive-thru pick up experience.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 2 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Rubik',
                  color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget page2() {
    double h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Container(
            alignment: Alignment.center,
            height: h * 0.38,
            child: Image(
              image: AssetImage('res/images/recycle.png'),
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Text(
              'Reduce Cardboard Waste',
              style: TextStyle(
                  fontSize: 3 * SizeConfig.textMultiplier,
                  color: ColorPalette.PrimaryTextColor,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'RubikBold'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8, bottom: 8),
            height: 3,
            width: 150,
            decoration: BoxDecoration(
                color: ColorPalette.AccentColor,
                borderRadius: BorderRadius.circular(40)),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text(
              'Donate your used cardboard boxes or plastic wrap bags and build up your recycle points to get our best discount deals. Let\'s join hands to take care of our Environment.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 2 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Rubik',
                  color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
