import 'package:flutter/material.dart';

import '../widgets/reusable_text_field.dart';

Widget buildMessageInput({
  required TextEditingController messageController,
  required String hintText,
  required GestureTapCallback onTap,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        // text field
        Expanded(
          child: ReusableTextField(
            controller:messageController,
            hintText: hintText,
            obscureText: false,
            inChatRoom: true,
          ),
        ),

        // send button
        IconButton(
          onPressed: onTap,
          icon: const Icon(
            Icons.arrow_circle_up,
            size: 40,
            // color: Colors.grey.shade500,
          ),
        ),
      ],
    ),
  );
}
