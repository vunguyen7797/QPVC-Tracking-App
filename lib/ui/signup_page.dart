import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:qpv_client_app/blocs/authenticate_bloc.dart';
import 'package:qpv_client_app/cognitiveFaceServices/face_service_rest_client.dart';
import 'package:qpv_client_app/components/custom_bounce_on_tap.dart';
import 'package:qpv_client_app/components/custom_fade_in.dart';
import 'package:qpv_client_app/components/custom_text_field.dart';
import 'package:qpv_client_app/helper/size_config.dart';

import '../constant.dart';
import 'intro_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _fullNameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _countryController = new TextEditingController();
  Icon _suffixIconController = Icon(FlevaIcons.eye_off, color: Colors.grey);
  final client = FaceServiceClient(key, serviceHost: endpoint);

  /// Show loading spinner in async task
  bool _showSpinner = false;

  /// Check if the login is success or not
  bool _isNotSuccess = false;

  /// Check if the fields are empty
  bool _isEmpty = false;

  /// Show password controller
  bool _showPassword = true;

  /// Sign up new account using email and password
  void _signUpWithEmailAndPassword() async {
    setState(() {
      _showSpinner = true;
    });

    // Fields are not empty
    if (_passwordController.text != "" &&
        _emailController.text != "" &&
        _fullNameController.text != "") {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      final AuthenticateBloc signInBloc =
          Provider.of<AuthenticateBloc>(context);

      await signInBloc
          .signUpWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
        context,
        _fullNameController.text,
      )
          .then((value) {
        setState(() {
          _showSpinner = false;
        });
        if (signInBloc.hasError == false) {
          signInBloc.setUidToLocalStorage().then((value) => signInBloc
              .addUserToFirestoreDatabase()
              .then((value) => signInBloc.setSignInStatus().then((value) =>
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => IntroPage())))));
        } else
          setState(() {
            _isNotSuccess = true;
          });
      });
    } else {
      setState(() {
        _showSpinner = false;
        _isNotSuccess = false;
        _isEmpty = true;
      });
    }
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
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        progressIndicator: SpinKitFadingFour(
          color: ColorPalette.PrimaryColor,
        ),
        inAsyncCall: _showSpinner,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Body part
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 8 * SizeConfig.heightMultiplier,
                          horizontal: 5 * SizeConfig.widthMultiplier),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
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
                                  'Join Us!',
                                  style: TextStyle(
                                      color: ColorPalette.PrimaryTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'RubikBold',
                                      fontSize: 10 * SizeConfig.textMultiplier),
                                ),
                              ),
                            ),
                          ),
                          _isNotSuccess == true
                              ? Text(
                                  'Register failed. Please try again',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: ColorPalette.AccentColor,
                                    fontSize: 1.75 *
                                        SizeConfig.textMultiplier, // = size 14
                                    fontFamily: 'RubikBold',
                                  ),
                                )
                              : (_isEmpty == true
                                  ? Text(
                                      'Please enter all required fields.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: ColorPalette.AccentColor,
                                        fontSize: 1.75 *
                                            SizeConfig
                                                .textMultiplier, // = size 14
                                        fontFamily: 'RubikBold',
                                      ),
                                    )
                                  : Container()),
                          CustomTextField(
                              hintText: 'Legal full name',
                              controller: _fullNameController,
                              obscureTextMode: false,
                              keyboardType: TextInputType.text),
                          CustomTextField(
                              hintText: 'Email address',
                              controller: _emailController,
                              obscureTextMode: false,
                              keyboardType: TextInputType.emailAddress),
                          CustomTextField(
                              showPassword: _showPassword,
                              onTapShowPassword: _onTapShowPassword,
                              suffixIconController: _suffixIconController,
                              hintText: 'Password',
                              controller: _passwordController,
                              obscureTextMode: true,
                              keyboardType: TextInputType.visiblePassword),
                          SizedBox(
                            height: 1 * SizeConfig.heightMultiplier,
                          ),
                          CustomBounceAnimation(
                            onTap: () async {
                              _signUpWithEmailAndPassword();
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
                                        'SIGN UP',
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
                          SizedBox(
                            height: 2 * SizeConfig.heightMultiplier,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Already have an account?' + ' ',
                                style: TextStyle(
                                    color: ColorPalette.PrimaryTextColor,
                                    fontSize: 2 * SizeConfig.textMultiplier,
                                    fontFamily: 'Rubik'),
                              ),
                              CustomBounceAnimation(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                      color: ColorPalette.PrimaryTextColor,
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                      fontFamily: 'RubikBold'),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
