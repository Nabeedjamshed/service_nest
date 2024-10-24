import 'package:flutter/material.dart';

class Passwordtextfeild extends StatefulWidget {
  final PasswordController;
  final hinttext;
  const Passwordtextfeild({super.key, required this.PasswordController,required this.hinttext});

  @override
  State<Passwordtextfeild> createState() => _PasswordtextfeildState();
}

class _PasswordtextfeildState extends State<Passwordtextfeild> {
  bool obscure_password = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: widget.PasswordController,
        obscureText: obscure_password,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: widget.hinttext,
            hintStyle: TextStyle(color: Colors.grey[500]),
            suffixIcon: IconButton(
                onPressed: () {
                  obscure_password = !obscure_password;
                  setState(() {});
                },
                icon: Icon(obscure_password
                    ? Icons.visibility_off
                    : Icons.visibility))),
      ),
    );
  }
}
