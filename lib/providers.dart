import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

class Config extends ChangeNotifier {}

class Auth extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  Auth() {
    _firebaseAuth.userChanges().listen((user) {
      currentUser = user;
      notifyListeners();
    });
  }

  User currentUser;

  bool get isSignedIn => currentUser != null;

  String get uid {
    if (currentUser != null) return currentUser.uid;

    return null;
  }

  ///return null the user sign-in with Google.
  ///otherwise a message with the error will be returned.
  Future<String> signInWithGoogle() async {
    //Prevent google sign-in from automatically sign-in with a default account.
    _googleSignIn.signOut();

    try {
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return 'Google sign in process was aborted';

      final googleAuth = await googleUser.authentication;

      await _firebaseAuth.signInWithCredential(
        GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        ),
      );

      return null;
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
