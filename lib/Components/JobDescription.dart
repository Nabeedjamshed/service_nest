import 'package:flutter/material.dart';

class JobdescriptionContainer extends StatelessWidget {
  String imageUrl;
  String Name;
  double? deviceWidth;
  double? deviceHeight;
  int? number;
  String address;
  JobdescriptionContainer(
      {super.key,
      required this.Name,
      required this.imageUrl,
      required this.number,
      required this.address});

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    return Container(
      height: 400,
      width: deviceWidth! * 0.9,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.grey[400]),
      child: Column(
        children: [
          Container(
            
            padding: EdgeInsets.symmetric(horizontal: 5),
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("Assets/electric$number.jpeg"),
                  fit: BoxFit.fill),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  Name,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
                ),
              ),
            ],
          ),
          
          SizedBox(
            width: deviceWidth! * 0.8,
            child: Text(
              address,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
