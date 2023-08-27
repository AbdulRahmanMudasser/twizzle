import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_messenger_app/components/methods/snack_bar.dart';
import 'package:flutter_chat_messenger_app/config/app_colors.dart';
import 'package:flutter_chat_messenger_app/services/authentication/auth_service.dart';
import 'package:provider/provider.dart';

import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // sign user out
  void signOut() {
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

    // get the auth service
    final authenticationService = Provider.of<AuthenticationService>(context, listen: false);

    authenticationService.signOut();

    showSuccessSnackBar(
      title: 'Signed Out',
      error: 'See You Later',
      scaffoldMessenger: scaffoldMessenger,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Messages",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          // sign out button
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey.shade800,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: _buildUserList(),
          ),
        ],
      ),
    );
  }

  // build a list of users except for the current logged in user
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
            children: snapshot.data!.docs.map<Widget>((doc) => _buildUserListItem(doc)).toList(),
          );
        }
      },
    );
  }

  // build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // display all users except current user
    if (_firebaseAuth.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(data['email']),
        leading: const Icon(Icons.person),
        horizontalTitleGap: 30,
        contentPadding: const EdgeInsets.symmetric(horizontal: 30),
        onTap: () {
          // pass the clicked user's UID to chat page
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserEmail: data['email'],
                receiverUserID: data['uid'],
              ),
            ),
          );
        },
      );
    } else {
      // return empty container
      return Container();
    }
  }
}
