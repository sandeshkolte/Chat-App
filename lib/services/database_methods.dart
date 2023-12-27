import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseMethods {
  static Future<QuerySnapshot<Map<String, dynamic>>> getUserbyEmail(
      String email) async {
    return await FirebaseFirestore.instance
        .collection("chat_user")
        .where("email", isEqualTo: email)
        .get();
  }

  uploadUserData(userMap) {
    final fireStore = FirebaseFirestore.instance.collection("chat_user");
    fireStore.add(userMap);
  }

  chatroom(String chatroomID, chatroomMap) {
    final fireStore = FirebaseFirestore.instance.collection("Chat Room");
    fireStore.doc(chatroomID).set(chatroomMap).catchError((e) {
      debugPrint(e.toString());
    });
  }

  conversationMessages(String chatroomID, chatroomMap) {
    final fireStore = FirebaseFirestore.instance.collection("Chat Room");
    fireStore.doc(chatroomID).collection("chats").add(chatroomMap);
  }

 addconversationMessages(
      String chatroomID) {
    return FirebaseFirestore.instance
        .collection("Chat Room")
        .doc(chatroomID)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  chatRoomScreen(String username) {
    return FirebaseFirestore.instance
        .collection("Chat Room")
        .where("users", arrayContains: username)
        .snapshots();
  }
}
