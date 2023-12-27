import 'package:chat_app/services/database_methods.dart';
import 'package:chat_app/services/helperfunctions.dart';
import 'package:chat_app/views/bottom_bar.dart';
import 'package:chat_app/screens/signup_screen.dart';
import 'package:chat_app/services/auth_methods.dart';
import 'package:chat_app/widgets/round_button.dart';
import 'package:chat_app/widgets/toast_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();

  final passController = TextEditingController();

  bool eyeClick = false;

  final formKey = GlobalKey<FormState>();

  AuthMethods authMethods = AuthMethods();

  DatabaseMethods databaseMethods = DatabaseMethods();

  QuerySnapshot? snapshotUserInfo;

  signmeIn(String email, String password) {
    if (formKey.currentState!.validate()) {
      HelperFunctions.saveUserEmail(email);

      DatabaseMethods.getUserbyEmail(email).then((value) {
        snapshotUserInfo = value;

        HelperFunctions.saveUserEmail(snapshotUserInfo!.docs[0]['email'])
            .then((value) => debugPrint("$value THIS IS PROPERLY STORED"));
      });

      authMethods
          .signin(email, password)
          .then((value) => Utils().toastmessage(
              context, "Signed in with $email", DelightSnackbarPosition.bottom))
          .onError((error, stackTrace) => Text(error.toString()));

      HelperFunctions.saveUserLoggedIn(true);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const BottomBarScreen()));
    }
  }

  // final auth = FirebaseAuth.instance;

  // void signIn(String email, String password) async {
  //   UserCredential userCredential =
  //       await auth.signInWithEmailAndPassword(email: email, password: password);
  //   Utils().toastMesssage("$email signed in Successfully");
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: TextFormField(
                        validator: (value) {
                          return value!.length < 8 ? "Email not valid" : null;
                        },
                        controller: emailController,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.alternate_email_rounded),
                          iconColor: Theme.of(context).primaryColor,
                          hintText: "Email",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: TextFormField(
                        obscureText: eyeClick == true ? false : true,
                        validator: (value) {
                          return value!.length >= 6
                              ? null
                              : "Password must be atleast 6 character";
                        },
                        controller: passController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  eyeClick = !eyeClick;
                                });
                              },
                              icon: eyeClick == false
                                  ? Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: Theme.of(context).primaryColor,
                                    )
                                  : Icon(
                                      Icons.remove_red_eye_rounded,
                                      color: Theme.of(context).primaryColor,
                                    )),
                          icon: const Icon(Icons.password_rounded),
                          iconColor: Theme.of(context).primaryColor,
                          hintText: "Password",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    RoundButton(
                        onTap: () {
                          signmeIn(emailController.text.toString(),
                              passController.text.toString());
                        },
                        text: "Sign in"),
                  ],
                )),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Create an account "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()));
                  },
                  child: Text(
                    "Register now",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
