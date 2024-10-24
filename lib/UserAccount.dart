import 'package:flutter/material.dart';
import 'package:service_nest/Components/Mybutton.dart';
import 'package:service_nest/Components/TextInput.dart';
import 'package:service_nest/Components/passwordTextFeild.dart';
import 'package:service_nest/ForgotPasswordPage.dart';
import 'package:service_nest/UserSignuppage.dart';

class Useraccount extends StatefulWidget {
  const Useraccount({super.key});

  @override
  State<Useraccount> createState() => _UseraccountState();
}

class _UseraccountState extends State<Useraccount> {
  final EmailController = TextEditingController();
  final PasswordController = TextEditingController();
  bool obscure_password = true;

  // Sign User In
  void SignUserIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    // Authentication Code here

    // When authenticated pop the Circular Progress Indicator
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        toolbarHeight: 35,
        backgroundColor: Colors.transparent,
        title: const Center(child: Text("User Account")),
        leading: const BackButton(),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Not a memeber?",
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(
              width: 4,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext) {
                      return Usersiguppage();
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
                "welcome back, you've been missed!",
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
              const SizedBox(
                height: 25,
              ),
              Textinput(
                controller: EmailController,
                hinttext: "Email",
                obscuretext: false,
              ),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return Forgotpasswordpage();
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
              const SizedBox(
                height: 25,
              ),
              Mybutton(
                buttonText: "SignIn",
                onTap: SignUserIn,
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
}
