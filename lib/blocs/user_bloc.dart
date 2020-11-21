import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:qpv_client_app/local_storage.dart';
import 'package:qpv_client_app/model/parcel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends ChangeNotifier {
  String _name;
  String get name => _name;
  set setName(newName) => _name = newName;

  String _uid;
  String get uid => _uid;
  set setUid(newUid) => _uid = newUid;

  String _email;
  String get email => _email;
  set setEmail(newEmail) => _email = newEmail;

  String _imageUrl;
  String get imageUrl => _imageUrl;
  set setImageUrl(newImageUrl) => _imageUrl = newImageUrl;

  String _address;
  String get address => _address;
  set setAddress(newAddress) => _address = newAddress;

  String _idCard;
  String get idCard => _idCard;
  set setIdCard(newIdCard) => _idCard = newIdCard;

  String _phone;
  String get phone => _phone;
  set setPhone(newPhone) => _phone = newPhone;

  String _userFaceID;
  String get userFaceID => _userFaceID;
  set setUserFaceID(newUserFaceID) => _userFaceID = newUserFaceID;

  String _customerGroupId;
  String get customerGroupId => _customerGroupId;
  set setCustomerGroupId(newCustomerGroupId) =>
      _customerGroupId = newCustomerGroupId;

  int _numOfFaces;
  int get numOfFaces => _numOfFaces;
  set setNumOfFaces(newNumOfFaces) => _numOfFaces = newNumOfFaces;

  int _recyclePoints;
  int get recyclePoints => _recyclePoints;
  set setRecyclePoints(newRecyclePoints) => _recyclePoints = newRecyclePoints;

  int _totalParcels;
  int get totalParcels => _totalParcels;
  set setTotalParcels(newTotalParcels) => _totalParcels = newTotalParcels;

  int _totalPickedUp;
  int get totalPickedUp => _totalPickedUp;
  set setTotalPickedUp(newTotalPickedUp) => _totalPickedUp = newTotalPickedUp;

  String _tokenId;
  String get tokenId => _tokenId;
  set setTokenId(newTokenId) => _tokenId = newTokenId;

  String _qrCode;
  String get qrCode => _qrCode;
  set setQrCode(newQrCode) => _qrCode = _qrCode;

  List _parcelList = [];
  List get parcelList => _parcelList;
  set setParcelList(newParcelList) => _parcelList = newParcelList;

  UserBloc() {
    if (LocalStorage.instance.get('uid') != "" &&
        LocalStorage.instance.get('uid') != null) {
      getUserFirestore();
      getUserParcels();
    }
  }

  getUserFirestore() async {
    String _userUid = LocalStorage.instance.get('uid');
    await FirebaseFirestore.instance
        .collection('customerAccounts')
        .doc(_userUid)
        .get()
        .then((DocumentSnapshot snap) {
      _uid = snap.data()['userUID'] ?? "";
      _name = snap.data()['name'] ?? "";
      _email = snap.data()['email'] ?? "";
      _imageUrl = snap.data()['photoUrl'] ?? "";
      _phone = snap.data()['phone'] ?? "";
      _numOfFaces = snap.data()['num_faces'] ?? 0;
      _userFaceID = snap.data()['userFaceID'] ?? "";
      _idCard = snap.data()['id_card'] ?? "0000000000";
      _address = snap.data()['addr'] ?? "";
      _customerGroupId = snap.data()['customerGroupId'] ?? "";
      _recyclePoints = snap.data()['recyclePoints'] ?? 0;
      _totalParcels = snap.data()['totalParcels'] ?? 0;
      _totalPickedUp = snap.data()['totalPickedUp'] ?? 0;
      _qrCode = snap.data()['qr_code'] ?? "";
    });
    notifyListeners();
  }

  getUserParcels() async {
    String _userUid = LocalStorage.instance.get('uid');
    await FirebaseFirestore.instance
        .collection('customerAccounts')
        .doc(_userUid)
        .collection('parcels')
        .get()
        .then((value) {
      for (QueryDocumentSnapshot item in value.docs) {
        _parcelList.add(Parcel.fromMap(item.data()));
      }
    });
    _parcelList.sort((b, a) => a.timestamp.compareTo(b.timestamp));
    print(_parcelList.length);
    notifyListeners();
  }

  updatePhoneAndAddress({phone, address}) async {
    final SharedPreferences localStorage =
        await SharedPreferences.getInstance();
    String _userUid = localStorage.getString('uid');
    print(_userUid);
    await FirebaseFirestore.instance
        .collection('customerAccounts')
        .doc(_userUid)
        .update({
      'phone': phone,
      'addr': address,
    });

    _phone = phone;
    _address = address;

    notifyListeners();
  }

  updateNumOfFaces({numOfFace}) async {
    final SharedPreferences localStorage =
        await SharedPreferences.getInstance();
    String _userUid = localStorage.getString('uid');
    print(_userUid);
    await FirebaseFirestore.instance
        .collection('customerAccounts')
        .doc(_userUid)
        .update({
      'num_faces': numOfFace,
    });

    _numOfFaces = numOfFace;

    notifyListeners();
  }

  saveTokenId({tokenId}) async {
    final SharedPreferences localStorage =
        await SharedPreferences.getInstance();
    String _userUid = localStorage.getString('uid');
    print(_userUid);
    await FirebaseFirestore.instance
        .collection('customerAccounts')
        .doc(_userUid)
        .collection('tokens')
        .doc(tokenId)
        .set({
      'token': tokenId,
      'createdAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem,
    });

    _tokenId = tokenId;

    notifyListeners();
  }

  Future<String> uploadIdCard(
          {@required File file, String uid, String name}) async =>
      await uploadFile(
        file: file,
        path: 'customer_id_card/$name-$uid/$name-ID.png',
        contentType: 'image/png',
      );

  Future<String> uploadFile({
    @required File file,
    @required String path,
    @required String contentType,
  }) async {
    print('uploading to: $path');
    final storageReference = FirebaseStorage.instance.ref().child(path);
    final uploadTask = storageReference.putFile(file);

    final TaskSnapshot snapshot = uploadTask.snapshot;

    final downloadUrl = await snapshot.ref.getDownloadURL();
    print('downloadUrl: $downloadUrl');
    return downloadUrl;
  }
}
