import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qpv_client_app/blocs/user_bloc.dart';
import 'package:qpv_client_app/local_storage.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  String test = '';
  _saveDeviceToken() async {
    String uid = LocalStorage.instance.get('uid');
    print(uid);
    // get token for this device
    String fcmToken = await _fcm.getToken();
    Future.delayed(Duration(seconds: 0)).then((_) async {
      final UserBloc userBloc = Provider.of<UserBloc>(context);
      userBloc.saveTokenId(tokenId: fcmToken);
    });
  }

  @override
  void initState() {
    super.initState();
    _saveDeviceToken();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        final snackbar = SnackBar(
            content: Text(message['notification']['title']),
            action: SnackBarAction(
              label: 'Go',
              onPressed: () => null,
            ));
        Scaffold.of(context).showSnackBar(snackbar);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Text(
            'HELLO',
            style: TextStyle(color: Colors.black),
          )),
    );
  }
}
