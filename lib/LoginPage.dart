import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:service_nest/Components/Mybutton.dart';
import 'package:service_nest/Components/TextInput.dart';
import 'package:service_nest/Components/passwordTextFeild.dart';
import 'package:service_nest/ForgotPasswordPage.dart';
import 'package:service_nest/Signuppage.dart';
import 'package:service_nest/customerHome.dart';
import 'package:service_nest/workerHome.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final TextEditingController EmailController = TextEditingController();
  final TextEditingController PasswordController = TextEditingController();
  bool obscurePassword = true;

  // Sign User In
  void SignUserIn() async {
    // Show loading indicator
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    // Authentication code
    try {
      // Sign in with Firebase Auth
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: EmailController.text,
        password: PasswordController.text,
      );

      // Fetch the user's role from Firestore
      String uid = userCredential.user!.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      // Check if the user document exists and get the role
      if (userDoc.exists) {
        String role = userDoc['role'];
        print(role);
        // Close the loading indicator
        Navigator.pop(context);

        // Redirect based on the role
        if (role == 'Customer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => customerHome()),
          );
        } else if (role == 'Worker') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => workerHome()),
          );
        } else {
          // Handle any unexpected role
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Invalid Role"),
                content:
                    const Text("An unexpected role was found for this user."),
              );
            },
          );
        }
      } else {
        // If no user document exists in Firestore
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("User data not found."),
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      // Close loading indicator
      Navigator.pop(context);

      // Show error message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Login Failed"),
            content: Text(e.message ?? "Unknown error occurred"),
          );
        },
      );
    }
  }

  // Row to provide SignUp option
  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Signuppage()),
            );
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        toolbarHeight: 35,
        backgroundColor: Colors.transparent,
        leading: const BackButton(),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Not a member?",
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext) {
                  return Signuppage();
                }));
              },
              child: const Text(
                "Register now",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 220,
                width: 350,
                child: Image.asset(
                  "Assets/applogo.png",
                ),
              ),
              Text(
                "Welcome back, you've been missed!",
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
              const SizedBox(height: 25),
              Textinput(
                controller: EmailController,
                hinttext: "Email",
                obscuretext: false,
              ),
              const SizedBox(height: 10),
              Passwordtextfeild(
                PasswordController: PasswordController,
                hinttext: "Password",
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const Forgotpasswordpage();
                        }));
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Mybutton(
                buttonText: "SignIn",
                onTap: SignUserIn,
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
