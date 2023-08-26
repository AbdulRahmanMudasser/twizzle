import 'package:flutter/material.dart';

class ReusableTextField extends StatelessWidget {
  const ReusableTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.inChatRoom = false,
    this.borderRadius = 0,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool inChatRoom;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: inChatRoom ? TextInputType.text : TextInputType.emailAddress,
      style: TextStyle(
        color: Colors.grey.shade700,
        fontSize: 18,
      ),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade400,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        fillColor: Colors.grey[200],
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
      ),
    );
  }
}
