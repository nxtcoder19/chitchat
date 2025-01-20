import 'package:chitchat/helpers/helperfunctions.dart';
import 'package:chitchat/services/auth.dart';
import 'package:chitchat/services/database.dart';
import 'package:chitchat/views/TabViewController.dart';
import 'package:chitchat/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  const SignIn(this.toggleView, {Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();
  final AuthService authService = AuthService();
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> signIn() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final result = await authService.signInWithEmailAndPassword(
          emailEditingController.text.trim(),
          passwordEditingController.text.trim(),
        );

        if (result != null) {
          final userInfoSnapshot = await DatabaseMethods()
              .getUserInfo(emailEditingController.text.trim());

          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          await HelperFunctions.saveUserNameSharedPreference(
              userInfoSnapshot.docs[0]['userName']);
          await HelperFunctions.saveUserEmailSharedPreference(
              userInfoSnapshot.docs[0]['userEmail']);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TabViewController()),
          );
        } else {
          setState(
            () {
              isLoading = false;
            },
          );
          // Show snackbar or alert for invalid credentials
        }
      } catch (e) {
        print("Error during sign-in: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to sign in: $e")),
        );
        setState(() {
          isLoading = false;
        });
        // Show error message
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: appBarMain(context),
      body: isLoading
          ? const Center(
              // child: CircularProgressIndicator(),
              child: Text("Loading..."),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (val) =>
                              RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+$")
                                      .hasMatch(val ?? '')
                                  ? null
                                  : "Please enter a valid email",
                          controller: emailEditingController,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("Email"),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          obscureText: true,
                          validator: (val) => (val != null && val.length >= 6)
                              ? null
                              : "Enter a password with 6+ characters",
                          controller: passwordEditingController,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("Password"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Implement forgot password functionality
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text("Forgot Password?",
                              style: simpleTextStyle()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: signIn,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff007EF4),
                            Color(0xff2A75BC),
                          ],
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Sign In",
                        style: biggerTextStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: const Text(
                      "Sign In with Google",
                      style: TextStyle(fontSize: 17, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: simpleTextStyle()),
                      GestureDetector(
                        onTap: () => widget.toggleView(),
                        child: const Text(
                          "Register now",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
    );
  }
}
