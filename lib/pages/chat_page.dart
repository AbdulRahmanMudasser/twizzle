import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_messenger_app/services/chat/chat_service.dart';
import 'package:flutter_chat_messenger_app/widgets/chat_bubble.dart';
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
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(
          widget.receiverUserEmail,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey.shade800,
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

            const SizedBox(
              height: 25,
            ),
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

    Color backgroundColor =
        (data['senderId'] == _firebaseAuth.currentUser!.uid) ? Colors.green : Colors.grey.shade600;

    return Container(
      padding: const EdgeInsets.all(8),
      alignment: alignment,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: [
          // Text(data['senderEmail']),
          // const SizedBox(
          //   height: 5,
          // ),
          ChatBubble(
            message: data['message'],
            backgroundColor: backgroundColor,
          ),
        ],
      ),
    );
  }

  // build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          // text field
          Expanded(
            child: ReusableTextField(
              controller: _messageController,
              hintText: 'Enter Message',
              obscureText: false,
              inChatRoom: true,
              borderRadius: 35,
            ),
          ),

          // send button
          IconButton(
            onPressed: sendMessage,
            icon: Icon(
              Icons.arrow_circle_up,
              size: 40,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
