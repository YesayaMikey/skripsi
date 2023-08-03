import 'dart:async';
import 'dart:ffi';

import 'package:app_skripsi/main.dart';
import 'package:app_skripsi/pages/mainpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Loginservice {
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // handle sign In

  void handleSignIn(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
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

  //check user auth
  Stream<void> checkUserStatus(BuildContext context) async* {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // user ada, sudah login
        debugPrint(user.toString());
      } else {
        debugPrint(user.toString());
      }
    });
  }
}
