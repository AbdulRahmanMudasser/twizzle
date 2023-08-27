import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_messenger_app/components/widgets/home_page/like_button.dart';
import 'package:flutter_chat_messenger_app/config/app_size.dart';

class WallPost extends StatefulWidget {
  const WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
    // required this.time,
  });

  final String message;
  final String user;
  final String postId;
  final List<String> likes; // the list of all the users that have liked

  // final String time;

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  // current user
  final currentUser = FirebaseAuth.instance.currentUser;

  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser!.email);
  }

  // toggle like
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    // access the document in firebase
    DocumentReference postReference =
        FirebaseFirestore.instance.collection('user_posts').doc(widget.postId);

    if (isLiked) {
      // if the post is now liked, add the user's email to the 'Liked' field
      postReference.update({
        'likes': FieldValue.arrayUnion([currentUser!.email])
      });
    } else {
      // if the post is now unLiked, remove the user's email from the 'Likes' field
      postReference.update({
        'likes': FieldValue.arrayRemove([currentUser!.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: getProportionateScreenHeight(25),
        left: getProportionateScreenWidth(25),
        right: getProportionateScreenWidth(25),
      ),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // profile pic
          // Container(
          //   padding: const EdgeInsets.all(10),
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: Colors.grey[400],
          //   ),
          //   child: const Icon(
          //     Icons.person,
          //     color: Colors.white,
          //   ),
          // ),

          // like button
          Column(
            children: [
              // like button
              LikeButton(
                isLiked: isLiked,
                onTap: toggleLike,
              ),

              const SizedBox(
                height: 5,
              ),

              // like count
              Text(
                widget.likes.length.toString(),
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),

          const SizedBox(
            width: 20,
          ),

          // message and user email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.message,
                  softWrap: true,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
