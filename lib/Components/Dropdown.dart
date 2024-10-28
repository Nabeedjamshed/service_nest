import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  final Function(String) getRole; // Callback to pass the selected value
  List<String> Items;

  Dropdown({required this.getRole,required this.Items ,super.key});

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: "Select Role",
          hintStyle:
              TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w500),
        ),
        value: selectedValue,
        items: widget.Items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            selectedValue = newValue!;
            widget.getRole(
                selectedValue!); // Call the callback to update the role
          });
        },
        validator: (value) => value == null ? 'Please select a role' : null,
      ),
    );
  }
}
