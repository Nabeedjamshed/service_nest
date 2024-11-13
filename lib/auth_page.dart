import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:service_nest/Welcomepage.dart';
import 'package:service_nest/customerHome.dart';
import 'package:service_nest/workerHome.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Call the function to check user role and redirect
    _checkUserRoleAndRedirect(context);
    return const Center(child: CircularProgressIndicator());
  }

Future<void> _checkUserRoleAndRedirect(BuildContext context) async {
  try {
    User? user = await FirebaseAuth.instance.currentUser;
    

    if (user != null) {
      String uid = user.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        String role = userDoc['role'];
        
        if (role == 'Worker') {
          
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context){
          return workerHome();
        }));
        }
        else if (role == 'Customer') {
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context){
            return customerHome();
        }));
      } else {
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context){
            return Welcomepage();
        }));
        // Handle case where user document does not exist
      }
    } 
    }
    else {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context){
        return Welcomepage();
      }));
    }
  } catch (e) {
    // Handle errors here, possibly show an error message
    print('Error: $e');
  }
}

}
