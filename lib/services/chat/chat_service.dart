import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_messenger_app/models/message_model.dart';

class ChatService extends ChangeNotifier {
  // get the instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Send Message
  Future<void> sendMessage(String receiverId, String message) async {
    // get the current user
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String? currentUserEmail = _firebaseAuth.currentUser!.email;
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail!,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    // construct chat room id from user id and receiver id
    // (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, receiverId];

    ids.sort(); // sort the ids
    // this ensures the chat room id is always same for any lair of users
    // like john mary and mary john

    String chatRoomId = ids.join("_"); // combine the ids
    // into a single string to use it as a chat room Id

    // add new message to database
    await _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // Get Message
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    // construct chat room id from user ids
    // sorted to ensure it matches the id used when sending messages
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
