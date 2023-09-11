import 'dart:async';
import 'package:app_skripsi/main.dart';
import 'package:app_skripsi/pages/mainpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Loginservice {
  Future<UserCredential> signInWithGoogleAndEmail() async {
    // Trigger the Google authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Sign in with the Google credential
    final authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // Check if the user has a registered email
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.email != null) {
      return authResult;
    } else {
      // User does not have a registered email, sign them out
      await FirebaseAuth.instance.signOut();
      throw Exception("Google account does not have a registered email.");
    }
  }

  // handle sign In

  void handleSignIn(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null && currentUser.email != null) {
      Timer(Duration(seconds: 2),
          () => Navigator.pushReplacementNamed(context, MainPage.path));
    } else {
      Timer(Duration(seconds: 2),
          () => Navigator.pushReplacementNamed(context, LoginPage.path));
    }
  }

  // handle google sign out
  Future<void> handleSignOutGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    Navigator.pushReplacementNamed(context, LoginPage.path);
  }

  // check user auth
  Stream<void> checkUserStatus(BuildContext context) async* {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null && user.email != null) {
        // User is authenticated and has a registered email
        debugPrint(user.toString());
      } else {
        // User is not authenticated or does not have a registered email
        debugPrint(user.toString());
      }
    });
  }
}
