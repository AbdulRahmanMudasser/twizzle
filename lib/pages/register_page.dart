import 'package:flutter/material.dart';
import 'package:flutter_chat_messenger_app/services/authentication/auth_service.dart';
import 'package:provider/provider.dart';

import '../config/app_size.dart';
import '../widgets/reusable_button.dart';
import '../widgets/reusable_text_field.dart';

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
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign up user
  void signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords Do Not Match"),
        ),
      );

      return;
    }

    // get auth service
    final authenticationService = Provider.of<AuthenticationService>(context, listen: false);

    try {
      await authenticationService.signUpWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(23)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox(
                  //   height: AppSize.screenHeight * 0.05,
                  // ),

                  // logo
                  Icon(
                    Icons.message,
                    size: 100,
                    color: Colors.grey[800],
                  ),

                  SizedBox(
                    height: AppSize.screenHeight * 0.05,
                  ),

                  // create an account
                  const Text(
                    "Let's create an account for you!",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xff8f8e8e),
                      fontWeight: FontWeight.w500,
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
                    height: getProportionateScreenHeight(10),
                  ),

                  // confirm password text field
                  ReusableTextField(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    obscureText: true,
                  ),

                  SizedBox(
                    height: getProportionateScreenHeight(25),
                  ),

                  // sign up button
                  ReusableButton(
                    text: "Sign Up",
                    onTap: signUp,
                  ),

                  SizedBox(
                    height: getProportionateScreenHeight(50),
                  ),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already a member?",
                        style: TextStyle(
                          color: Color(0xff8f8e8e),
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
      ),
    );
  }
}
