import 'package:chat_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? userfromFirebase(User? user) {
    return user != null ? UserModel(user.uid) : null;
  }

  Future signin(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      return userfromFirebase(user);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future signup(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      return userfromFirebase(user);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future resetPass(String email) async {
    try {
      return _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future signOut() async {
    try {
      return _auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
