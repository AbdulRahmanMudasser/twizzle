import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationService extends ChangeNotifier {
  // instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // instance of firestore
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //  sign user in
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      // sign in
      UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // add a new document for the user in users collection
      // if it does not already exists
      _firebaseFirestore.collection('users').doc(credential.user!.uid).set(
        {
          'uid': credential.user!.uid,
          'email': email,
        },
        SetOptions(merge: true),
      );

      return credential;
    }
    // catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // create a new user
  Future<UserCredential> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // after creating the user
      // create a new document for the user in the users collection
      _firebaseFirestore.collection('users').doc(credential.user!.uid).set(
        {
          'uid': credential.user!.uid,
          'email': email,
        },
      );

      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // sign user out
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
