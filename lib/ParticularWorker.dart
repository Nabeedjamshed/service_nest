import 'dart:convert';
import 'sortmap.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_nest/Components/JobDescription.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:service_nest/JobButton.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart' as loc;

class Particularworker extends StatefulWidget {
  String? Role;
  LatLng customerPosition;
  late Map<String, dynamic> workerPosition;

  Particularworker(
      {super.key, required this.Role, required this.customerPosition});

  @override
  State<Particularworker> createState() => _ParticularworkerState();
}

class _ParticularworkerState extends State<Particularworker> {
  double? deviceHeight;
  late Future<List<Map<String, dynamic>>>? _fetchDataFuture;
  double? deviceWidth;
  List<Map<String, dynamic>> items = [];
  Map<double, Map<String, dynamic>> tempDict = {};

  FlutterMapMath mapMath = FlutterMapMath();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>>? fetchdata() async {
    CollectionReference usersCollection = firestore.collection('users');

    try {
      QuerySnapshot querySnapshot = await usersCollection.get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (data['workRole'] == widget.Role) {
          widget.workerPosition = data['workerPosition'];
          double distance = DistanceBetweenUsers();

          tempDict[distance] = data;
        }
      }

      var sortedMap = MapSorter.sort(tempDict);

      for (var value in sortedMap.values) {
        items.add(value);
      }
    } catch (e) {
      print("Error fetching users: $e");
    }

    return items;
  }

  double DistanceBetweenUsers() {
    double distance = mapMath.distanceBetween(
        widget.customerPosition.latitude,
        widget.customerPosition.longitude,
        widget.workerPosition['latitude'] as double,
        widget.workerPosition['longitude'] as double,
        "kilometers");

    return distance;
  }

  void Call(String phoneNumber) async {
    final Uri dialUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(dialUri)) {
      await launchUrl(dialUri);
    } else {
      throw 'Could not open dialer';
    }
  }

  @override
  void initState() {
    _fetchDataFuture = fetchdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: BackButton(),
      ),
      body: FutureBuilder(
          future: _fetchDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text("Not availble in your region"),
                );
              }
              final List<Map<String, dynamic>> worker = snapshot.data!;

              return SizedBox(
                height: deviceHeight!,
                child: ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: deviceWidth! * 0.01),
                    itemCount: items.length,
                    itemBuilder: (context, int index) {
                      int num = (index + 1) % 6;

                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          height: 450,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                "Assets/${worker[index]['workRole']}${num}.jpg",
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                        worker[index]['profileImageUrl'],
                                      ) as ImageProvider,
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          worker[index]['name'],
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  worker[index]['address'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Jobbutton(
                                  onTap: () {
                                    Call(worker[index]['phonenumber']);
                                  },
                                  buttonText: "Call",
                                  icon: Icons.phone,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              );
            } else {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
          }),
    ));
  }
}
