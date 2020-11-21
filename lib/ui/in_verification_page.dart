import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:qpv_client_app/blocs/user_bloc.dart';
import 'package:qpv_client_app/cognitiveFaceServices/face_service_client.dart';
import 'package:qpv_client_app/cognitiveFaceServices/face_service_rest_client.dart';
import 'package:qpv_client_app/constant.dart';
import 'package:qpv_client_app/helper/size_config.dart';

import 'id_verify_page.dart';

class InVerificationPage extends StatefulWidget {
  final List<File> faceList;

  const InVerificationPage({Key key, this.faceList}) : super(key: key);
  @override
  _InVerificationPageState createState() =>
      _InVerificationPageState(this.faceList);
}

class _InVerificationPageState extends State<InVerificationPage> {
  bool _spinner = true;
  List<File> faceList;
  int count = 0;
  final client = FaceServiceClient(key, serviceHost: endpoint);

  _InVerificationPageState(this.faceList);

  Future handleAddingFace(File imageFile, user) async {
    List _detectedFaces = await client.detect(
      image: imageFile,
      returnFaceAttributes: FaceAttributeType.values,
      returnFaceLandmarks: true,
    );

    if (_detectedFaces.length == 1 && user.userFaceID != "") {
      await client
          .addPersonFaceInLargePersonGroup(
              largePersonGroupId: customerGroupId,
              personId: user.userFaceID,
              detectionModel: "detection_02",
              imageFile: imageFile)
          .then((value) {
        setState(() {
          count++;
        });
      });
    }

    if (count == 3) {
      await client
          .trainLargePersonGroup(largePersonGroupId: customerGroupId)
          .then((_) async {
        user.updateNumOfFaces(numOfFace: count);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => IdVerifyPage()));
      });
    }
  }

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 0)).then((_) async {
      final UserBloc user = Provider.of<UserBloc>(context);

      await user.getUserFirestore();

      if (faceList != null && user.userFaceID != null)
        for (File item in faceList) {
          handleAddingFace(item, user);
        }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'We are verifying Please wait...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorPalette.PrimaryTextColor,
                  fontFamily: 'RubikBold',
                  fontSize: 5 * SizeConfig.textMultiplier,
                ),
              ),
              SizedBox(
                height: 3 * SizeConfig.heightMultiplier,
              ),
              SpinKitPouringHourglass(
                color: ColorPalette.AccentColor,
              )
            ],
          )),
    );
  }
}
