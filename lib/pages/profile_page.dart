import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_messenger_app/components/widgets/profile_page/text_box.dart';
import 'package:flutter_chat_messenger_app/config/app_size.dart';

import '../config/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // get the current user
  final currentUser = FirebaseAuth.instance.currentUser;

  // instance of fire store
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // edit field
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.darkColor,
          title: Text(
            "Edit $field",
            style: const TextStyle(color: Colors.white),
          ),
          content: TextField(
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter new $field",
              hintStyle: const TextStyle(color: Colors.grey),
            ),
            onChanged: (value) {
              newValue = value;
            },
          ),
          actions: [
            // cancel button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),

            // save button
            TextButton(
              onPressed: () => Navigator.of(context).pop(newValue),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    // update the firestore
    if (newValue.trim().isNotEmpty) {
      // only update if there is something in the text field
      await firestore.collection('users').doc(currentUser!.uid).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile Page",
        ),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: AppColors.darkColor,
      ),
      body: StreamBuilder(
        stream: firestore.collection('users').doc(currentUser!.uid).snapshots(),
        // we have to use uid because we are saving document by uid
        builder: (context, snapshot) {
          // get user data
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                SizedBox(
                  height: AppSize.screenHeight * 0.05,
                ),

                // profile pic
                const Icon(
                  Icons.person,
                  size: 72,
                ),

                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),

                // user email
                Text(
                  currentUser!.email.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),

                SizedBox(
                  height: getProportionateScreenHeight(50),
                ),

                // user details
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    'My Details',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),

                // username
                TextBox(
                  sectionName: 'Username',
                  text: userData['name'],
                  onPressed: () => editField('name'),
                ),

                // bio
                TextBox(
                  sectionName: 'Bio',
                  text: userData['bio'],
                  onPressed: () => editField('bio'),
                ),

                SizedBox(
                  height: getProportionateScreenHeight(50),
                ),

                // user posts
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    'My Posts',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error = ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
