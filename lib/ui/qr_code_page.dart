import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qpv_client_app/blocs/user_bloc.dart';
import 'package:qpv_client_app/components/custom_bounce_on_tap.dart';
import 'package:qpv_client_app/constant.dart';
import 'package:qpv_client_app/helper/size_config.dart';

class QrCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = Provider.of<UserBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.only(top: 20, left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomBounceAnimation(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xffC6DDF7)),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: Text(
                    'YOUR QR IDENTITY',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorPalette.PrimaryTextColor,
                        fontSize: 5 * SizeConfig.textMultiplier,
                        fontFamily: 'RubikBold'),
                  ),
                ),
                Expanded(
                  child: Container(child: Image.network(userBloc.qrCode)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
