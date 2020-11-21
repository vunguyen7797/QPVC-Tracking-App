import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qpv_client_app/blocs/user_bloc.dart';
import 'package:qpv_client_app/ui/splash_page.dart';

import 'blocs/authenticate_bloc.dart';
import 'constant.dart';
import 'helper/size_config.dart';
import 'local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalStorage.init();
  await Firebase.initializeApp();

  runApp(QpvClientApp());
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class QpvClientApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticateBloc>(
          create: (context) => AuthenticateBloc(),
        ),
        ChangeNotifierProvider<UserBloc>(
          create: (context) => UserBloc(),
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          return OrientationBuilder(
            builder: (context, orientation) {
              SizeConfig().init(constraints, orientation);
              return MaterialApp(
                builder: (context, child) {
                  return ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: child,
                  );
                },
                debugShowCheckedModeBanner: false,
                theme: ThemeData.dark().copyWith(
                  primaryColor: ColorPalette.PrimaryColor,
                  accentColor: ColorPalette.AccentColor,
                  textSelectionColor: ColorPalette.PrimaryTextColor,
                  dialogTheme: DialogTheme.of(context).copyWith(
                      backgroundColor: Colors.grey,
                      contentTextStyle:
                          TextStyle(color: ColorPalette.PrimaryTextColor)),
                ),
                initialRoute: '/',
                routes: {
                  '/': (context) => SplashPage(),
                },
              );
            },
          );
        },
      ),
    );
  }
}
