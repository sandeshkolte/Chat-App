import 'dart:async';

import 'package:chat_app/screens/signin_screen.dart';
import 'package:chat_app/views/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthState {
  void loginState(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

      if (user != null) {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const BottomBarScreen()));
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const SignInScreen()));
      });
    }
  }
}
