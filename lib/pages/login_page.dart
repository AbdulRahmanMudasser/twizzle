import 'package:flutter/material.dart';
import 'package:flutter_chat_messenger_app/components/methods/snack_bar.dart';
import 'package:flutter_chat_messenger_app/config/app_assets.dart';
import 'package:flutter_chat_messenger_app/config/app_size.dart';
import 'package:flutter_chat_messenger_app/services/authentication/auth_service.dart';
import 'package:provider/provider.dart';

import '../components/widgets/reusable_button.dart';
import '../components/widgets/reusable_text_field.dart';
import '../components/widgets/square_tile.dart';
import '../config/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.onTap,
  });

  final GestureTapCallback onTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign in user
  void signIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // get the auth service
    final authenticationService = Provider.of<AuthenticationService>(context, listen: false);

    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

    // try sign in
    try {
      await authenticationService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );

      if (!mounted) return;
      Navigator.of(context).pop();
      showSuccessSnackBar('Successfully Logged In', scaffoldMessenger);
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      showErrorSnackBar(e.toString(), scaffoldMessenger);
    }
  }

  // google sign in
  void googleSignIn() {
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessengerState();

    try {
      AuthenticationService().signInWithGoogle();
      showSuccessSnackBar('Successfully Signed In', scaffoldMessenger);
    } catch (e) {
      showErrorSnackBar(e.toString(), scaffoldMessenger);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(23)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: AppSize.screenHeight * 0.04,
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
                Text(
                  "Welcome back you've been missed",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.lightTextColor,
                    // fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(
                  height: getProportionateScreenHeight(50),
                ),

                // email text field
                ReusableTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),

                SizedBox(
                  height: getProportionateScreenHeight(15),
                ),

                // password text field
                ReusableTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),

                SizedBox(
                  height: getProportionateScreenHeight(30),
                ),

                GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: getProportionateScreenHeight(40),
                ),

                // sign in button
                ReusableButton(
                  text: "Sign In",
                  onTap: signIn,
                ),

                SizedBox(
                  height: getProportionateScreenHeight(50),
                ),

                // or continue with
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[500],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Or continue with",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: getProportionateScreenHeight(50),
                ),

                // google, apple sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                      image: AppAssets.google,
                      onTap: googleSignIn,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SquareTile(
                      image: AppAssets.apple,
                      onTap: () {},
                    ),
                  ],
                ),

                SizedBox(
                  height: getProportionateScreenHeight(50),
                ),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: TextStyle(
                        color: AppColors.lightTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Register now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
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
