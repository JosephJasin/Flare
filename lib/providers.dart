import 'package:flutter/foundation.dart' show required, ChangeNotifier;
import 'package:firebase_auth/firebase_auth.dart';
<<<<<<< HEAD
=======
import 'package:flutter/services.dart';
>>>>>>> parent of b7e0a08... add facebook img support
import 'package:google_sign_in/google_sign_in.dart';

class Config extends ChangeNotifier {}

class Auth extends ChangeNotifier {
<<<<<<< HEAD
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();
=======
  final firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  Stream<User> get authStateChanges => firebaseAuth.idTokenChanges();
>>>>>>> parent of b7e0a08... add facebook img support

  Auth() {
    _firebaseAuth.userChanges().listen((user) {
      currentUser = user;
      notifyListeners();

    });

  }

  User currentUser;

  bool get isSignedIn => currentUser != null;

  ///return null the user sign-in with Google.
  ///otherwise a message with the error will be returned.
<<<<<<< HEAD
  Future<String> signInWithGoogle() async {
    //Prevent google sign-in from automatically sign-in with a default account.
    _googleSignIn.signOut();
=======
  Future<UserCredential> signInWithFacebook() async {
    // Create a new provider
    FacebookAuthProvider facebookProvider = FacebookAuthProvider();
>>>>>>> parent of b7e0a08... add facebook img support

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

<<<<<<< HEAD
=======



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
>>>>>>> parent of b7e0a08... add facebook img support
      return e.toString();
    }
  }

  Future<void> signOut() async {
<<<<<<< HEAD
    await _firebaseAuth.signOut();
=======
    await firebaseAuth.signOut();
>>>>>>> parent of b7e0a08... add facebook img support
  }
}
