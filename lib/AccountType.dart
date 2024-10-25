import 'package:flutter/material.dart';
import 'package:service_nest/LoginPage.dart';
import 'package:service_nest/WorkerAccount.dart';

class Accounttype extends StatefulWidget {
  const Accounttype({super.key});

  @override
  State<Accounttype> createState() => _AccounttypeState();
}

class _AccounttypeState extends State<Accounttype> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Center(
          child: Text("Account Type"),
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Colors.transparent,
      ),
      body: Column(
        children: [
          Image.asset(
            "Assets/applogo.png",
            height: 250,
            width: 350,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const Loginpage(
                      );
                    }));
                  },
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 241, 173, 24)),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 70, top: 5),
                          child: Text(
                            "Customer",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Image.asset("Assets/userlast.png",
                            width: 200, height: 135)
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                  child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const Loginpage(
                    
                    );
                  }));
                },
                child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 241, 173, 24)),
                    child: Column(children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 100, top: 5),
                        child: Text("Worker",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Image.asset(
                        "Assets/workerlast.png",
                        width: 150,
                        height: 135,
                      ),
                    ])),
              ))
            ],
          ),
        ],
      ),
    );
  }
}
