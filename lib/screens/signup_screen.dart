import 'package:chat_app/services/database_methods.dart';
import 'package:chat_app/services/helperfunctions.dart';
import 'package:chat_app/views/bottom_bar.dart';
import 'package:chat_app/screens/signin_screen.dart';
import 'package:chat_app/services/auth_methods.dart';
import 'package:chat_app/widgets/round_button.dart';
import 'package:chat_app/widgets/toast_bar.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();

  final passController = TextEditingController();

  final confpassController = TextEditingController();

  final AuthMethods authMethods = AuthMethods();

  final formKey = GlobalKey<FormState>();

  bool eyeClick = false;

  final auth = FirebaseAuth.instance;

  // final auth = FirebaseAuth.instance;

  bool isLoading = false;

  late User? user = auth.currentUser;

  DatabaseMethods databaseMethods = DatabaseMethods();

  void signmeup(String email, String password) async {
    if (formKey.currentState!.validate()) {
      if (passController.text != confpassController.text) {
        Utils().toastmessage(
            context, "Passwords doesn't match", DelightSnackbarPosition.top);
      } else {
        authMethods
            .signup(email, password)
            .then((value) => Utils().toastmessage(
                context,
                "sign up with ${emailController.text}",
                DelightSnackbarPosition.bottom))
            .onError((error, stackTrace) => Text(error.toString()));

        final userMap = <String, dynamic>{
          "email": email,
        };

        HelperFunctions.saveUserEmail(email);

        databaseMethods.uploadUserData(userMap);

        HelperFunctions.saveUserLoggedIn(true);

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const BottomBarScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: TextFormField(
                      obscureText: true,
                      controller: confpassController,
                      decoration: InputDecoration(
                        iconColor: Theme.of(context).primaryColor,
                        icon: const Icon(Icons.shield_rounded),
                        hintText: "Confirm Password",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
                onTap: () {
                  signmeup(emailController.text.toString(),
                      passController.text.toString());
                },
                text: "Sign Up"),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInScreen()));
                  },
                  child: Text(
                    "Login now",
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
