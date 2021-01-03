import 'package:flutter/foundation.dart' show required, ChangeNotifier;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Config extends ChangeNotifier {}

class Auth extends ChangeNotifier {
  final firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  Stream<User> get authStateChanges => firebaseAuth.idTokenChanges();

  Auth() {
    firebaseAuth.userChanges().listen((user) {
      currentUser = user;
      notifyListeners();
    });
  }

  ///return null the user sign-in with Facebook.
  ///otherwise a message with the error will be returned.
  Future<UserCredential> signInWithFacebook() async {
    // Create a new provider
    FacebookAuthProvider facebookProvider = FacebookAuthProvider();

    facebookProvider.addScope('email').addScope('user_link');
    facebookProvider.setCustomParameters({
      'display': 'popup',
    });




    // Once signed in, return the UserCredential
    return await firebaseAuth.signInWithPopup(facebookProvider);
  }

  User currentUser;

  bool get isSignedIn => currentUser != null;

  ///return null the user sign-in with Google.
  ///otherwise a message with the error will be returned.
  Future<String> signInWithGoogle() async {
    //Prevent google sign-in from automatically sign-in with a default account.
    _googleSignIn.signOut();

    try {
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return 'Google sign in process was aborted';

      final googleAuth = await googleUser.authentication;

      await firebaseAuth.signInWithCredential(
        GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        ),
      );

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
