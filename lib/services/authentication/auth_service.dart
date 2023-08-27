import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user');
      } else {
        throw Exception(e.message);
      }
    }
  }

  // email verification
  Future<void> sendEmailVerification() async {
    try {
      _firebaseAuth.currentUser!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // create a new user
  Future<UserCredential> signUpWithEmailAndPassword(
      String name, String email, String password) async {
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
          'name': name,
          'email': email,
          'bio': 'Empty bio',
        },
      );

      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email');
      } else {
        throw Exception(e.message);
      }
    }
  }

  // google sign in
  Future<UserCredential> signInWithGoogle() async {
    try {
      // being interactive sign in process
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: <String>["email"]).signIn();

      // obtain auth details from request
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      // create a new credential for user
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // finally, lets sign in
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

      _firebaseFirestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': userCredential.user!.displayName,
        'email': userCredential.user!.email,
        'bio': 'Empty bio',
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // sign user out
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    return await FirebaseAuth.instance.signOut();
  }
}
