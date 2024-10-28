import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:service_nest/LoginPage.dart';

class  customerHome extends StatelessWidget {
  const  customerHome({super.key});
  void SignUserOut() async {
  await FirebaseAuth.instance.signOut();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [Center(child: Text("User")),IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              SignUserOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      return Loginpage();
    }));
  },
  )]
    ));
  }
}