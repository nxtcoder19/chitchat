import 'package:chitchat/helpers/helperfunctions.dart';
import 'package:chitchat/services/auth.dart';
import 'package:chitchat/services/database.dart';
import 'package:chitchat/views/TabViewController.dart';
import 'package:chitchat/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;

  const SignUp(this.toggleView, {Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();
  final TextEditingController usernameEditingController =
      TextEditingController();

  final AuthService authService = AuthService();
  final DatabaseMethods databaseMethods = DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> signUp() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final result = await authService.signUpWithEmailAndPassword(
          usernameEditingController.text.trim(),
          emailEditingController.text.trim(),
          passwordEditingController.text.trim(),
        );

        if (result != null) {
          Map<String, String> userDataMap = {
            "userName": usernameEditingController.text.trim(),
            "userEmail": emailEditingController.text.trim(),
          };

          await databaseMethods.addUserInfo(userDataMap);

          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          await HelperFunctions.saveUserNameSharedPreference(
              usernameEditingController.text.trim());
          await HelperFunctions.saveUserEmailSharedPreference(
              emailEditingController.text.trim());

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TabViewController()),
          );
        } else {
          setState(() {
            isLoading = false;
          });
          // Show error message or snackbar
        }
      } catch (e) {
        print("Error during sign-up: $e");
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
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: usernameEditingController,
                          style: simpleTextStyle(),
                          validator: (val) {
                            return val == null || val.isEmpty || val.length < 3
                                ? "Enter Username 3+ characters"
                                : null;
                          },
                          decoration: textFieldInputDecoration("Username"),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: emailEditingController,
                          style: simpleTextStyle(),
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+$")
                                    .hasMatch(val ?? '')
                                ? null
                                : "Enter a valid email";
                          },
                          decoration: textFieldInputDecoration("Email"),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: passwordEditingController,
                          obscureText: true,
                          style: simpleTextStyle(),
                          validator: (val) {
                            return val == null || val.length < 6
                                ? "Enter Password 6+ characters"
                                : null;
                          },
                          decoration: textFieldInputDecoration("Password"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: signUp,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [Color(0xff007EF4), Color(0xff2A75BC)],
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Sign Up",
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
                      "Sign Up with Google",
                      style: TextStyle(fontSize: 17, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? ",
                          style: simpleTextStyle()),
                      GestureDetector(
                        onTap: () => widget.toggleView(),
                        child: const Text(
                          "SignIn now",
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
