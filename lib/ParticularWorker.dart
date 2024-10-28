import 'package:flutter/material.dart';
import 'package:service_nest/Components/JobDescription.dart';

class Particularworker extends StatelessWidget {
  String? Role;
  double? deviceHeight;
  double? deviceWidth;
  Particularworker({super.key, required this.Role});

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SizedBox(
            height: deviceHeight!,
            child: GridView.builder(
                padding: const  EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20),
                itemCount: 10,
                itemBuilder: (context, int index) {
                  return JobdescriptionContainer(
                      Name: "Nabeed Ali",
                      ImageAddress: "Assets/ServiceLogo.png");
                }),
          ),
        ),
      ),
    );
  }
}
