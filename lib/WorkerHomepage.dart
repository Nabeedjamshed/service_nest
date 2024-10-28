import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_nest/Components/Dropdown.dart';
import 'package:service_nest/Components/LocationPicker.dart';
import 'package:service_nest/Components/Mybutton.dart';
import 'package:service_nest/Components/TextInput.dart';

class Workerhomepage extends StatefulWidget {
  Workerhomepage({super.key});

  @override
  State<Workerhomepage> createState() => _WorkerhomepageState();
}

class _WorkerhomepageState extends State<Workerhomepage> {
  @override
  final NameController = TextEditingController();
  final PhoneNumberController = TextEditingController();
  String selectedLocation = "Select your Shop Location";
  File? Image;
  final ImagePicker _picker = ImagePicker();

  Future<void> imagepicker() async {
    final pickedfile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedfile != null) {
      setState(() {
        Image = File(pickedfile.path);
      });
    } else {
      print("Image not selected!");
    }
  }

  void _pickLocation(BuildContext context) async {
    selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPicker(),
      ),
    );

    if (selectedLocation != null) {
      setState(() {});
    }
  }

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
                child: Stack(
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: (Image == null)
                      ? AssetImage("Assets/ProfilePhoto.png")
                      : FileImage(Image!),
                ),
                Positioned(
                    bottom: 10,
                    right: 15,
                    child: IconButton(
                        color: Colors.teal,
                        onPressed: () {
                          imagepicker();
                        },
                        icon: const Icon(Icons.camera_alt)))
              ],
            )),
            const Padding(
              padding: EdgeInsets.only(left: 27),
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
            SizedBox(
              height: 10,
            ),
            const Padding(
              padding: const EdgeInsets.only(left: 27),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Select Role"),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Dropdown(Items: ["Electrician ", "Plumber", "AC Repairer", "Mad"]),
            const SizedBox(
              height: 5,
            ),
            Stack(children: [
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 30, 5),
                      child: Text(selectedLocation),
                    ),
                  )),
              Positioned(
                right: 20,
                bottom: 35,
                child: IconButton(
                    color: Colors.red,
                    onPressed: () {
                      _pickLocation(context);
                    },
                    icon: Icon(Icons.location_on)),
              ),
            ]),
            const SizedBox(
              height: 90,
            ),
            Mybutton(onTap: () {}, buttonText: "Save")
          ],
        ),
      ),
    ));
  }
}
