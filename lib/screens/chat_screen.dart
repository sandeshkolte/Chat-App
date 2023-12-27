import 'package:chat_app/models/constants/constant.dart';
import 'package:chat_app/screens/conversation_screen.dart';
import 'package:chat_app/screens/signin_screen.dart';
import 'package:chat_app/services/auth_methods.dart';
import 'package:chat_app/services/database_methods.dart';
import 'package:chat_app/services/helperfunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream<QuerySnapshot<Object?>>? chatroomStream;

  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  void initState() {
    userInfo();
    var value = databaseMethods.chatRoomScreen(Constant.myName);
    setState(() {
      chatroomStream = value;
      debugPrint("$chatroomStream THIS IS GOOD OR NOT");
    });
    super.initState();
  }

  userInfo() async {
    Constant.myName = await HelperFunctions.getUserEmail() ?? "";
    // Constant.newMsg = await HelperFunctions.getMsg() ?? "";
    // debugPrint(Constant.newMsg.toString() + " THIS THE THE MESSAGE OR NOT");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  showMyDialog(context);
                },
                icon: const Icon(Icons.logout_rounded))
          ],
          title: const Text("Chat Screen"),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        ),
        backgroundColor: Theme.of(context).canvasColor,
        body: StreamBuilder<QuerySnapshot>(
            stream: chatroomStream,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return ChatTile(
                            username: snapshot.data!.docs[index]["chatroomId"]
                                .toString()
                                // .replaceAll("_", "")
                                // .replaceAll(Constant.myName, "")
                                .replaceAll("@gmail.com", ""),
                            // subtitle: Constant.newMsg,
                            chatroomID: snapshot.data!.docs[index]
                                ["chatroomId"]);
                      })
                  : snapshot.connectionState == ConnectionState.waiting
                      ? const Center(child: CircularProgressIndicator())
                      : Container();
            }));
  }
}

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.username,
    required this.chatroomID,
    // required this.subtitle,
  });
  final String username;
  final String chatroomID;
  // final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ConversationScreen(chatroomID: chatroomID)));
        },
        title: Text(
          username,
          style: const TextStyle(fontSize: 17),
        ),
        // subtitle: Text(subtitle),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(username.substring(0, 1)),
        ),
      ),
    );
  }
}

Future<void> showMyDialog(context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure you want to Logout?"),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      AuthMethods().signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()));
                    },
                    child: const Text("Yes")),
                const SizedBox(
                  width: 20,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("No"))
              ],
            )
          ],
        );
      });
}
