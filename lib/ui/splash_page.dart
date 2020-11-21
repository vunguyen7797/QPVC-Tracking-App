import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qpv_client_app/blocs/authenticate_bloc.dart';
import 'package:qpv_client_app/blocs/user_bloc.dart';
import 'package:qpv_client_app/components/custom_fade_in.dart';
import 'package:qpv_client_app/helper/size_config.dart';
import 'package:qpv_client_app/local_storage.dart';
import 'package:qpv_client_app/ui/dashboard_page.dart';
import 'package:qpv_client_app/ui/info_verify_page.dart';
import 'package:qpv_client_app/ui/login_page.dart';
import 'package:qpv_client_app/ui/verification_options_page.dart';
import 'package:shimmer/shimmer.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    Key key,
  }) : super(key: key);
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int numOfFaces = 0;
  String address = "";
  @override
  void initState() {
    super.initState();

    Future.delayed(
      Duration(seconds: 2),
      () async {
        final AuthenticateBloc signInBloc =
            Provider.of<AuthenticateBloc>(context);

        if (LocalStorage.instance.get('uid') != null ||
            LocalStorage.instance.get('uid') != "") {
          print(LocalStorage.instance.get('uid'));
          final UserBloc userBloc = Provider.of<UserBloc>(context);
          numOfFaces = userBloc.numOfFaces;
          address = userBloc.address;
//          await userBloc.getUserFirestore().then((value) {
//            if (value != null && value.data() != null) {
//              print(value.data()['num_faces']);
//              numOfFaces = value.data()['num_faces'];
//              address = value.data()['addr'];
//            } else {
//              print(value.data());
//            }
//          });
        }

        signInBloc.isLoggedIn();

        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => signInBloc.isSignedIn == false
                    ? LoginPage()
                    : CustomFadeIn(
                        transform: false,
                        transformDuration: 0,
                        delay: 0,
                        child: numOfFaces == 0
                            ? VerificationOptionsPage()
                            : address != ""
                                ? DashboardPage()
                                : InfoVerifyPage())));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xff4C87D5),
              Color(0xff1256B1),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: CustomFadeIn(
            transform: false,
            delay: 0.0,
            opacityDuration: 1000,
            transformDuration: 0,
            child: Center(
              child: Container(
                child: Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: Color(0xff253B80),
                  child: Text(
                    'QPVC',
                    style: TextStyle(
                        fontFamily: 'RubikBold',
                        fontWeight: FontWeight.bold,
                        fontSize: 6 * SizeConfig.textMultiplier),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
