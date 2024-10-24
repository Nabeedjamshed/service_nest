import 'package:flutter/material.dart';

class Workeraccount extends StatefulWidget {
  const Workeraccount({super.key});

  @override
  State<Workeraccount> createState() => _WorkeraccountState();
}

class _WorkeraccountState extends State<Workeraccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Center(child: Text("Worker Account")),
        leading: const BackButton(),
      ),
    );
  }
}
