import 'package:cached_network_image/cached_network_image.dart';
import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:qpv_client_app/blocs/authenticate_bloc.dart';
import 'package:qpv_client_app/blocs/user_bloc.dart';
import 'package:qpv_client_app/components/custom_bounce_on_tap.dart';
import 'package:qpv_client_app/components/custom_fade_in.dart';
import 'package:qpv_client_app/helper/size_config.dart';
import 'package:qpv_client_app/local_storage.dart';
import 'package:qpv_client_app/ui/login_page.dart';

import '../constant.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  /// Show loading spinner in async task
  bool _showSpinner = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F8FA),
      body: ModalProgressHUD(
        progressIndicator: SpinKitFadingFour(
          color: ColorPalette.PrimaryColor,
        ),
        inAsyncCall: _showSpinner,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    // Header background
                    Container(
                        height: 28 * SizeConfig.heightMultiplier,
                        width: double.infinity,
                        child: _buildHeaderBackground()),
                    // Account information card
                    _buildUserInfo(context: context),
                  ],
                ),
              ),
              SizedBox(
                height: 0.5 * SizeConfig.heightMultiplier,
              ),
              _buildWidgetBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetBody() {
    return Padding(
      padding: EdgeInsets.all(5 * SizeConfig.widthMultiplier),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CustomFadeIn(
                delay: 0,
                transformDuration: 0,
                child: Container(
                  height: 18.5 * SizeConfig.heightMultiplier,
                  width: 38.5 * SizeConfig.widthMultiplier,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: ColorPalette.SecondaryColor.withOpacity(0.4),
                          offset: Offset(0, 0),
                          blurRadius: 10,
                          spreadRadius: 1)
                    ],
                    gradient: LinearGradient(colors: [
                      ColorPalette.PrimaryColor,
                      ColorPalette.SecondaryColor,
                    ], begin: Alignment.topLeft, end: Alignment.center),
                    borderRadius:
                        BorderRadius.circular(5 * SizeConfig.heightMultiplier),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        padding: EdgeInsets.only(
                            top: 3 * SizeConfig.heightMultiplier,
                            left: 5 * SizeConfig.widthMultiplier),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              5 * SizeConfig.heightMultiplier),
                          child: Icon(
                            FlevaIcons.star_outline,
                            color: Colors.white.withOpacity(0.1),
                            size: 25 * SizeConfig.heightMultiplier,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                            margin: EdgeInsets.only(
                                right: 20 * SizeConfig.widthMultiplier,
                                top: 2 * SizeConfig.heightMultiplier),
                            child: Icon(
                              FlevaIcons.star_outline,
                              color: Colors.white,
                              size: 3.5 * SizeConfig.heightMultiplier,
                            )),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: 2.5 * SizeConfig.heightMultiplier,
                              left: 4 * SizeConfig.widthMultiplier,
                              right: 4 * SizeConfig.widthMultiplier),
                          child: Text(
                            'Rate Me!',
                            overflow: TextOverflow.clip,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'RubikMedium',
                              color: Colors.white,
                              fontSize: 1.75 * SizeConfig.textMultiplier,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CustomBounceAnimation(
                onTap: () {},
                child: _buildSettingRoundedButton(
                    delay: 0.5,
                    icon: FlevaIcons.person_outline,
                    text: 'Id Verification'),
              ),
            ],
          ),
          SizedBox(
            height: 2.5 * SizeConfig.heightMultiplier,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CustomBounceAnimation(
                onTap: () {},
                child: _buildSettingRoundedButton(
                    delay: 0.8,
                    icon: FlevaIcons.credit_card_outline,
                    text: 'Payment Methods'),
              ),
              CustomBounceAnimation(
                onTap: () {},
                child: _buildSettingRoundedButton(
                    delay: 1.1,
                    icon: FlevaIcons.settings_2_outline,
                    text: 'Settings'),
              ),
            ],
          ),
          SizedBox(
            height: 2.5 * SizeConfig.heightMultiplier,
          ),
          CustomBounceAnimation(
            onTap: () {
              final AuthenticateBloc authBloc =
                  Provider.of<AuthenticateBloc>(context);
              authBloc.clearAllData();
              authBloc.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: CustomFadeIn(
              delay: 1.4,
              transformDuration: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 5.0 * SizeConfig.widthMultiplier),
                child: Container(
                  height: 7 * SizeConfig.heightMultiplier,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withOpacity(0.2),
                        offset: Offset(0, 1),
                        blurRadius: 20,
                        spreadRadius: 0.5,
                      )
                    ],
                    borderRadius:
                        BorderRadius.circular(5 * SizeConfig.heightMultiplier),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                5 * SizeConfig.heightMultiplier),
                            child: Icon(
                              FlevaIcons.log_out,
                              color: Colors.grey.withOpacity(0.1),
                              size: 12.5 * SizeConfig.heightMultiplier,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Text(
                            'Sign Out',
                            overflow: TextOverflow.clip,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Rubik',
                                color: ColorPalette.SecondaryColor,
                                fontSize: 2 * SizeConfig.textMultiplier,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRoundedButton({delay, icon, text}) {
    return CustomFadeIn(
      delay: delay,
      transformDuration: 0,
      child: Container(
        height: 18.5 * SizeConfig.heightMultiplier,
        width: 38.5 * SizeConfig.widthMultiplier,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.2),
              offset: Offset(0, 1),
              blurRadius: 20,
              spreadRadius: 0.5,
            )
          ],
          borderRadius: BorderRadius.circular(5 * SizeConfig.heightMultiplier),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(
                    top: 3 * SizeConfig.heightMultiplier,
                    left: 5 * SizeConfig.widthMultiplier),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(5 * SizeConfig.heightMultiplier),
                  child: Container(
                    child: Icon(
                      icon,
                      color: Colors.grey.withOpacity(0.1),
                      size: 25 * SizeConfig.heightMultiplier,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                  margin: EdgeInsets.only(
                      right: 20 * SizeConfig.widthMultiplier,
                      top: 2 * SizeConfig.heightMultiplier),
                  child: Icon(
                    icon,
                    color: ColorPalette.SecondaryColor,
                    size: 3.5 * SizeConfig.heightMultiplier,
                  )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(
                    bottom: 2.5 * SizeConfig.heightMultiplier,
                    left: 4 * SizeConfig.widthMultiplier,
                    right: 4 * SizeConfig.widthMultiplier),
                child: Text(
                  text,
                  overflow: TextOverflow.clip,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'RubikMedium',
                    color: ColorPalette.SecondaryColor,
                    fontSize: 1.75 * SizeConfig.textMultiplier,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBackground() {
    return Stack(
      children: <Widget>[
        Card(
          elevation: 0,
          margin: EdgeInsets.only(bottom: 2.5 * SizeConfig.heightMultiplier),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5 * SizeConfig.heightMultiplier),
                bottomRight: Radius.circular(5 * SizeConfig.heightMultiplier)),
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: ColorPalette.SecondaryColor.withOpacity(0.4),
                    offset: Offset(0, 0),
                    blurRadius: 10,
                    spreadRadius: 1)
              ],
              gradient: LinearGradient(colors: [
                ColorPalette.PrimaryColor,
                ColorPalette.SecondaryColor,
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5 * SizeConfig.heightMultiplier),
                  bottomRight:
                      Radius.circular(5 * SizeConfig.heightMultiplier)),
            ),
          ),
        ),
        Positioned(
          left: 56 * SizeConfig.widthMultiplier,
          top: 10 * SizeConfig.heightMultiplier,
          bottom: -10 * SizeConfig.heightMultiplier,
          right: -15 * SizeConfig.widthMultiplier,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 10 * SizeConfig.widthMultiplier),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5 * SizeConfig.heightMultiplier),
                  bottomRight: Radius.circular(5 * SizeConfig.heightMultiplier),
                  topLeft: Radius.circular(15 * SizeConfig.heightMultiplier),
                  topRight: Radius.circular(14 * SizeConfig.heightMultiplier)),
            ),
          ),
        ),
        Positioned(
          left: -15 * SizeConfig.widthMultiplier,
          top: -10 * SizeConfig.heightMultiplier,
          bottom: 10 * SizeConfig.heightMultiplier,
          right: 56 * SizeConfig.widthMultiplier,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 10 * SizeConfig.widthMultiplier),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15 * SizeConfig.heightMultiplier),
                  bottomRight:
                      Radius.circular(15 * SizeConfig.heightMultiplier),
                  topLeft: Radius.circular(5 * SizeConfig.heightMultiplier),
                  topRight: Radius.circular(5 * SizeConfig.heightMultiplier)),
            ),
          ),
        ),
      ],
    );
  }

  /// Stream the user information from firebase database
  Widget _buildUserInfo({BuildContext context}) {
    final userBloc = Provider.of<UserBloc>(context);

    return Padding(
      padding: EdgeInsets.only(
          top: 10 * SizeConfig.heightMultiplier,
          left: 5 * SizeConfig.widthMultiplier,
          right: 5 * SizeConfig.widthMultiplier),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(5 * SizeConfig.heightMultiplier)),
        elevation: 0,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey.withOpacity(0.2),
                offset: Offset(0, 1),
                blurRadius: 20,
                spreadRadius: 0.5,
              )
            ],
            borderRadius:
                BorderRadius.circular(5 * SizeConfig.heightMultiplier),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 0 * SizeConfig.heightMultiplier),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'ProfilePic',
                  child: CachedNetworkImage(
                    imageUrl:
                        userBloc.imageUrl == null || userBloc.imageUrl == ""
                            ? LocalStorage.instance.get('photoUrl')
                            : userBloc.imageUrl,
                    imageBuilder: (context, imageProvider) => ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft:
                              Radius.circular(2 * SizeConfig.heightMultiplier),
                          bottomRight:
                              Radius.circular(2 * SizeConfig.heightMultiplier)),
                      child: Container(
                        height: 14 * SizeConfig.heightMultiplier,
                        width: 35 * SizeConfig.widthMultiplier,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      height: 14 * SizeConfig.heightMultiplier,
                      width: 35 * SizeConfig.widthMultiplier,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(
                                2 * SizeConfig.heightMultiplier),
                            bottomRight: Radius.circular(
                                2 * SizeConfig.heightMultiplier)),
                        color: Colors.white30,
                      ),
                      child: SpinKitFadingFour(
                        color: Colors.grey,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                SizedBox(
                  height: 1.5 * SizeConfig.heightMultiplier,
                ),
                Text(
                  userBloc.name == null ? '' : userBloc.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 2 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RubikBold',
                    letterSpacing: 1,
                    color: ColorPalette.PrimaryTextColor,
                  ),
                ),
                SizedBox(
                  height: 0.5 * SizeConfig.heightMultiplier,
                ),
                Text(
                  userBloc.email == null ? '' : userBloc.email,
                  style: TextStyle(
                    fontSize: 1.75 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 1.5 * SizeConfig.heightMultiplier,
                ),
                CustomBounceAnimation(
                  onTap: () {},
                  child: Container(
                    height: 4 * SizeConfig.heightMultiplier,
                    width: 10 * SizeConfig.widthMultiplier,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(
                                2 * SizeConfig.heightMultiplier),
                            topLeft: Radius.circular(
                                2 * SizeConfig.heightMultiplier))),
                    child: Icon(
                      FlevaIcons.edit_outline,
                      color: Colors.black,
                      size: 2.5 * SizeConfig.heightMultiplier,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
