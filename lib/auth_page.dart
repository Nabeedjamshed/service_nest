import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Call the function to check user role and redirect
    _checkUserRoleAndRedirect(context);
    
    // Optionally, you can show a loading spinner while checking
    return const Center(child: CircularProgressIndicator());
  }

Future<void> _checkUserRoleAndRedirect(BuildContext context) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        String role = userDoc['role'];
        
        if (role == 'Worker') {
          Navigator.pushReplacementNamed(context, '/workerHome');
        } else if (role == 'Customer') {
          Navigator.pushReplacementNamed(context, '/customerHome');
        }
      } else {
        // Handle case where user document does not exist
        Navigator.pushReplacementNamed(context, '/Welcomepage');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/Welcomepage');
    }
  } catch (e) {
    // Handle errors here, possibly show an error message
    print('Error: $e');
  }
}

}
