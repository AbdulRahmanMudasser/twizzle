import 'package:flutter/material.dart';
import 'package:flutter_chat_messenger_app/config/app_size.dart';
import 'package:flutter_chat_messenger_app/widgets/reusable_button.dart';
import 'package:flutter_chat_messenger_app/widgets/reusable_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(25)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: AppSize.screenHeight * 0.02,
                ),

                // logo
                Icon(
                  Icons.message,
                  size: 100,
                  color: Colors.grey[800],
                ),

                SizedBox(
                  height: AppSize.screenHeight * 0.05,
                ),

                // welcome back message
                const Text(
                  "Welcome back you've been missed",
                  style: TextStyle(
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height: getProportionateScreenHeight(25),
                ),

                // email text field
                ReusableTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),

                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),

                // password text field
                ReusableTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),

                SizedBox(
                  height: getProportionateScreenHeight(25),
                ),

                // sign in button
                ReusableButton(
                  text: "Sign In",
                  onTap: () {},
                ),

                SizedBox(
                  height: getProportionateScreenHeight(50),
                ),

                // not a member? register now
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not a member?"),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Register Now",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
