import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:qpv_client_app/blocs/authenticate_bloc.dart';
import 'package:qpv_client_app/blocs/user_bloc.dart';
import 'package:qpv_client_app/components/custom_bounce_on_tap.dart';
import 'package:qpv_client_app/components/custom_fade_in.dart';
import 'package:qpv_client_app/components/custom_text_field.dart';
import 'package:qpv_client_app/helper/size_config.dart';
import 'package:qpv_client_app/ui/intro_page.dart';
import 'package:qpv_client_app/ui/signup_page.dart';

import '../constant.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  Icon _suffixIconController = Icon(FlevaIcons.eye_off, color: Colors.grey);

  /// Show password controller
  bool _showPassword = true;

  /// Check if the login is success or not
  bool _isNotSuccess = false;

  /// Check if the fields are empty
  bool _isEmpty = false;

  /// Show loading spinner in async task
  bool _showSpinner = false;

  void _signInWithEmailPassword(BuildContext context) async {
    setState(() {
      _showSpinner = true;
    });

    // Fields are not empty
    if (_emailController.text != "" && _passwordController.text != "") {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      final AuthenticateBloc signInBloc =
          Provider.of<AuthenticateBloc>(context);
      await signInBloc
          .signInWithEmailAndPassword(
              _emailController.text, _passwordController.text, context)
          .then((_) {
        _updateUserDataLogin(signInBloc);
      });

      if (signInBloc.hasError) {
        setState(() {
          _isNotSuccess = true;
        });
      }
      setState(() {
        _showSpinner = false;
      });
    } else // Fields are not empty
    {
      setState(() {
        _showSpinner = false;
        _isNotSuccess = false;
        _isEmpty = true;
      });
    }
  }

  void _updateUserDataLogin(signInBloc) {
    if (signInBloc.hasError == true ||
        signInBloc.uid == null ||
        signInBloc.uid == "") {
      setState(() {
        _isNotSuccess = true;
      });
    } else {
      print('Update user data: ${signInBloc.uid}');
      signInBloc.userExistCheck().then((value) {
        if (signInBloc.userExists) {
//          setState(() {
//            _showSpinner = false;
//          });

          signInBloc
              .setUidToLocalStorage()
              .then((value) => signInBloc.setSignInStatus().then((value) async {
                    final UserBloc userBloc = Provider.of<UserBloc>(context);
                    await userBloc.getUserFirestore();
                    await userBloc.getUserParcels();
                    print('User Exists. Initialize local storage');
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (_, __, ___) => IntroPage()));
                  }));
        } else {
          setState(() {
            _showSpinner = false;
          });
          signInBloc.setUidToLocalStorage().then((value) => signInBloc
              .addUserToFirestoreDatabase()
              .then((value) => signInBloc.setSignInStatus().then((value) =>
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => IntroPage())))));
        }
      });
    }
  }

  /// All sign-in methods using social media accounts
  void _signInWithSocialPlatform(BuildContext context, String init) async {
    setState(() {
      _showSpinner = true;
    });

    final AuthenticateBloc signInBloc = Provider.of<AuthenticateBloc>(context);

    switch (init) {
      case "GG":
        await signInBloc.signInWithGoogle(context).then((_) {
          _updateUserDataLogin(signInBloc);
        });
        break;
      case "FB":
        await signInBloc.signInWithFacebook(context).then((_) {
          _updateUserDataLogin(signInBloc);
        });
//      case "TW":
////        await signInBloc.signInWithTwitter(context).then((_) {
////          _updateUserDataLogin(signInBloc);
////        });
        break;
    }
    setState(() {
      _showSpinner = false;
    });
  }

  /// Event when users tap on Show password icon
  void _onTapShowPassword() {
    if (_showPassword == true)
      setState(() {
        _showPassword = false;
        _suffixIconController = Icon(FlevaIcons.eye, color: Colors.grey);
      });
    else {
      setState(() {
        _showPassword = true;
        _suffixIconController = Icon(FlevaIcons.eye_off, color: Colors.grey);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            body: ModalProgressHUD(
              progressIndicator: SpinKitFadingFour(
                color: ColorPalette.PrimaryColor,
              ),
              inAsyncCall: _showSpinner,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomFadeIn(
                            transform: false,
                            delay: 1.0,
                            opacityDuration: 300,
                            transformDuration: 0,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: 4 * SizeConfig.heightMultiplier,
                                  left: 7 * SizeConfig.widthMultiplier,
                                  right: 10 * SizeConfig.widthMultiplier),
                              child: Container(
                                child: Text(
                                  'Hello there!',
                                  style: TextStyle(
                                      color: ColorPalette.PrimaryTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'RubikBold',
                                      fontSize: 10 * SizeConfig.textMultiplier),
                                ),
                              ),
                            ),
                          ),
                          (_isNotSuccess == true)
                              ? Center(
                                  child: Text(
                                    'Incorrect email address or password.',
                                    style: TextStyle(
                                      color: ColorPalette.AccentColor,
                                      fontSize: 1.75 *
                                          SizeConfig
                                              .textMultiplier, // = size 14
                                      fontFamily: 'RubikBold',
                                    ),
                                  ),
                                )
                              : (_isEmpty == true
                                  ? Center(
                                      child: Text(
                                        'Please enter all required fields.',
                                        style: TextStyle(
                                          color: ColorPalette.AccentColor,
                                          fontSize: 1.75 *
                                              SizeConfig
                                                  .textMultiplier, // = size 14
                                          fontFamily: 'RubikBold',
                                        ),
                                      ),
                                    )
                                  : Container()),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5 * SizeConfig.widthMultiplier),
                            child: CustomFadeIn(
                                transform: false,
                                delay: 3.0,
                                opacityDuration: 300,
                                transformDuration: 0,
                                child: CustomTextField(
                                    hintText: 'Email address',
                                    controller: _emailController,
                                    obscureTextMode: false)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5 * SizeConfig.widthMultiplier),
                            child: CustomFadeIn(
                                transform: false,
                                delay: 3.0,
                                opacityDuration: 300,
                                transformDuration: 0,
                                child: CustomTextField(
                                    showPassword: _showPassword,
                                    onTapShowPassword: _onTapShowPassword,
                                    suffixIconController: _suffixIconController,
                                    hintText: 'Password',
                                    controller: _passwordController,
                                    obscureTextMode: true)),
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 1,
                          ),
                          CustomFadeIn(
                            transform: false,
                            delay: 3.0,
                            transformDuration: 0,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10 * SizeConfig.widthMultiplier),
                              child: CustomBounceAnimation(
                                onTap: () {
//                              _showDialog(
//                                  message: 'forgot_password_message'.tr(),
//                                  success: true);
                                },
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text("Forgot password?",
                                      style: TextStyle(
                                        fontSize: 2 * SizeConfig.textMultiplier,
                                        fontFamily: 'Rubik',
                                        color: ColorPalette.PrimaryTextColor,
                                      )),
                                ),
                              ),
                            ),
                          ),
                          CustomBounceAnimation(
                            onTap: () async {
                              _signInWithEmailPassword(context);
                            },
                            child: CustomFadeIn(
                              transform: false,
                              delay: 3.0,
                              opacityDuration: 300,
                              transformDuration: 0,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 5 * SizeConfig.heightMultiplier,
                                  bottom: 3 * SizeConfig.heightMultiplier,
                                ),
                                child: Center(
                                  child: Container(
                                    height: 7 * SizeConfig.heightMultiplier,
                                    width: 45 * SizeConfig.widthMultiplier,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            Color(0xff4C87D5),
                                            Color(0xff1256B1),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'SIGN IN',
                                        style: TextStyle(
                                            fontSize:
                                                2.5 * SizeConfig.textMultiplier,
                                            fontFamily: 'RubikMedium'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          CustomFadeIn(
                            transform: false,
                            delay: 3.0,
                            opacityDuration: 300,
                            transformDuration: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                SizedBox(
                                  width: 20 * SizeConfig.widthMultiplier,
                                  child: Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  ),
                                ),
                                Text(
                                  'or connect with',
                                  style: TextStyle(
                                      color: ColorPalette.PrimaryTextColor,
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                      fontFamily: 'Rubik'),
                                ),
                                SizedBox(
                                  width: 20 * SizeConfig.widthMultiplier,
                                  child: Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 4 * SizeConfig.heightMultiplier,
                          ),
                          CustomFadeIn(
                            transform: false,
                            delay: 3.0,
                            opacityDuration: 300,
                            transformDuration: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CustomBounceAnimation(
                                  child: Icon(
                                    FlevaIcons.google_outline,
                                    color: ColorPalette.AccentColor,
                                    size: 5 * SizeConfig.heightMultiplier,
                                  ),
                                  onTap: () async {
                                    _signInWithSocialPlatform(context, "GG");
                                  },
                                ),
                                SizedBox(
                                  width: 8 * SizeConfig.widthMultiplier,
                                ),
                                CustomBounceAnimation(
                                  child: Icon(
                                    FlevaIcons.facebook_outline,
                                    color: ColorPalette.AccentColor,
                                    size: 5 * SizeConfig.heightMultiplier,
                                  ),
                                  onTap: () async {
                                    _signInWithSocialPlatform(context, "FB");
                                  },
                                ),

                                // Logo on top of header
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 4 * SizeConfig.heightMultiplier,
                          ),
                          CustomFadeIn(
                            transform: false,
                            delay: 3.0,
                            opacityDuration: 300,
                            transformDuration: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Don\'t have an account?',
                                  style: TextStyle(
                                      color: ColorPalette.PrimaryTextColor,
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                      fontFamily: 'Rubik'),
                                ),
                                CustomBounceAnimation(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterPage()));
                                  },
                                  child: Text(
                                    ' ' + 'Sign Up',
                                    style: TextStyle(
                                        color: ColorPalette.PrimaryTextColor,
                                        fontSize: 2 * SizeConfig.textMultiplier,
                                        fontFamily: 'RubikBold'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )));
  }
}
