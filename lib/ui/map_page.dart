import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:qpv_client_app/helper/size_config.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          new FlutterMap(
              options: new MapOptions(
                  minZoom: 10.0, center: new LatLng(40.71, -74.00)),
              layers: [
                new TileLayerOptions(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c']),
                new MarkerLayerOptions(markers: [
                  new Marker(
                      width: 45.0,
                      height: 45.0,
                      point: new LatLng(40.73, -74.00),
                      builder: (context) => new Container(
                            child: IconButton(
                                icon: Icon(Icons.accessibility),
                                onPressed: () {
                                  print('Marker tapped!');
                                }),
                          ))
                ])
              ]),
          Positioned(
              top: 4 * SizeConfig.heightMultiplier,
              child: Container(
                alignment: Alignment.center,
                height: 7 * SizeConfig.heightMultiplier,
                width: 60 * SizeConfig.widthMultiplier,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'Stations Near You',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RubikBold',
                        fontSize: 3 * SizeConfig.textMultiplier),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
