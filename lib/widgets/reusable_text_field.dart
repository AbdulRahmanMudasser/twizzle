import 'package:flutter/material.dart';

class ReusableTextField extends StatelessWidget {
  const ReusableTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.inChatRoom = false,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool inChatRoom;

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
          borderSide:  BorderSide(
            color: Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(35),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(35),
        ),
        fillColor: Colors.grey[200],
        filled: true,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      ),
    );
  }
}
