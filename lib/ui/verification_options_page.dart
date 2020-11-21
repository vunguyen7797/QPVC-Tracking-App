import 'package:flutter/material.dart';
import 'package:qpv_client_app/components/custom_bounce_on_tap.dart';
import 'package:qpv_client_app/constant.dart';
import 'package:qpv_client_app/helper/size_config.dart';
import 'package:qpv_client_app/ui/face_detect_page.dart';
import 'package:qpv_client_app/ui/id_verify_page.dart';

class VerificationOptionsPage extends StatefulWidget {
  @override
  _VerificationOptionsPageState createState() =>
      _VerificationOptionsPageState();
}

class _VerificationOptionsPageState extends State<VerificationOptionsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(3 * SizeConfig.heightMultiplier),
              child: Container(
                child: Center(
                  child: Text(
                    'Do you want to set up Face ID and verify your ID card now for drive-thru pick up?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorPalette.PrimaryTextColor,
                      fontFamily: 'RubikMedium',
                      fontSize: 3 * SizeConfig.textMultiplier,
                    ),
                  ),
                ),
              ),
            ),
            CustomBounceAnimation(
              onTap: () {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => CameraPage(
//                              selectedCamera: 1,
//                            ))).then((value) async {
//                  final client = FaceServiceClient(key, serviceHost: endpoint);
//
//                  List _detectedFaces = await client.detect(
//                    image: value,
//                    returnFaceAttributes: FaceAttributeType.values,
//                    returnFaceLandmarks: true,
//                  );
//                  if (_detectedFaces.length > 0) {
//                    print('Face ID: ' + _detectedFaces[0].faceId);
//
//                    await client.addPersonFaceInLargePersonGroup(
//                        largePersonGroupId: customerGroupId,
//                        personId: "f94dbfbd-2255-4abc-9931-cb9acc26a9b1",
//                        detectionModel: "detection_02",
//                        imageFile: value);
//                  }
//
//                  Navigator.push(context,
//                      MaterialPageRoute(builder: (context) => Test(value)));
//                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FaceDetectionPage()));
              },
              child: Container(
                height: 8 * SizeConfig.heightMultiplier,
                width: 50 * SizeConfig.widthMultiplier,
                decoration: BoxDecoration(
                  color: ColorPalette.PrimaryColor,
                  borderRadius:
                      BorderRadius.circular(5 * SizeConfig.heightMultiplier),
                ),
                child: Center(
                  child: Text(
                    'Yes, I do',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'RubikMedium',
                        fontSize: 2.5 * SizeConfig.textMultiplier),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 3 * SizeConfig.heightMultiplier,
            ),
            CustomBounceAnimation(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => IdVerifyPage()));
              },
              child: Container(
                height: 8 * SizeConfig.heightMultiplier,
                width: 50 * SizeConfig.widthMultiplier,
                decoration: BoxDecoration(
                  color: ColorPalette.AccentColor,
                  borderRadius:
                      BorderRadius.circular(5 * SizeConfig.heightMultiplier),
                ),
                child: Center(
                  child: Text(
                    'Maybe later',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'RubikMedium',
                        fontSize: 2.5 * SizeConfig.textMultiplier),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
