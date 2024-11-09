import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_nest/Components/JobDescription.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_map_math/flutter_geo_math.dart';
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
          // tempworkerAddress[distance] = data['address'];
          tempDict[distance] = data;
        }
      }

      var sortedByKey = Map.fromEntries(tempDict.entries.toList()
        ..sort((a, b) => a.key.compareTo(b
            .key))); // ->>>> remaning-->implement manully to sort dictionary on the basis of distance(key)
      for (var value in sortedByKey.values) {
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
                      int num = (index + 1) % 5;
                      
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: JobdescriptionContainer(
                          Name: worker[index]['name'],
                          imageUrl: worker[index]['profileImageUrl'],
                          number: num,
                          address: worker[index]['address'],
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
