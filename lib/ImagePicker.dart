import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class ImagePickerWidget extends StatefulWidget {
  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? Image; // Use nullable type
  final ImagePicker _picker = ImagePicker();

  Future<void> imagepicker() async {
    final pickedfile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedfile != null) {
      setState(() {
        Image = File(pickedfile.path);
      });
    } else {
      print("Image not selected!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick Image from Gallery"),
      ),
      body: Center(
        child: CircleAvatar(
          radius: 50,
          backgroundImage: (Image == null)
              ? AssetImage("Assets/ProfilePhoto.png")
              : FileImage(Image!) as ImageProvider, // Correctly use ImageProvider
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: imagepicker,
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
