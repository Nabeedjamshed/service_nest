import 'package:flutter/material.dart';
import 'package:service_nest/AccountType.dart';
import 'package:service_nest/Signuppage.dart';
import 'package:service_nest/WelcomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:service_nest/WorkerHomepage.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Service Nest",
      home: Welcomepage(),
      debugShowCheckedModeBanner: false,
    );
  }
}