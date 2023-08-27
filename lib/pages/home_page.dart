import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_messenger_app/components/methods/message_input.dart';
import 'package:flutter_chat_messenger_app/components/widgets/home_page/wall_post.dart';
import 'package:flutter_chat_messenger_app/config/app_colors.dart';
import 'package:flutter_chat_messenger_app/config/app_size.dart';
import 'package:provider/provider.dart';

import '../components/methods/snack_bar.dart';
import '../services/authentication/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // current user
  final _currentUser = FirebaseAuth.instance.currentUser;

  // instance of fire store
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // text controller
  final TextEditingController _messageController = TextEditingController();

  // sign user out
  void signOut() {
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

    // get the auth service
    final authenticationService = Provider.of<AuthenticationService>(context, listen: false);

    // sign out user
    authenticationService.signOut();

    // show snack bar after successful logout
    showSuccessSnackBar(
      title: 'Signed Out',
      error: 'See You Later',
      scaffoldMessenger: scaffoldMessenger,
    );
  }

  // post message
  void postMessage() {
    // only post if there is something in the text field
    if (_messageController.text.isNotEmpty) {
      // store in firebase
      _firestore.collection('user_posts').add({
        'email': _currentUser!.email,
        'post': _messageController.text,
        'timestamp': Timestamp.now(),
        'likes': [],
      });
    }

    // clear the text field
    setState(() {
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          "The Wall",
        ),
        centerTitle: true,
        actions: [
          // sign out button
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
        foregroundColor: Colors.white,
        backgroundColor: AppColors.darkColor,
      ),
      body: Center(
        child: Column(
          children: [
            // the wall
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('user_posts')
                    .orderBy('timestamp', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        // get the message
                        final post = snapshot.data!.docs[index];

                        return WallPost(
                          message: post['post'],
                          user: post['email'],
                          postId: post.id,
                          likes: List<String>.from(post['likes'] ?? []),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error - ${snapshot.error}"),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),

            // post message
            buildMessageInput(
              messageController: _messageController,
              hintText: 'Write something on the wall',
              onTap: postMessage,
            ),

            SizedBox(
              height: getProportionateScreenHeight(20),
            ),

            // logged in as
            Text(
              "Logged in as ${_currentUser!.email}",
              style: const TextStyle(color: Colors.grey),
            ),

            SizedBox(
              height: getProportionateScreenHeight(50),
            ),
          ],
        ),
      ),
    );
  }
}
