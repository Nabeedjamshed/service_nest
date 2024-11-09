import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_nest/Components/RoleContainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:service_nest/LoginPage.dart';
import 'package:location/location.dart' as loc;

class customerHome extends StatefulWidget {
  customerHome({super.key});

  @override
  State<customerHome> createState() => _customerHomeState();
}

class _customerHomeState extends State<customerHome> {
  double? deviceWidth;

  double? deviceHeight;

  String? Role;

  LatLng _currentposition = LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    _checkAndRequestLocation();
  }

  Future<void> _checkAndRequestLocation() async {
    bool serviceEnabled = await _getCurrentLocation();

    if (!serviceEnabled) {
      Future.delayed(Duration(microseconds: 2), _checkAndRequestLocation);
    }
  }

  Future<bool> _getCurrentLocation() async {
    loc.Location location = loc.Location();
    bool serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    loc.LocationData locationData = await location.getLocation();
    setState(() {
      _currentposition =
          LatLng(locationData.latitude!, locationData.longitude!);
    });

    return true;
  }

  void SignUserOut(BuildContext context) async {
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
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      });

                  SignUserOut(context);
                },
                icon: Icon(Icons.logout),
              )
            ],
          ),
          Center(
            child: Image.asset(
              "Assets/ServiceLogo.png",
              height: 180,
              width: 300,
            ),
          ),
          const SizedBox(height: 50),
          SizedBox(
            height: deviceHeight! * 0.6,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              padding: EdgeInsets.all(20),
              crossAxisSpacing: 20,
              mainAxisSpacing: 30,
              children: <Widget>[
                Rolecontainer(
                  Role: "Electrician",
                  ImagePath: "Assets/Electrician.png",
                  ContainerColor: Colors.blue,
                  customerposition: _currentposition,
                ),
                Rolecontainer(
                    Role: "Plumber",
                    ImagePath: "Assets/Plumber.png",
                    ContainerColor: Colors.green,
                    customerposition: _currentposition),
                Rolecontainer(
                    Role: "Carpenter",
                    ImagePath: "Assets/Carpenter.png",
                    ContainerColor: const Color.fromARGB(255, 177, 175, 85),
                    customerposition: _currentposition),
                Rolecontainer(
                    Role: "Painter",
                    ImagePath: "Assets/Painter.png",
                    ContainerColor: Colors.orange,
                    customerposition: _currentposition),
                Rolecontainer(
                    Role: "Maid",
                    ImagePath: "Assets/Maid.png",
                    ContainerColor: Colors.teal,
                    customerposition: _currentposition),
                Rolecontainer(
                    Role: "Parlor Ease",
                    ImagePath: "Assets/Parlor.png",
                    ContainerColor: const Color.fromARGB(255, 252, 229, 129),
                    customerposition: _currentposition)
              ],
            ),
          )
        ],
      ),
    ));
  }
}
