import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qpv_client_app/components/custom_bounce_on_tap.dart';
import 'package:qpv_client_app/constant.dart';
import 'package:qpv_client_app/model/parcel.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TrackingPage extends StatefulWidget {
  final Parcel item;

  const TrackingPage({Key key, this.item}) : super(key: key);
  @override
  _TrackingPageState createState() => _TrackingPageState(this.item);
}

class _TrackingPageState extends State<TrackingPage> {
  Parcel item;

  _TrackingPageState(this.item);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xffF5F8FA),
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: TrackingPageHeader(120, 120),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tracking",
                        style: TextStyle(
                            fontSize: 40,
                            fontFamily: "RubikBold",
                            color: ColorPalette.PrimaryTextColor),
                      ),
                      Text(
                        "${item.tracking}",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Rubik",
                            color: ColorPalette.PrimaryTextColor),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 250,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  decoration: BoxDecoration(
                      color: ColorPalette.PrimaryColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "From: ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "RubikBold"),
                          ),
                          Text(
                            "${item.address}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "Rubik"),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "To: ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "RubikBold"),
                          ),
                          Text(
                            "${item.destination}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "Rubik"),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Weight: ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "RubikBold"),
                          ),
                          Text(
                            "${item.weight}kgs",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "Rubik"),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Total pieces: ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "RubikBold"),
                          ),
                          Text(
                            "${item.totalPieces}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "Rubik"),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Ship date: ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "RubikBold"),
                          ),
                          Text(
                            "${item.shipDate}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "Rubik"),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Estimate time: ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "RubikBold"),
                          ),
                          Text(
                            "${item.estimateTime} days",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "Rubik"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Travel History",
                    style: TextStyle(
                        color: ColorPalette.PrimaryTextColor,
                        fontFamily: "RubikBold",
                        fontSize: 28),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    children: [
                      TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.0,
                        isFirst: true,
                        indicatorStyle: IndicatorStyle(
                            width: 25,
                            indicatorXY: 0.1,
                            color: ColorPalette.PrimaryColor),
                        beforeLineStyle:
                            LineStyle(color: Colors.black, thickness: 3),
                        endChild: Container(
                          padding: EdgeInsets.only(left: 20),
                          constraints: BoxConstraints(minHeight: 90),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hue",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: ColorPalette.PrimaryTextColor,
                                    fontFamily: "RubikBold"),
                              ),
                              Text(
                                "Arrived at Station No. 1234, Slot #13",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: ColorPalette.PrimaryTextColor,
                                    fontFamily: "Rubik"),
                              ),
                              Text(
                                "Waiting for pick-up",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: ColorPalette.PrimaryTextColor,
                                    fontFamily: "Rubik"),
                              ),
                              Text(
                                "Mon, 10/29/2020 5:30 PM",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontFamily: "Rubik"),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.0,
                        indicatorStyle: IndicatorStyle(
                            width: 25,
                            indicatorXY: 0.1,
                            color: Color(0xffC6DDF7)),
                        beforeLineStyle:
                            LineStyle(color: Colors.black, thickness: 3),
                        endChild: Container(
                          padding: EdgeInsets.only(left: 20),
                          constraints: BoxConstraints(minHeight: 90),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Danang",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: ColorPalette.PrimaryTextColor,
                                    fontFamily: "RubikBold"),
                              ),
                              Text(
                                "Arrived local facility",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: ColorPalette.PrimaryTextColor,
                                    fontFamily: "Rubik"),
                              ),
                              Text(
                                "Ready to be delivered to Hue",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: ColorPalette.PrimaryTextColor,
                                    fontFamily: "Rubik"),
                              ),
                              Text(
                                "Mon, 10/28/2020  6:30 PM",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontFamily: "Rubik"),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.0,
                        indicatorStyle: IndicatorStyle(
                            width: 25,
                            indicatorXY: 0.1,
                            color: Color(0xffC6DDF7)),
                        beforeLineStyle:
                            LineStyle(color: Colors.black, thickness: 3),
                        endChild: Container(
                          padding: EdgeInsets.only(left: 20),
                          constraints: BoxConstraints(minHeight: 90),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hanoi",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: ColorPalette.PrimaryTextColor,
                                    fontFamily: "RubikBold"),
                              ),
                              Text(
                                "Left origin facility",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: ColorPalette.PrimaryTextColor,
                                    fontFamily: "Rubik"),
                              ),
                              Text(
                                "Mon, 10/26/2020 8:30 PM",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontFamily: "Rubik"),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.0,
                        isLast: true,
                        indicatorStyle: IndicatorStyle(
                            width: 25,
                            indicatorXY: 0.1,
                            color: ColorPalette.PrimaryColor),
                        beforeLineStyle:
                            LineStyle(color: Colors.black, thickness: 3),
                        endChild: Container(
                          padding: EdgeInsets.only(left: 20),
                          constraints: BoxConstraints(minHeight: 90),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hanoi",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: ColorPalette.PrimaryTextColor,
                                    fontFamily: "RubikBold"),
                              ),
                              Text(
                                "Parcel dropped at facility",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: ColorPalette.PrimaryTextColor,
                                    fontFamily: "Rubik"),
                              ),
                              Text(
                                "Mon, 10/26/2020 5:30 PM",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontFamily: "Rubik"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}

class TrackingPageHeader implements SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;

  TrackingPageHeader(this.minExtent, this.maxExtent);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final appBarSize = maxExtent - shrinkOffset;
    final cardTopPosition = maxExtent / 2 - shrinkOffset;
    final proportion = 2 - (maxExtent / appBarSize);
    final percent = proportion < 0 || proportion > 1 ? 0.0 : proportion;
    return Stack(
      children: [
        Container(color: Color(0xffF5F8FA)),
        Positioned(
          top: 40,
          left: 20,
          child: CustomBounceAnimation(
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
        )
      ],
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  // TODO: implement snapConfiguration
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  // TODO: implement stretchConfiguration
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;

  @override
  // TODO: implement showOnScreenConfiguration
  PersistentHeaderShowOnScreenConfiguration get showOnScreenConfiguration =>
      null;

  @override
  // TODO: implement vsync
  TickerProvider get vsync => null;
}
