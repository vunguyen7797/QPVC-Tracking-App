import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qpv_client_app/blocs/user_bloc.dart';
import 'package:qpv_client_app/components/custom_bounce_on_tap.dart';
import 'package:qpv_client_app/helper/size_config.dart';
import 'package:qpv_client_app/local_storage.dart';
import 'package:qpv_client_app/ui/camera_page.dart';
import 'package:qpv_client_app/ui/dashboard_page.dart';
import 'package:qpv_client_app/ui/info_verify_page.dart';

import '../constant.dart';

class IdVerifyPage extends StatefulWidget {
  @override
  _IdVerifyPageState createState() => _IdVerifyPageState();
}

class _IdVerifyPageState extends State<IdVerifyPage> {
  File _imageFile;
  bool _showSpinner = false;

  /// pick photo from gallery and upload to firebase storage
  Future<void> _chooseProfilePhoto(user) async {
    try {
      final imagePicker = ImagePicker();
      final file = await imagePicker.getImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() {
          _imageFile = File(file.path);
        });

        await _uploadIdCard(_imageFile, user);

        setState(() {
          _showSpinner = true;
        });

        setState(() {
          _showSpinner = false;
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => InfoVerifyPage()));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> _uploadIdCard(File imageFile, user) async {
    String photoUrl = '';

    String uid = LocalStorage.instance.get('uid');
    String name = LocalStorage.instance.get('name');
    photoUrl = await user.uploadIdCard(
        file: File(imageFile.path), uid: uid, name: name);
    print(photoUrl);
    return photoUrl;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> _detectInfo(File imageFile) async {
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(_imageFile);
    final DocumentTextRecognizer cloudDocumentTextRecognizer =
        FirebaseVision.instance.cloudDocumentTextRecognizer();
    final VisionDocumentText visionDocumentText =
        await cloudDocumentTextRecognizer.processImage(visionImage);

    String text = visionDocumentText.text;

    return text;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserBloc>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomBounceAnimation(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.only(
                    top: 5 * SizeConfig.heightMultiplier,
                    left: 5 * SizeConfig.widthMultiplier),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: ColorPalette.SecondaryColor.withOpacity(0.5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Icon(
                      FlevaIcons.arrow_back,
                      color: Colors.black,
                      size: 3 * SizeConfig.textMultiplier,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 8 * SizeConfig.heightMultiplier,
                  bottom: 6 * SizeConfig.heightMultiplier,
                  left: (Device.get().isTablet ? 12 : 5) *
                      SizeConfig.widthMultiplier),
              child: Container(
                child: Text(
                  'ID  Verification',
                  style: TextStyle(
                      color: ColorPalette.PrimaryTextColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'RubikBold',
                      fontSize: 7 * SizeConfig.textMultiplier),
                ),
              ),
            ),
            Center(
              child: Container(
                height: 30 * SizeConfig.heightMultiplier,
                width: 0.9 * MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius:
                        BorderRadius.circular(3 * SizeConfig.heightMultiplier),
                    color: Colors.white,
                    image: DecorationImage(
                        image: _imageFile != null
                            ? FileImage(_imageFile)
                            : AssetImage('res/images/welcome.png'))),
              ),
            ),
            SizedBox(
              height: 5 * SizeConfig.heightMultiplier,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 5 * SizeConfig.widthMultiplier),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CustomBounceAnimation(
                      onTap: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CameraPage()))
                            .then((value) async {
                          setState(() {
                            _imageFile = value;
                          });
                          await _uploadIdCard(_imageFile, user);
                        });
                      },
                      child: Container(
                        height: 8 * SizeConfig.heightMultiplier,
                        decoration: BoxDecoration(
                          color: ColorPalette.PrimaryColor,
                          borderRadius: BorderRadius.circular(
                              5 * SizeConfig.heightMultiplier),
                        ),
                        child: Center(
                          child: Text(
                            'Open Camera',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'RubikMedium',
                                fontSize: 2.5 * SizeConfig.textMultiplier),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 3 * SizeConfig.widthMultiplier,
                  ),
                  Expanded(
                    child: CustomBounceAnimation(
                      onTap: () {
                        _chooseProfilePhoto(user);
                      },
                      child: Container(
                        height: 8 * SizeConfig.heightMultiplier,
                        decoration: BoxDecoration(
                          color: ColorPalette.AccentColor,
                          borderRadius: BorderRadius.circular(
                              5 * SizeConfig.heightMultiplier),
                        ),
                        child: Center(
                          child: Text(
                            'Open Gallery',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'RubikMedium',
                                fontSize: 2.5 * SizeConfig.textMultiplier),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CustomBounceAnimation(
                onTap: () {
                  final UserBloc userBloc = Provider.of<UserBloc>(context);
                  print(userBloc.address);
                  if (userBloc.address != null &&
                      userBloc.phone != null &&
                      userBloc.address != "" &&
                      userBloc.phone != "") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardPage()));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InfoVerifyPage()));
                  }
                },
                child: Center(
                  child: Container(
                    child: Text(
                      'Skip',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 2 * SizeConfig.textMultiplier,
                        fontFamily: 'RubikMedium',
                      ),
                    ),
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
