import 'package:flutter/material.dart';
import 'package:flutter_chat_messenger_app/components/widgets/custom_snack_bar_content.dart';

showErrorSnackBar(String text, ScaffoldMessengerState scaffoldMessenger) {
  scaffoldMessenger.showSnackBar(
    SnackBar(
      content: CustomSnackBarContent(
        text: text,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}

showSuccessSnackBar(String text, ScaffoldMessengerState scaffoldMessenger) {
  scaffoldMessenger.showSnackBar(
    SnackBar(
      content: CustomSnackBarContent(
        text: text,
        errorSnackBar: false,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
