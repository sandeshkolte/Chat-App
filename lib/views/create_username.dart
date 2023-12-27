import 'dart:io';
import 'package:chat_app/services/database_methods.dart';
import 'package:chat_app/views/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateUsername extends StatefulWidget {
  const CreateUsername({super.key});

  @override
  State<CreateUsername> createState() => _CreateUsernameState();
}

class _CreateUsernameState extends State<CreateUsername> {
  final usernameController = TextEditingController();
  final bioController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  DatabaseMethods databaseMethods = DatabaseMethods();

  File? selectedImage;

  final auth = FirebaseAuth.instance;

  late User? user = auth.currentUser;

  Future picImageFromGallery() async {
    var pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    setState(() {
      selectedImage = File(pickedImage.path);
    });
  }

  void createUser(username, bio) {
    if (formKey.currentState!.validate()) {
      Map<String, String> userMap = {
        "username": username,
        "bio": bio,
        "uid": user!.uid,
      };

      DatabaseMethods().uploadUserData(userMap);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const BottomBarScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 15, 15, 15),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
          child: Card(
            color: const Color.fromARGB(255, 16, 16, 16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Profile",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                CircleAvatar(
                  backgroundImage:
                      selectedImage != null ? FileImage(selectedImage!) : null,
                  backgroundColor: Colors.white70,
                  radius: 50,
                ),
                TextButton(
                    onPressed: () async {
                      picImageFromGallery();
                    },
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.transparent)),
                    child: const Text("Change Image")),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 40,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            return value.toString() != value!.toLowerCase() ||
                                    value.isEmpty
                                ? "only lowercase letters required"
                                : null;
                          },
                          decoration: const InputDecoration(
                            hintText: "username",
                          ),
                          controller: usernameController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextFormField(
                            validator: (val) {
                              return val!.isEmpty ? "Write something" : null;
                            },
                            controller: bioController,
                            maxLines: 6,
                            decoration: const InputDecoration(
                                hintText: "Bio...",
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                InkWell(
                  splashColor: Theme.of(context).splashColor,
                  hoverColor: Theme.of(context).hoverColor,
                  onTap: () {
                    final username = usernameController.text.toString();
                    final bio = bioController.text.toString();
                    createUser(username, bio);
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      backgroundBlendMode: BlendMode.multiply,
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 320,
                    height: 50,
                    child: const Text(
                      "Create",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
