import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:service_nest/LoginPage.dart';

class  workerHome extends StatelessWidget {
  const  workerHome({super.key});
  void SignUserOut() async {
  await FirebaseAuth.instance.signOut();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [Center(child: Text("Worker")),IconButton(
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