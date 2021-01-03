import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Config extends ChangeNotifier {}

class Auth extends ChangeNotifier {
  final firebaseAuth = FirebaseAuth.instance;
  String url;

  User currentUser;

  bool get isSignedIn => currentUser != null;

  test() async {
    if (currentUser == null){
      url = null;
      return;
    }

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(currentUser.uid)
        .get();
    url ??= snapshot.data()['image'];

    print('url : $url');

    notifyListeners();
  }

  Auth() {
    firebaseAuth.userChanges().listen((user) {
      currentUser = user;
      test();
      notifyListeners();
    });
  }

  ///return null the user sign-in with Facebook.
  ///otherwise a message with the error will be returned.
  Future<void> signInWithFacebook() async {
    // Create a new provider
    FacebookAuthProvider facebookProvider = FacebookAuthProvider();

    facebookProvider.addScope('email').addScope('user_link');
    facebookProvider.setCustomParameters({
      'display': 'popup',
    });

    // Once signed in, return the UserCredential
    final userCredential = await firebaseAuth.signInWithPopup(facebookProvider);

    if (currentUser != null) {
      FirebaseFirestore.instance
          .collection('profiles')
          .doc(firebaseAuth.currentUser.uid)
          .set({
        'image': userCredential?.additionalUserInfo?.profile['picture']['data']
            ['url'],
        'profile': userCredential.additionalUserInfo.profile['link']
      });
    }
  }

  Future<void> signOut() async {
    url = null;
    await firebaseAuth.signOut();
  }
}
