import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class  workerHome extends StatelessWidget {
  const  workerHome({super.key});
  void SignUserOut() async {
  await FirebaseAuth.instance.signOut();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              SignUserOut();
  },
  )
    ));

  }
}