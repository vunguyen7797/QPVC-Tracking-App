import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qpv_client_app/cognitiveFaceServices/face_service_rest_client.dart';
import 'package:qpv_client_app/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticateBloc extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final _facebookLogin = FacebookLogin();
  final client = FaceServiceClient(key, serviceHost: endpoint);

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  set isSignedIn(newVal) => _isSignedIn = newVal;

  bool _hasError = false;
  bool get hasError => _hasError;
  set hasError(newError) => _hasError = newError;

  bool _userExists = false;
  bool get userExists => _userExists;
  set setUserExist(bool value) => _userExists = value;

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

  String _userFaceID;
  String get userFaceID => _userFaceID;
  set setUserFaceID(newUserFaceID) => _userFaceID = newUserFaceID;

  // Check if user is already login or not
  AuthenticateBloc() {
    isLoggedIn();
  }

  void isLoggedIn() async {
    final SharedPreferences ldb = await SharedPreferences.getInstance();

    _isSignedIn = ldb.getBool('login') ?? false;
    print('Signed In status: ' + _isSignedIn.toString());
    notifyListeners();
  }

  Future setSignInStatus() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('login', true);
    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(
      String email, String password, context) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final User user = result.user;
      this._name = user.displayName ?? "";
      this._email = user.email ?? "";
      this._imageUrl = user.photoURL ?? "";
      this._uid = user.uid;
      if (user.uid != null || user.uid != "") {
        this._uid = user.uid;

        _hasError = false;
      } else
        _hasError = true;
      notifyListeners();
    } catch (e) {
      _hasError = true;

      notifyListeners();
    }
  }

  Future<void> signInWithFacebook(context) async {
    User currentUser;
    try {
      bool isLoggedIn = await _facebookLogin.isLoggedIn;

      if (!isLoggedIn) {
        final result = await _facebookLogin.logIn(['email']);
        print(result.status);
        if (result.status == FacebookLoginStatus.loggedIn) {
          print('LOGGED IN FB');
          final token = result.accessToken.token;
          final credential = FacebookAuthProvider.credential(token);
          final User user =
              (await _firebaseAuth.signInWithCredential(credential)).user;
          assert(user.email != null);
          assert(user.displayName != null);
          assert(!user.isAnonymous);
          assert(await user.getIdToken() != null);
          currentUser = await _firebaseAuth.currentUser;
          assert(user.uid == currentUser.uid);

          this._name = user.displayName;
          this._email = user.email;
          this._imageUrl = user.photoURL;

          if (user.uid != null || user.uid != "") {
            print('UID FACEBOOK IS NOT NULL ${user.uid}');
            this._uid = user.uid;
            _hasError = false;
          } else {
            print('UID FACEBOOK IS NULL - ERROR ${user.uid}');
            _hasError = true;
          }
          notifyListeners();
        } else {
          print('Facebook log in failed');
          _hasError = true;
          notifyListeners();
        }
      }
    } catch (e) {
      _hasError = true;

      notifyListeners();
    }
  }

  Future<void> signInWithGoogle(context) async {
    final GoogleSignInAccount googleUser = await _googleSignIn
        .signIn()
        .catchError((error) => print('error : $error'));
    if (googleUser != null) {
      try {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        User userDetails =
            (await _firebaseAuth.signInWithCredential(credential)).user;

        this._name = userDetails.displayName;
        this._email = userDetails.email;
        this._imageUrl = userDetails.photoURL;
        this._uid = userDetails.uid;
        if (userDetails.uid != null || userDetails.uid != "") {
          this._uid = userDetails.uid;
          _hasError = false;
        } else
          _hasError = true;
        notifyListeners();
      } catch (e) {
        _hasError = true;

        notifyListeners();
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }

  Future userExistCheck() async {
    await FirebaseFirestore.instance
        .collection('customerAccounts')
        .get()
        .then((QuerySnapshot snap) {
      List values = snap.docs;
      List userIds = [];
      values.forEach((element) {
        userIds.add(element['userUID']);
      });
      if (userIds.contains(_uid)) {
        print('User Exists');
        _userExists = true;
      } else {
        _userExists = false;
      }
      notifyListeners();
    });
  }

  Future addUserToFirestoreDatabase() async {
    print('Adding user to database: $uid');
    final DocumentReference ref =
        FirebaseFirestore.instance.collection('customerAccounts').doc(uid);
    await client
        .createPersonInLargePersonGroup(
            customerName: name,
            userUID: uid,
            largePersonGroupId: customerGroupId)
        .then((value) => this._userFaceID = value.personId ?? "");
    await ref.set({
      'userUID': uid,
      'email': email,
      'name': name,
      'photoUrl': imageUrl,
      'addr': "",
      'customerGroupId': customerGroupId,
      'id_card': "",
      'num_faces': 0,
      'phone': "",
      'recyclePoints': 0,
      'totalParcels': 0,
      'totalPickedUp': 0,
      'userFaceID': _userFaceID ?? "",
      'qr_code': "",
    });
  }

  Future setUidToLocalStorage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('uid', _uid);
    await sharedPreferences.setString('photoUrl', _imageUrl ?? "");
    await sharedPreferences.setString('name', _name ?? "");

    print('Finish setting Local Storage');
  }

  Future<void> signUpWithEmailAndPassword(
      String email, String password, context, String name) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      final User user = result.user;
      this._name = name ?? "";
      this._email = email ?? "";
      this._imageUrl = user.photoURL ?? "";
      this._uid = user.uid;

      _hasError = false;
      notifyListeners();

      return true;
    } catch (e) {
      _hasError = true;
      notifyListeners();
    }
  }

  Future<bool> updatePassword(String password) async {
    try {
      bool result;
      User user = FirebaseAuth.instance.currentUser;
      await user.updatePassword(password).then((value) {
        result = true;
        return result;
      }).catchError((onError) {
        result = false;
        return result;
      });
      return result;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> signOut() async {
    print('Signed out');
    clearAllData();
    _isSignedIn = false;
    await _firebaseAuth.signOut();
  }

  void clearAllData() async {
    final SharedPreferences localStorage =
        await SharedPreferences.getInstance();
    localStorage.clear();
  }
}
