import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_messenger_app/services/chat/chat_service.dart';
import 'package:flutter_chat_messenger_app/widgets/reusable_text_field.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserID,
  });

  final String receiverUserEmail;
  final String receiverUserID;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    // only send message if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverUserID,
        _messageController.text,
      );

      // clear the text controller after sending the message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserEmail),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // messages
            Expanded(
              child: _buildMessageList(),
            ),

            // user input
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        widget.receiverUserID,
        _firebaseAuth.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
            children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
          );
        }
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align the messages to the right if the sender is the current user
    // otherwise align to left
    Alignment alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    CrossAxisAlignment crossAxisAlignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    MainAxisAlignment mainAxisAlignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? MainAxisAlignment.end
        : MainAxisAlignment.start;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: [
          Text(data['senderEmail']),
          Text(data['message']),
        ],
      ),
    );
  }

  // build message input
  Widget _buildMessageInput() {
    return Row(
      children: [
        // text field
        Expanded(
          child: ReusableTextField(
            controller: _messageController,
            hintText: 'Enter Message',
            obscureText: false,
          ),
        ),

        // send button
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(
            Icons.arrow_upward,
            size: 40,
          ),
        ),
      ],
    );
  }
}
