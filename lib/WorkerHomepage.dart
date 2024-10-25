import 'package:flutter/material.dart';
import 'package:service_nest/Components/TextInput.dart';


class Workerhomepage extends StatefulWidget {
  const Workerhomepage({super.key});

  @override
  State<Workerhomepage> createState() => _WorkerhomepageState();
}

class _WorkerhomepageState extends State<Workerhomepage> {
  final NameController = TextEditingController();
  final PhoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          Center(
              child: Stack(
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage("Assets/applogo.png"),
              ),
              Positioned(
                  bottom: 10,
                  right: 15,
                  child: IconButton(
                      onPressed: () {}, icon: Icon(Icons.camera_alt)))
            ],
          )),
          const Padding(
            padding: const EdgeInsets.only(left: 27),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Name"),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Textinput(
              controller: NameController,
              hinttext: "Enter your Name",
              obscuretext: false),
          SizedBox(
            height: 10,
          ),
          const Padding(
            padding: const EdgeInsets.only(left: 27),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Phone Number"),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Textinput(
              controller: PhoneNumberController,
              hinttext: "Enter your number",
              obscuretext: false),
        ],
      ),
    ));
  }
}
