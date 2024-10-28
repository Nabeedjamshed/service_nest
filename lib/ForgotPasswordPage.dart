import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Add Firebase Auth import
import 'package:service_nest/Components/Mybutton.dart';
import 'package:service_nest/Components/TextInput.dart';

class Forgotpasswordpage extends StatefulWidget {
  const Forgotpasswordpage({super.key});

  @override
  State<Forgotpasswordpage> createState() => _ForgotpasswordpageState();
}

class _ForgotpasswordpageState extends State<Forgotpasswordpage> {
  final EmailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Initialize FirebaseAuth

  void ConfirmButton() async {
    // Show loading indicator
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    // Call the resetPassword function
    await resetPassword();

    // Pop the loading indicator
    Navigator.pop(context);
  }

  Future<void> resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: EmailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent!')),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Forgot your password?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                  child: Text(
                    "Please enter the account for which you want to reset the password.",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Textinput(
                    controller: EmailController,
                    hinttext: "Please enter your Email",
                    obscuretext: false),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              child: Mybutton(onTap: ConfirmButton, buttonText: "Confirm"),
            ),
          ],
        ),
      ),
    );
  }
}
