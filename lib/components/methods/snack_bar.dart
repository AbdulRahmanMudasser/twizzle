import 'package:flutter/material.dart';
import 'package:flutter_chat_messenger_app/components/widgets/custom_snack_bar_content.dart';

showErrorSnackBar({
  String title = 'Oh Snap',
  String? error,
  required ScaffoldMessengerState scaffoldMessenger,
}) {
  scaffoldMessenger.showSnackBar(
    SnackBar(
      content: CustomSnackBarContent(
        text: error!,
        title: title,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}

showSuccessSnackBar({
  String title = 'Hi There',
  String? error,
  required ScaffoldMessengerState scaffoldMessenger,
}) {
  scaffoldMessenger.showSnackBar(
    SnackBar(
      content: CustomSnackBarContent(
        text: error!,
        errorSnackBar: false,
        title: title,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
