import 'package:chat_app/services/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthState authState = AuthState();

  @override
  void initState() {
    super.initState();
    authState.loginState(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: "Sanskar Tiwari\nChat App"
                  .text
                  .bold
                  .color(Theme.of(context).primaryColor)
                  .xl2
                  .center
                  .make())
        ],
      ),
    );
  }
}
