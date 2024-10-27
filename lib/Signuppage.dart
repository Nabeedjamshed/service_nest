import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:service_nest/Components/Dropdown.dart';
import 'package:service_nest/Components/Mybutton.dart';
import 'package:service_nest/Components/TextInput.dart';
import 'package:service_nest/Components/passwordTextFeild.dart';
import 'package:service_nest/userhome_page.dart';

class Signuppage extends StatelessWidget {
  Signuppage({super.key});
  
  final NameController = TextEditingController();
  final EmailController = TextEditingController();
  final PasswordController = TextEditingController();
  final ConfirmPasswordController = TextEditingController();
  final Usertype = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void SignupUser() {
      if (PasswordController.text != ConfirmPasswordController.text) {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Password not matched!"),
              );
            });
        return;
      } else {
        // Get the selected user type from the dropdown
        String role = Usertype.text; // Assuming Usertype is updated with the selected role from the dropdown

        signUpUser(EmailController.text, PasswordController.text, role).then((_) {
          print("Account Created");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => customerHome(),
            ),
          );
        }).catchError((error) {
          print("Error: ${error.toString()}");
        });
      }
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account?",
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Login now",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                "Assets/applogo.png",
                width: 200,
                height: 200,
              ),
              Text(
                "Let's create an account for you!",
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
              const SizedBox(
                height: 25,
              ),
              Textinput(
                  controller: NameController,
                  hinttext: "Name",
                  obscuretext: false),
              const SizedBox(
                height: 10,
              ),
              Textinput(
                  controller: EmailController,
                  hinttext: "Email",
                  obscuretext: false),
              const SizedBox(
                height: 10,
              ),
              Dropdown(), // Ensure Dropdown updates Usertype controller
              const SizedBox(
                height: 10,
              ),
              Passwordtextfeild(
                PasswordController: PasswordController,
                hinttext: "Password",
              ),
              const SizedBox(
                height: 10,
              ),
              Passwordtextfeild(
                PasswordController: ConfirmPasswordController,
                hinttext: "Confirm Password",
              ),
              const SizedBox(
                height: 25,
              ),
              Mybutton(
                buttonText: "SignUp",
                onTap: SignupUser,
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signUpUser(String email, String password, String role) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('Users').doc(uid).set({
        'email': email,
        'role': role, // "Worker" or "Customer"
      });

      print("User signed up successfully and role saved in Firestore.");
    } catch (e) {
      print("Error signing up: $e");
    }
  }
}
