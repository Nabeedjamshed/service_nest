import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_nest/Components/Dropdown.dart';
import 'package:service_nest/Components/LocationPicker.dart';
import 'package:service_nest/Components/Mybutton.dart';
import 'package:service_nest/Components/TextInput.dart';
import 'LoginPage.dart';
import 'package:firebase_storage/firebase_storage.dart';

class workerHome extends StatefulWidget {
  workerHome({super.key});

  @override
  State<workerHome> createState() => _WorkerHomeState();
}

class _WorkerHomeState extends State<workerHome> {
  final NameController = TextEditingController();
  final PhoneNumberController = TextEditingController();
  String selectedLocation = "Select your Shop Location";
  String? workerRole;
  File? image;
  String? Initialvalue;
  String? ProfileImageUrl;
  final ImagePicker _picker = ImagePicker();
  final storage = FirebaseStorage.instance;
  late Future<void> _fetchDataFuture;
  LatLng? workerCurrentPosition;

  @override
  void initState() {
    super.initState();
    _fetchDataFuture = fetchData();
  }

  Future<void> fetchData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        setState(() {
          NameController.text = userDoc['name'] ?? '';
          PhoneNumberController.text = userDoc['phonenumber'] ?? '';
          workerRole = userDoc['workRole'];
          selectedLocation = (userDoc['address'] != "")
              ? userDoc['address']
              : 'Select your Shop Location';
          ProfileImageUrl = userDoc['profileImageUrl'];
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> imagePicker() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    } else {
      print("Image not selected!");
    }
    await UploadImage();
  }

  Future UploadImage() async {
    if (image == null) {
      return;
    }
    String imagepath = DateTime.now().millisecondsSinceEpoch.toString();
    String destination = 'images/$imagepath';

    try {
      await storage.ref(destination).putFile(image!);
      ProfileImageUrl = await storage.ref(destination).getDownloadURL();
      String uid = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({"profileImageUrl": ProfileImageUrl});
      setState(() {});
      print("upload Successful");
    } catch (e) {
      print(e);
    }
  }

  void pickLocation(BuildContext context) async {
    List<dynamic> result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationPicker()),
    );
    if (result[0] != null && result[1] != null) {
      setState(() {
        selectedLocation = result[0];
        workerCurrentPosition = result[1];
      });
    }
  }

  void signUserOut() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("SignOut"),
            content: Text("You will be SignOut!"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    return;
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Center(child: CircularProgressIndicator());
                        });

                    await FirebaseAuth.instance.signOut();

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return Loginpage();
                    }));
                  },
                  child: Text("OK")),
            ],
          );
        });
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
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
                signUserOut();
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: FutureBuilder<void>(
          future: _fetchDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error loading data"));
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                              radius: 80,
                              backgroundImage: ((ProfileImageUrl == "")
                                      ? AssetImage("Assets/ProfilePhoto.png")
                                      : NetworkImage(ProfileImageUrl!))
                                  as ImageProvider),
                          Positioned(
                            bottom: 10,
                            right: 15,
                            child: IconButton(
                              color: Colors.teal,
                              onPressed: imagePicker,
                              icon: const Icon(Icons.camera_alt),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: const EdgeInsets.only(left: 27),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [Text("Name")],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Textinput(
                      controller: NameController,
                      hinttext: "Enter your Name",
                      obscuretext: false,
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: const EdgeInsets.only(left: 27),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [Text("Phone Number")],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Textinput(
                      controller: PhoneNumberController,
                      hinttext: "Enter your number",
                      obscuretext: false,
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: const EdgeInsets.only(left: 27),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [Text("Select Role")],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Dropdown(
                      InitialValue: workerRole,
                      getRole: (String val) {
                        setState(() {
                          workerRole = val;
                        });
                      },
                      Items: [
                        "Electrician",
                        "Plumber",
                        "AC Repairer",
                        "Maid",
                        "Carpenter",
                        "Painter",
                        "Parlor Ease"
                      ],
                    ),
                    const SizedBox(height: 5),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 30, 5),
                              child: Text(selectedLocation),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          bottom: 35,
                          child: IconButton(
                            color: Colors.red,
                            onPressed: () => pickLocation(context),
                            icon: Icon(Icons.location_on),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 90),
                    Mybutton(
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                        if (ProfileImageUrl == "") {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  title: Text("Profile Image not Selected"),
                                  content: Text("Plese Select Profile Image"),
                                );
                              });
                          return;
                        }

                        if (selectedLocation == "Select your Shop Location") {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  title: Text("Location not Selected"),
                                  content: Text("Plese Select your Location"),
                                );
                              });
                          return;
                        }
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .update({
                            'email': user.email,
                            'role': "Worker",
                            'name': NameController.text,
                            'phonenumber': PhoneNumberController.text,
                            'workRole': workerRole,
                            'address': selectedLocation,
                            'workerPosition': {
                              "latitude": workerCurrentPosition?.latitude,
                              "longitude": workerCurrentPosition?.longitude
                            }
                          });
                        }
                        Navigator.pop(context);
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Successfully Saved"),
                              content:
                                  Text("Your Data have Successfully Saved"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      buttonText: "Save",
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
