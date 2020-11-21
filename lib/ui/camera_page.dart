import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qpv_client_app/helper/size_config.dart';

import '../constant.dart';

class CameraPage extends StatefulWidget {
  final int selectedCamera;

  const CameraPage({Key key, this.selectedCamera}) : super(key: key);
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController controller;
  List cameras;
  int selectedCameraIndex;
  String imgPath;

  bool _showSpinner = false;
  double scale = 1.0;
  double previousScale = 1.0;

  @override
  void initState() {
    super.initState();

    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIndex =
              widget.selectedCamera != null ? widget.selectedCamera : 0;
        });
        _initCameraController(cameras[selectedCameraIndex]).then((void v) {});
      } else {
        print('no_camera');
      }
    }).catchError((err) {
      print('error_1');
    });

    setState(() {
      _showSpinner = false;
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    controller.dispose();
    super.dispose();
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: SpinKitFadingFour(
        color: ColorPalette.SecondaryColor,
      ),
      inAsyncCall: _showSpinner,
      child: Scaffold(
        body: Container(
          height: double.infinity,
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                child: _cameraPreviewWidget(),
              ),
              Positioned(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: 10 * SizeConfig.heightMultiplier),
                    child: IconButton(
                      onPressed: () async {
                        print('ON TAP CAMERA');
                        setState(() {
                          _showSpinner = true;
                        });
                        final tempPath = (await getTemporaryDirectory()).path;
                        final path = tempPath + '${DateTime.now()}.png';

                        await controller.takePicture(path).then((_) async {
                          File imageFile = File(path);
                          controller.dispose();
                          Navigator.pop(context, imageFile);
//                          Uint8List imageBytes = await imageFile.readAsBytes();
//                          String base64Image = base64Encode(imageBytes);

                          setState(() {
                            _showSpinner = false;
                          });
                        });
                      },
                      icon: Icon(Icons.camera),
                      iconSize: 13 * SizeConfig.heightMultiplier,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Display Camera preview.
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return Text(
        'loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return GestureDetector(
      onScaleStart: (ScaleStartDetails details) {
        previousScale = scale;
        setState(() {});
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        scale = previousScale * details.scale;
        setState(() {});
      },
      onScaleEnd: (ScaleEndDetails details) {
        previousScale = 1.0;
        setState(() {});
      },
      child: Transform.scale(
        scale: scale > 1.0 ? scale : 1.0,
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller),
        ),
      ),
    );
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error:${e.code}\nError message : ${e.description}';
    print(errorText);
  }
}
