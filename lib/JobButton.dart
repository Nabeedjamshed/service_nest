import 'package:flutter/material.dart';

class Jobbutton extends StatelessWidget {
  final VoidCallback onTap;
  final String buttonText;
  final IconData icon;
  final double height;

  const Jobbutton({
    Key? key,
    required this.onTap,
    required this.buttonText,
    required this.icon,
    this.height = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                buttonText,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
