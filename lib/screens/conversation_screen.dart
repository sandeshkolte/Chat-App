import 'package:chat_app/models/constants/constant.dart';
import 'package:chat_app/services/database_methods.dart';
import 'package:chat_app/services/helperfunctions.dart';
import 'package:chat_app/views/bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key, required this.chatroomID});
  final String chatroomID;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final messageController = TextEditingController();
   Stream<QuerySnapshot<Object?>>? chatroomStream;

  DatabaseMethods databaseMethods = DatabaseMethods();
  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatroomMap = {
        "message": messageController.text,
        "sendBy": Constant.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };

      // HelperFunctions.saveMessage(messageController.text);
      databaseMethods.conversationMessages(widget.chatroomID, chatroomMap);
      messageController.clear();
    }
  }

 

  @override
  void initState() {
    userInfo();
    var value = databaseMethods.addconversationMessages(widget.chatroomID);
    setState(() {
      chatroomStream = value;
    });
    super.initState();
  }

  userInfo() async {
    Constant.myName = await HelperFunctions.getUserEmail() ?? "";
  }

  Widget chatMessageList() {
    return StreamBuilder<QuerySnapshot>(
        stream: chatroomStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        message: snapshot.data!.docs[index]["message"],
                        isSendByMe: snapshot.data!.docs[index]["sendBy"] ==
                            Constant.myName);
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BottomBarScreen()));
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          title:
              Text(widget.chatroomID.toString().replaceAll("@gmail.com", ""))),
      body: Stack(
        children: [
          chatMessageList(),
          Container(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(25, 255, 255, 255),
                      borderRadius: BorderRadius.circular(20)),
                  width: 300,
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.only(left: 20),
                      hintText: "Message",
                      // fillColor: Color.fromARGB(80, 255, 255, 255)
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45),
                          color: Theme.of(context).primaryColor),
                      child: const Icon(
                        Icons.send,
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  const MessageTile(
      {super.key, required this.message, required this.isSendByMe});
  final String message;
  final bool isSendByMe;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSendByMe
              ? Theme.of(context).primaryColor
              : const Color.fromARGB(26, 255, 255, 255), // Customize colors
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isSendByMe
                ? const Radius.circular(16)
                : const Radius.circular(0),
            bottomRight: isSendByMe
                ? const Radius.circular(0)
                : const Radius.circular(16),
          ),
        ),
        child: Text(
          message,
          style: const TextStyle(fontSize: 17, color: Colors.white),
        ),
      ),
    );
  }
}
