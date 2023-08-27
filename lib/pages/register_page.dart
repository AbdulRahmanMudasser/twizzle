import 'package:flutter/material.dart';
import 'package:flutter_chat_messenger_app/components/methods/snack_bar.dart';
import 'package:flutter_chat_messenger_app/services/authentication/auth_service.dart';
import 'package:provider/provider.dart';

import '../components/widgets/reusable_button.dart';
import '../components/widgets/reusable_text_field.dart';
import '../config/app_colors.dart';
import '../config/app_size.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
    required this.onTap,
  });

  final GestureTapCallback onTap;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign up user
  void signUp() async {
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // show error if passwords do not match
    if (passwordController.text != confirmPasswordController.text) {
      showErrorSnackBar(
        error: "Passwords Do Not Match",
        scaffoldMessenger: scaffoldMessenger,
      );

      return;
    }

    // get auth service
    final authenticationService = Provider.of<AuthenticationService>(context, listen: false);

    // try sign up
    try {
      await authenticationService.signUpWithEmailAndPassword(
        nameController.text,
        emailController.text,
        passwordController.text,
      );

      // authenticationService.sendEmailVerification();

      // showErrorSnackBar('Email Verification Sent!', scaffoldMessenger);

      // pop loading circle
      if (context.mounted) Navigator.of(context).pop();

      // show when successfully signed up
      showSuccessSnackBar(
        error: 'Successfully Signed Up',
        scaffoldMessenger: scaffoldMessenger,
      );
    } catch (e) {
      // pop loading circle
      if (context.mounted) Navigator.of(context).pop();

      // show if there is any error
      showErrorSnackBar(
        error: e.toString(),
        scaffoldMessenger: scaffoldMessenger,
      );
    }
  }

  // dispose controllers
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                  height: AppSize.screenHeight * 0.1,
                ),

                // logo
                Icon(
                  Icons.message,
                  size: 100,
                  color: Colors.grey[800],
                ),

                SizedBox(
                  height: AppSize.screenHeight * 0.08,
                ),

                // create an account
                Text(
                  "Let's create an account for you!",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.lightTextColor,
                    // fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(
                  height: getProportionateScreenHeight(30),
                ),

                // name text field
                ReusableTextField(
                  controller: nameController,
                  hintText: "Name",
                  obscureText: false,
                ),

                SizedBox(
                  height: getProportionateScreenHeight(15),
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
                  height: getProportionateScreenHeight(15),
                ),

                // confirm password text field
                ReusableTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  obscureText: true,
                ),

                SizedBox(
                  height: getProportionateScreenHeight(50),
                ),

                // sign up button
                ReusableButton(
                  text: "Sign Up",
                  onTap: signUp,
                ),

                SizedBox(
                  height: getProportionateScreenHeight(40),
                ),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already a member?",
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
                        "Login now",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
