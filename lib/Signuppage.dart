import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_nest/Components/Dropdown.dart';
import 'package:service_nest/Components/Mybutton.dart';
import 'package:service_nest/Components/TextInput.dart';
import 'package:service_nest/Components/passwordTextFeild.dart';
import 'package:service_nest/customerHome.dart';
import 'package:service_nest/workerHome.dart';

class Signuppage extends StatelessWidget {
  Signuppage({super.key});

  final NameController = TextEditingController();
  final EmailController = TextEditingController();
  final PasswordController = TextEditingController();
  final ConfirmPasswordController = TextEditingController();
  String? selectedRole; // Role selected from the dropdown
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    void SignupUser() async {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      await Future.delayed(const Duration(seconds: 1));
      if (PasswordController.text != ConfirmPasswordController.text) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text("Password not matched!"),
            );
          },
        );

        return;
      } else if (selectedRole == null) {
        Navigator.pop(context);
        // Ensure the role is selected before continuing
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Please select a role!"),
              );
            });
        return;
      } else {
        signUpUser(context, EmailController.text, PasswordController.text,
                selectedRole)
            .then((userRole) {
          if (userRole == "") {
            return;
          }

          if (userRole == "Worker") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => workerHome(),
              ),
            );
          } else if (userRole == "Customer") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => customerHome(),
              ),
            );
          }
        }).catchError((error) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(error),
                );
              });
        });
      }

      Navigator.pop(context);
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
              const SizedBox(width: 5),
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
              const SizedBox(height: 25),
              Textinput(
                controller: NameController,
                hinttext: "Name",
                obscuretext: false,
              ),
              const SizedBox(height: 10),
              Textinput(
                controller: EmailController,
                hinttext: "Email",
                obscuretext: false,
              ),
              const SizedBox(height: 10),
              Dropdown(
                Items: ["Worker", "Customer"],
                getRole: (String role) {
                  selectedRole = role; // Update selected role
                },
              ),
              const SizedBox(height: 10),
              Passwordtextfeild(
                PasswordController: PasswordController,
                hinttext: "Password",
              ),
              const SizedBox(height: 10),
              Passwordtextfeild(
                PasswordController: ConfirmPasswordController,
                hinttext: "Confirm Password",
              ),
              const SizedBox(height: 25),
              Mybutton(
                buttonText: "SignUp",
                onTap: SignupUser,
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> signUpUser(
      BuildContext context, String email, String password, String? role) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("User added in Firebase");
      String uid = userCredential.user!.uid;
      if (role == "Customer") {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'email': email,
          'role': role, // Save role ("Worker" or "Customer")
        });
      } else if (role == "Worker") {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'email': EmailController.text,
          'role': role,
          'name': NameController.text,
          'phonenumber': "",
          'workRole': null,
          'address': "",
          'profileImageUrl': "",
          'workerPosition': {"latitude": 0, "longitude": 0}
        });
      }

      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      String userRole = userDoc['role'];
      return userRole;
    } catch (e) {
      String errorMessage;

      if (e.toString().contains('weak-password')) {
        errorMessage = "The password should be at least 6 characters.";
      } else if (e.toString().contains('email-already-in-use')) {
        errorMessage = "An account already exists with this email.";
      } else if (e.toString().contains('invalid-email')) {
        errorMessage = "The email address is not valid.";
      } else {
        errorMessage = "An unknown error occurred. Please try again.";
      }

      // Display the error message in an AlertDialog
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Account Creation Failed"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );

      // Stop further code execution since account creation failed
      return "";
    }
  }
}
