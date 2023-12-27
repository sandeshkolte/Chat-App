import 'package:chat_app/models/constants/constant.dart';
import 'package:chat_app/screens/conversation_screen.dart';
import 'package:chat_app/services/database_methods.dart';
import 'package:chat_app/services/helperfunctions.dart';
import 'package:chat_app/widgets/search_field.dart';
import 'package:chat_app/widgets/toast_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();

  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  void initState() {
    userInfo();
    super.initState();
  }

  userInfo() async {
    Constant.myName = await HelperFunctions.getUserEmail() ?? "";
  }

  final fireStore =
      FirebaseFirestore.instance.collection("chat_user").snapshots();

  getchatroomId(String a, String b) {
    if (a.isEmpty || b.isEmpty) {
      return "Invalid input: Strings should not be empty";
    }

    int aCharCode = a.codeUnitAt(0);
    int bCharCode = b.codeUnitAt(0);

    if (aCharCode >= bCharCode) {
      return "${b}_$a";
    } else {
      return "${a}_$b";
    }
  }

  createChatConversation(String username, BuildContext context) {
    if (username != Constant.myName) {
      String chatroomId = getchatroomId(username, Constant.myName);

      List<String> users = [username, Constant.myName];
      Map<String, dynamic> roomMap = {"users": users, "chatroomId": chatroomId};

      databaseMethods.chatroom(chatroomId, roomMap);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ConversationScreen(chatroomID: chatroomId)));
    } else {
      Utils().toastmessage(context, "You cannot send message to yourself",
          DelightSnackbarPosition.top);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          SearchField(
            searchController: searchController,
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: fireStore,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No data available'));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final email =
                          snapshot.data!.docs[index]["email"].toString();
                      if (searchController.text.isEmpty) {
                        return Container();
                      } else if (email
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase())) {
                        return SearchTile(
                          email: email.replaceAll("@gmail.com", ""),
                          onPressed: () {
                            createChatConversation(email, context);
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  const SearchTile({super.key, required this.email, required this.onPressed});

  final String email;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            email,
            style: const TextStyle(
              fontSize: 17,
            ),
          ),
          TextButton(
            onPressed: onPressed,
            child: const Text("Message"),
          )
        ],
      ),
    );
  }
}
