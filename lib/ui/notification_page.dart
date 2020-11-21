import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qpv_client_app/constant.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
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
              delegate: NotificationPageHeader(200, 200),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order EC1234565456VN is picked up",
                        style: TextStyle(
                            color: ColorPalette.PrimaryTextColor,
                            fontSize: 16,
                            fontFamily: "RubikBold"),
                      ),
                      Text(
                        "Order EC1234565456VN is picked up at Station No. 1234. Please contact us if it's not you.",
                        style: TextStyle(
                            color: ColorPalette.PrimaryTextColor,
                            fontSize: 14,
                            fontFamily: "Rubik"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "11/21/2020 12:00 PM",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontFamily: "Rubik"),
                          ),
                          Icon(
                            Icons.circle_notifications,
                            color: ColorPalette.AccentColor,
                            size: 30,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order EC1234565456VN is arrived",
                        style: TextStyle(
                            color: ColorPalette.PrimaryTextColor,
                            fontSize: 16,
                            fontFamily: "RubikBold"),
                      ),
                      Text(
                        "Order EC1234565456VN is arrived at Station No. 1234. Please pick-up within 24 hours.",
                        style: TextStyle(
                            color: ColorPalette.PrimaryTextColor,
                            fontSize: 14,
                            fontFamily: "Rubik"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "11/21/2020 5:30 PM",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontFamily: "Rubik"),
                          ),
                          Icon(
                            Icons.circle_notifications,
                            color: ColorPalette.AccentColor,
                            size: 30,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order EC1234512156VN is canceled",
                        style: TextStyle(
                            color: ColorPalette.PrimaryTextColor,
                            fontSize: 16,
                            fontFamily: "RubikBold"),
                      ),
                      Text(
                        "Order EC1234512156VN is canceled since you didn't pick up.",
                        style: TextStyle(
                            color: ColorPalette.PrimaryTextColor,
                            fontSize: 14,
                            fontFamily: "Rubik"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "11/19/2020 8:00 PM",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontFamily: "Rubik"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

class NotificationPageHeader implements SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;

  NotificationPageHeader(this.minExtent, this.maxExtent);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final appBarSize = maxExtent - shrinkOffset;
    final cardTopPosition = maxExtent / 2 - shrinkOffset;
    final proportion = 2 - (maxExtent / appBarSize);
    final percent = proportion < 0 || proportion > 1 ? 0.0 : proportion;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xffF5F8FA),
          ),
        ),
        Positioned(
          top: 40,
          left: 20,
          child: InkWell(
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
        ),
        Positioned(
          top: 130,
          left: 20,
          child: Container(
            child: Text(
              "Notifications",
              style: TextStyle(
                  fontSize: 40,
                  fontFamily: "RubikBold",
                  color: ColorPalette.PrimaryTextColor),
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
