import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qpv_client_app/cognitiveFaceServices/contract/face.dart'
    as mFace;
import 'package:qpv_client_app/cognitiveFaceServices/face_service_rest_client.dart';
import 'package:qpv_client_app/components/custom_bounce_on_tap.dart';
import 'package:qpv_client_app/helper/size_config.dart';
import 'package:qpv_client_app/ui/in_verification_page.dart';

import '../constant.dart';

class FaceDetectionPage extends StatefulWidget {
  @override
  _FaceDetectionPageState createState() => _FaceDetectionPageState();
}

class _FaceDetectionPageState extends State<FaceDetectionPage> {
  CameraController _cameraController;
  List cameras;
  int selectedCameraIndex;
  bool _faceFound = false;
  Directory tempDir;
  final client = FaceServiceClient(key, serviceHost: endpoint);
  List<mFace.Face> _detectedFaces = [];
  //String _customerGroupId = "1cf81f49-aa51-46f2-b18c-965c48a6c401";
  bool _spinner = false;
  int _numFaces = 0;
  List<File> _faceList = [];

  @override
  void initState() {
    super.initState();
    // Set the phone orientation portrait
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIndex = 1;
        });
        _initCameraController(cameras[selectedCameraIndex]).then((void v) {});
      } else {
        print('no_camera');
      }
    }).catchError((err) {
      print('error_1');
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (_cameraController != null) {
      await _cameraController.dispose();
    }
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.veryHigh);

    _cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (_cameraController.value.hasError) {
        print('Camera error ${_cameraController.value.errorDescription}');
      }
    });

    try {
      await _cameraController.initialize();
    } on CameraException catch (e) {
      // _showCameraException(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildCameraPreview() {
    if (_cameraController == null || !_cameraController.value.isInitialized) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.8,
      child: _cameraController == null
          ? const Center(child: null)
          : Stack(
              // fit: StackFit.expand,
              children: <Widget>[
                CameraPreview(_cameraController),
                //_buildResultFrame(),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: _spinner,
        progressIndicator: SpinKitFadingFour(
          color: ColorPalette.PrimaryColor,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                3 * SizeConfig.heightMultiplier),
                          ),
                          child: _buildCameraPreview()),
                    ),
                    Positioned(
                        child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.8,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: _faceFound
                                  ? Image.asset(
                                      'res/images/face_shape_found.png')
                                  : Image.asset('res/images/face_shape.png'),
                            )))
                  ],
                ),
              ),
              Expanded(
                child: CustomBounceAnimation(
                  onTap: () async {
                    setState(() {
                      _numFaces++;
                    });
                    final tempPath = (await getTemporaryDirectory()).path;
                    final path = tempPath + '${DateTime.now()}.png';
                    File imageFile;
                    await _cameraController.takePicture(path).then((_) async {
                      imageFile = File(path);
                    });
                    _faceList.add(imageFile);

                    if (_numFaces == 3) {
                      _cameraController.dispose();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InVerificationPage(
                                    faceList: _faceList,
                                  )));
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(0 * SizeConfig.heightMultiplier),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              0 * SizeConfig.heightMultiplier),
                          color: ColorPalette.AccentColor,
                        ),
                        child: Center(
                          child: Text(
                            'Tap To Capture ($_numFaces/3)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'RubikBold',
                              fontSize: 3 * SizeConfig.textMultiplier,
                            ),
                          ),
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
