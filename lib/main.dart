import 'package:chat_app/services/auth_state.dart';
import 'package:chat_app/services/helperfunctions.dart';
import 'package:chat_app/views/splash_screen.dart';
import 'package:chat_app/widgets/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthState authState = AuthState();
  final auth = FirebaseAuth.instance;
  User? user;

  bool? userIsLoggedIn;

  @override
  void initState() {
    getUserLoggedInState();
    super.initState();
    user = auth.currentUser;
  }

  getUserLoggedInState() async {
    await HelperFunctions.getUserLoggedIn().then((val) {
      setState(() {
        userIsLoggedIn = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Chat App",
      themeMode: ThemeMode.system,
      theme: MyTheme.lightTheme(context),
      darkTheme: MyTheme.darkTheme(context),
      home: const SplashScreen(),
    );
  }
}
