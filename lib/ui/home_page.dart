import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:qpv_client_app/blocs/user_bloc.dart';
import 'package:qpv_client_app/components/custom_bounce_on_tap.dart';
import 'package:qpv_client_app/components/custom_fade_in.dart';
import 'package:qpv_client_app/components/custom_search_bar.dart';
import 'package:qpv_client_app/constant.dart';
import 'package:qpv_client_app/helper/size_config.dart';
import 'package:qpv_client_app/model/parcel.dart';
import 'package:qpv_client_app/ui/qr_code_page.dart';
import 'package:qpv_client_app/ui/tracking_page.dart';

import 'notification_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = Provider.of<UserBloc>(context);
    return Container(
      color: Color(0xffF5F8FA),
      child: CustomScrollView(slivers: [
        SliverPersistentHeader(
          pinned: true,
          floating: true,
          delegate: ParcelPageHeader(120, 260),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 15),
              height: 50,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent parcels",
                    style: TextStyle(
                        fontSize: 18,
                        color: ColorPalette.PrimaryTextColor,
                        fontFamily: "RubikBold"),
                  ),
                  Text(
                    "View All",
                    style: TextStyle(
                        fontSize: 16,
                        color: ColorPalette.PrimaryColor,
                        fontFamily: "RubikBold"),
                  )
                ],
              ),
            ),
          ]),
        ),
        SliverPadding(
          padding: EdgeInsets.only(bottom: 10 * SizeConfig.heightMultiplier),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              List.generate(
                userBloc.parcelList.length,
                (index) => ParcelCardWidget(
                  tracking: userBloc.parcelList[index].tracking,
                  address: userBloc.parcelList[index].address,
                  paidStatus: userBloc.parcelList[index].paidStatus,
                  sender: userBloc.parcelList[index].sender,
                  phone: userBloc.parcelList[index].phone,
                  timestamp: userBloc.parcelList[index].timestamp,
                  description: userBloc.parcelList[index].description,
                  pickedUpStatus: userBloc.parcelList[index].pickedUpStatus,
                  parcel: userBloc.parcelList[index],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class ParcelCardWidget extends StatelessWidget {
  final String address;
  final String phone;
  final String sender;
  final String timestamp;
  final String tracking;
  final bool paidStatus;
  final bool pickedUpStatus;
  final String description;
  final Parcel parcel;

  const ParcelCardWidget(
      {Key key,
      this.parcel,
      this.description,
      this.address,
      this.phone,
      this.sender,
      this.timestamp,
      this.tracking,
      this.paidStatus,
      this.pickedUpStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomBounceAnimation(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TrackingPage(item: parcel)));
      },
      child: CustomFadeIn(
        delay: 0.5,
        transformDuration: 0,
        child: Container(
          height: 220,
          width: double.infinity,
          padding: EdgeInsets.only(top: 0, bottom: 20, left: 30, right: 30),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tracking #: $tracking",
                          style: TextStyle(
                              color: ColorPalette.PrimaryTextColor,
                              fontSize: 12,
                              fontFamily: "Rubik"),
                        ),
                        Text(
                          paidStatus ? "Paid" : "Unpaid",
                          style: TextStyle(
                              color: ColorPalette.PrimaryTextColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Rubik"),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$description",
                          style: TextStyle(
                              color:
                                  pickedUpStatus ? Colors.red : Colors.orange,
                              fontSize: 14,
                              fontFamily: "RubikBold"),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "$timestamp",
                          style: TextStyle(
                              color: ColorPalette.PrimaryTextColor,
                              fontSize: 12,
                              fontFamily: "Rubik"),
                        ),
                        Divider(
                          color: ColorPalette.PrimaryTextColor,
                          thickness: 1,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Text(
                          "Sender: ",
                          style: TextStyle(
                              color: ColorPalette.PrimaryTextColor,
                              fontSize: 15,
                              fontFamily: "Rubik"),
                        ),
                        Text(
                          "$sender",
                          style: TextStyle(
                              color: ColorPalette.PrimaryTextColor,
                              fontSize: 15,
                              fontFamily: "RubikBold"),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Text(
                          "Address: $address",
                          style: TextStyle(
                              color: ColorPalette.PrimaryTextColor,
                              fontSize: 15,
                              fontFamily: "Rubik"),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Text(
                          "Phone: $phone",
                          style: TextStyle(
                              color: ColorPalette.PrimaryTextColor,
                              fontSize: 15,
                              fontFamily: "Rubik"),
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
    );
  }
}

class ParcelPageHeader implements SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;

  ParcelPageHeader(this.minExtent, this.maxExtent);

  final _searchBarMarginTween = EdgeInsetsTween(
      begin: EdgeInsets.only(
          bottom: 0,
          top: 0,
          left: 6 * SizeConfig.widthMultiplier,
          right: 6 * SizeConfig.widthMultiplier),
      end: EdgeInsets.only(
          left: 5 * SizeConfig.widthMultiplier,
          top: 3 * SizeConfig.heightMultiplier,
          right: 24 * SizeConfig.widthMultiplier,
          bottom: 3.5 * SizeConfig.heightMultiplier));

  final _notiMargin = EdgeInsetsTween(
      begin: EdgeInsets.only(
          bottom: 0,
          top: 10 * SizeConfig.heightMultiplier,
          left: 0 * SizeConfig.widthMultiplier,
          right: 8 * SizeConfig.widthMultiplier),
      end: EdgeInsets.only(
          left: 0 * SizeConfig.widthMultiplier,
          top: 7.5 * SizeConfig.heightMultiplier,
          right: 5 * SizeConfig.widthMultiplier,
          bottom: 0 * SizeConfig.heightMultiplier));

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final appBarSize = maxExtent - shrinkOffset;
    final cardTopPosition = maxExtent / 2 - shrinkOffset;
    double tempVal = 34 * maxExtent / 100;
    final progress = shrinkOffset > tempVal ? 1.0 : shrinkOffset / tempVal;
    final proportion = 2 - (maxExtent / appBarSize);
    final percent = proportion < 0 || proportion > 1 ? 0.0 : proportion;
    final searchBarMargin = _searchBarMarginTween.lerp(progress);
    final notiMargin = _notiMargin.lerp(progress);
    final UserBloc userBloc = Provider.of<UserBloc>(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildHeaderBackground(),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hi, ${userBloc.name.substring(0, userBloc.name.indexOf(' '))}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: textAutoResize(37, percent),
                        fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Your nearest QPV drive-thru is",
                style: TextStyle(
                    color: Colors.white, fontSize: textAutoResize(17, percent)),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                "Station No. 1234",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: textAutoResize(15, percent),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 3,
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: textAutoResize(15, percent),
                  ),
                  Text(
                    "8 Hoang Hoa Tham, Hue, Vietnam",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: textAutoResize(15, percent),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: notiMargin,
          child: Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomBounceAnimation(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationPage())),
                    child: Icon(
                      FlevaIcons.bell_outline,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  CustomBounceAnimation(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => QrCodePage())),
                    child: Icon(
                      Icons.qr_code_scanner_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              )),
        ),
        Padding(
          padding: searchBarMargin,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: CustomSearchBar(),
          ),
        )
      ],
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  double textAutoResize(double size, double percent) {
    return size * percent;
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
}
