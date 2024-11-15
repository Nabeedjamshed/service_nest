import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_nest/ParticularWorker.dart';

class Rolecontainer extends StatelessWidget {
  String Role;
  String ImagePath;
  Color ContainerColor;
  LatLng customerposition;
  Rolecontainer(
      {super.key,
      required this.Role,
      required this.ImagePath,
      required this.ContainerColor,
      required this.customerposition});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Particularworker(
            Role: Role,
            customerPosition: customerposition,
          );
        }));
      },
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: ContainerColor),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(Role),
                ],
              ),
            ),
            Image.asset(
              ImagePath,
              height: 130,
              width: 100,
            )
          ],
        ),
      ),
    );
  }
}
