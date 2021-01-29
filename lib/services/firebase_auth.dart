import 'dart:async';

import 'package:merit_coaching_app1/components/reuse.dart';
import 'package:merit_coaching_app1/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:merit_coaching_app1/services/firebase_user.dart';

class AuthenticationService extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseAuthException _firebaseAuthException;
  final googleSignIn = GoogleSignIn();
  FirebaseAuthException get firebaseAuthException => _firebaseAuthException;

  void setFirebaseAuthException(FirebaseAuthException exception) {
    _firebaseAuthException = exception;
  }

  String _isLoggedin;
  String get isLoggedin => _isLoggedin;

  String _errorMsg;
  String get errorMsg => _errorMsg;
  User get userCred => firebaseAuth.currentUser;

  Stream<User> get authChanges => firebaseAuth.authStateChanges();

  Stream<AppUser> get user {
    return firebaseAuth.authStateChanges().map((user) {
      try {
        return user.uid != null
            ? AppUser(
                userId: user.uid,
                userMail: user.email,
                userName: user.displayName,
                userUrl: user.photoURL,
              )
            : null;
      } catch (e) {
        rethrow;
      }
    });
  }

  Future<void> deleteUser() async {
    try {
      await firebaseAuth.currentUser.delete();
    } on FirebaseAuthException catch (e) {
      setFirebaseAuthException(e);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> signInUserWithEmailAndPassword(
      {@required String email, @required String password, context}) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential.user.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == "network-request-failed") {
        error("No internet,Please check your connection", context);
      } else if (e.code == "user-not-found") {
        error("User did not exist,Please check your email ID", context);
      } else if (e.code == "wrong-password") {
        error("wrong password", context);
      } else {
        error("Something went wrong, Please try again", context);
      }
              // error(e.code, context);


      return _errorMsg = e.code;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> signOutUser(String userId, context) async {
    FirebaseUserService userService = FirebaseUserService();
    FirebaseAppUser user = await userService.getSingleUserData(userId);
    try {
      if (user.isGoogle) {
        GoogleSignIn googleSignIn = GoogleSignIn();
        googleSignIn.disconnect();
        await firebaseAuth.signOut();
      } else {
        googleSignIn.disconnect();

        await firebaseAuth.signOut();
      }
    } catch (e) {
      error(e.toString(), context);
    }
  }

  Future<UserCredential> createWithEmailAndPassword(
      {@required String email,
      @required String password,
      BuildContext context}) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        error("Email already in use", context);
      } else if (e.code == "network-request-failed") {
        error("No internet,Please check your connection", context);
      } else {
        error("Something went wrong, Please try again", context);
      }

      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<String> signInWithGoogle(context) async {
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user.uid;
    } catch (e) {
      error("Something went wrong, Please try again. If the error exists again please restart the app", context);

      return _errorMsg = e.toString();
    }
  }
}
