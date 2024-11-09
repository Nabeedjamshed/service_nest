import 'package:flutter/material.dart';
import 'package:service_nest/AccountType.dart';
import 'package:service_nest/ParticularWorker.dart';
import 'package:service_nest/Signuppage.dart';

import 'package:service_nest/WelcomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:service_nest/auth_page.dart';
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
    return const MaterialApp(
      title: "Service Nest",
      home: AuthWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}
