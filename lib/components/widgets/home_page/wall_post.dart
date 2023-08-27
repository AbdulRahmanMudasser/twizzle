import 'package:flutter/material.dart';
import 'package:flutter_chat_messenger_app/config/app_size.dart';

class WallPost extends StatelessWidget {
  const WallPost({
    super.key,
    required this.message,
    required this.user,
    // required this.time,
  });

  final String message;
  final String user;

  // final String time;

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
        children: [
          // profile pic
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[400],
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),

          const SizedBox(
            width: 20,
          ),

          // message and user email
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user,
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                message,
                softWrap: true,
                maxLines: 10,
              ),
            ],
          )
        ],
      ),
    );
  }
}
