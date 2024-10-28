import 'package:flutter/material.dart';

class JobdescriptionContainer extends StatelessWidget {
  String
      ImageAddress; //dont forgot to replace this with Image taken from CloudStore
  String Name;
  JobdescriptionContainer(
      {super.key, required this.Name, required this.ImageAddress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.grey[400]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            ImageAddress,
            height: 100,
            width: 100,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              Name,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}
