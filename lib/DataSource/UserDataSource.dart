import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intertravel/ViewModel/UserData.dart';

class UserDataSource {
  Future<void> updateTag(List<String> tags) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'tags': tags});
  }

  Future<UserCredential?> signWithGoogle(UserData user) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    if (googleAuth != null) {
      user.photo = Image.network(googleUser!.photoUrl!);

      return getCredentials(googleAuth);
    }
    return null;
  }

  Future<UserCredential?> getCredentials(
      GoogleSignInAuthentication googleAuth) async {
    OAuthCredential? credential;
    credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential user =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (user.credential != null) {
      return user;
    }
    return null;
  }
}
