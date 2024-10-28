import 'package:flutter/material.dart';
import 'package:service_nest/Components/RoleContainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:service_nest/LoginPage.dart';

class customerHome extends StatelessWidget {
  customerHome({super.key});
  double? deviceWidth;
  double? deviceHeight;
  String? Role;
  void SignUserOut() async {
    await FirebaseAuth.instance.signOut();
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

                    SignUserOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return Loginpage();
                    }));
                  },
                  icon: Icon(Icons.logout)),
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
                    ContainerColor: Colors.blue),
                Rolecontainer(
                    Role: "Plumber",
                    ImagePath: "Assets/Plumber.png",
                    ContainerColor: Colors.green),
                Rolecontainer(
                    Role: "Carpenter",
                    ImagePath: "Assets/Carpenter.png",
                    ContainerColor: const Color.fromARGB(255, 177, 175, 85)),
                Rolecontainer(
                    Role: "Painter",
                    ImagePath: "Assets/Painter.png",
                    ContainerColor: Colors.orange),
                Rolecontainer(
                    Role: "Maid",
                    ImagePath: "Assets/Maid.png",
                    ContainerColor: Colors.teal),
                Rolecontainer(
                    Role: "Parlor Ease",
                    ImagePath: "Assets/Parlor.png",
                    ContainerColor: const Color.fromARGB(255, 252, 229, 129))
              ],
            ),
          )
        ],
      ),
    ));
  }
}
