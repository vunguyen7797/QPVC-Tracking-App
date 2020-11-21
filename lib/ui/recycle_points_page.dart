import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qpv_client_app/blocs/user_bloc.dart';
import 'package:qpv_client_app/constant.dart';

class RecyclePointPage extends StatefulWidget {
  @override
  _RecyclePointPageState createState() => _RecyclePointPageState();
}

class _RecyclePointPageState extends State<RecyclePointPage> {
  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = Provider.of<UserBloc>(context);
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight),
          child: Container(
            color: Color(0xffF5F8FA),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                          child: Text(
                        "Your Recycle points",
                        style: TextStyle(
                            color: ColorPalette.PrimaryTextColor,
                            fontSize: 47,
                            fontFamily: "RubikBold"),
                      ))
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                    decoration: BoxDecoration(
                        color: ColorPalette.AccentColor,
                        borderRadius: BorderRadius.circular(30)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${userBloc.recyclePoints}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 100,
                              fontFamily: "RubikBold"),
                        ),
                        Text(
                          "10 more to get your new coupon!",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: "RubikBold"),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Your available rewards",
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: "RubikBold",
                        color: ColorPalette.PrimaryTextColor),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Column(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25)),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Image.asset(
                                "res/images/lazada_logo.png",
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Lazada Vietnam",
                                    style: TextStyle(
                                        color: ColorPalette.PrimaryTextColor,
                                        fontFamily: "RubikBold"),
                                  ),
                                  Text(
                                    "5% off and freeship",
                                    style: TextStyle(
                                        color: ColorPalette.PrimaryTextColor,
                                        fontFamily: "Rubik"),
                                  ),
                                  Text(
                                    "Expires Dec 21, 2020",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: "Rubik"),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        width: double.infinity,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25)),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Image.asset(
                                "res/images/lazada_logo.png",
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Lazada Vietnam",
                                    style: TextStyle(
                                        color: ColorPalette.PrimaryTextColor,
                                        fontFamily: "RubikBold"),
                                  ),
                                  Text(
                                    "5% off and freeship",
                                    style: TextStyle(
                                        color: ColorPalette.PrimaryTextColor,
                                        fontFamily: "Rubik"),
                                  ),
                                  Text(
                                    "Expires Dec 21, 2020",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: "Rubik"),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
