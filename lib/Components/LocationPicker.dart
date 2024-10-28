import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationPicker extends StatefulWidget {

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  GoogleMapController? mapController;
  LatLng _currentPosition = LatLng(0, 0);
  String plusCode="Fetching data....";
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    loc.Location location = loc.Location();

    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    loc.LocationData _locationData = await location.getLocation();


    setState(() {
      _currentPosition =
          LatLng(_locationData.latitude!, _locationData.longitude!);
      _loading = false;
    });

    _getAddressFromLatLng(_currentPosition);
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      String url = "https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${position.latitude}&lon=${position.longitude}&accept-language=en";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String address = data["display_name"];

        setState(() {
          plusCode = address;
          // Since Plus Code is not available in OSM, we'll use the detailed address.
        });
      } else {
        print("Failed to load address");
        setState(() {
          plusCode = "Unable to fetch address";
        });
      }
    } catch (e) {
      print("Error in reverse geocoding: $e");
      setState(() {
        plusCode = "Error fetching address";
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    _currentPosition = position.target;
  }

  void _onCameraIdle() {
    _getAddressFromLatLng(_currentPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Picker'),
      ),
      body: Column(
        children: [
          _loading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition,
                      zoom: 16.0,
                    ),
                    onCameraMove: _onCameraMove,
                    onCameraIdle: _onCameraIdle,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(

              plusCode
              ,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {

             Navigator.pop(context, plusCode);
            },
            child: Text('Select Location'),
          ),
        ],
      ),
    );
  }
}
