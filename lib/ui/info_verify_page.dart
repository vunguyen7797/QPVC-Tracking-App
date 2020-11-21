import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:provider/provider.dart';
import 'package:qpv_client_app/blocs/user_bloc.dart';
import 'package:qpv_client_app/components/custom_bounce_on_tap.dart';
import 'package:qpv_client_app/components/custom_fade_in.dart';
import 'package:qpv_client_app/components/custom_text_field.dart';
import 'package:qpv_client_app/helper/size_config.dart';
import 'package:qpv_client_app/ui/dashboard_page.dart';

import '../constant.dart';

class InfoVerifyPage extends StatefulWidget {
  final String idInfo;

  const InfoVerifyPage({Key key, this.idInfo}) : super(key: key);
  @override
  _InfoVerifyPageState createState() => _InfoVerifyPageState();
}

class _InfoVerifyPageState extends State<InfoVerifyPage> {
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  bool _fieldEmpty = false;
  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomBounceAnimation(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 5 * SizeConfig.heightMultiplier,
                      left: 5 * SizeConfig.widthMultiplier),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: ColorPalette.SecondaryColor.withOpacity(0.5),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Icon(
                        FlevaIcons.arrow_back,
                        color: Colors.black,
                        size: 3 * SizeConfig.textMultiplier,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 4 * SizeConfig.heightMultiplier,
              ),
              _fieldEmpty
                  ? Container(
                      child: Center(
                      child: Text(
                        'Please enter all required field',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorPalette.AccentColor,
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                          fontFamily: 'RubikMedium',
                        ),
                      ),
                    ))
                  : Container(),
              CustomFadeIn(
                transform: false,
                delay: 0.0,
                opacityDuration: 300,
                transformDuration: 0,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 2 * SizeConfig.heightMultiplier,
                      bottom: 2 * SizeConfig.heightMultiplier,
                      left: (Device.get().isTablet ? 12 : 5) *
                          SizeConfig.widthMultiplier),
                  child: Container(
                    child: Text(
                      'Your phone number',
                      style: TextStyle(
                          color: ColorPalette.PrimaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'RubikBold',
                          fontSize: 6 * SizeConfig.textMultiplier),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 5 * SizeConfig.widthMultiplier),
                child: CustomFadeIn(
                    transform: false,
                    delay: 0.5,
                    opacityDuration: 300,
                    transformDuration: 0,
                    child: CustomTextField(
                        hintText: '...',
                        controller: _phoneController,
                        obscureTextMode: true)),
              ),
              CustomFadeIn(
                transform: false,
                delay: 2.0,
                opacityDuration: 300,
                transformDuration: 0,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 2 * SizeConfig.heightMultiplier,
                      bottom: 2 * SizeConfig.heightMultiplier,
                      left: (Device.get().isTablet ? 12 : 5) *
                          SizeConfig.widthMultiplier),
                  child: Container(
                    child: Text(
                      'Your home address',
                      style: TextStyle(
                          color: ColorPalette.PrimaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'RubikBold',
                          fontSize: 6 * SizeConfig.textMultiplier),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 5 * SizeConfig.widthMultiplier),
                child: CustomFadeIn(
                    transform: false,
                    delay: 2.5,
                    opacityDuration: 300,
                    transformDuration: 0,
                    child: CustomTextField(
                        hintText: '...',
                        controller: _addressController,
                        obscureTextMode: true)),
              ),
              CustomBounceAnimation(
                onTap: () async {
                  if (_phoneController.text != "" &&
                      _addressController.text != "") {
                    final UserBloc user = Provider.of<UserBloc>(context);
                    await user
                        .updatePhoneAndAddress(
                            phone: _phoneController.text,
                            address: _addressController.text)
                        .then((_) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashboardPage()));
                    });
                  } else {
                    setState(() {
                      _fieldEmpty = true;
                    });
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 25 * SizeConfig.widthMultiplier,
                      vertical: 5 * SizeConfig.heightMultiplier),
                  child: Container(
                    height: 8 * SizeConfig.heightMultiplier,
                    decoration: BoxDecoration(
                      color: ColorPalette.AccentColor,
                      borderRadius: BorderRadius.circular(
                          5 * SizeConfig.heightMultiplier),
                    ),
                    child: Center(
                      child: Text(
                        'Complete',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'RubikMedium',
                            fontSize: 2.5 * SizeConfig.textMultiplier),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
