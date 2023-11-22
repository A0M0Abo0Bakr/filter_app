import 'dart:typed_data';
import 'package:flutter/material.dart';

class NewPage extends StatelessWidget {
  final Uint8List imageData;

  NewPage({required this.imageData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Page'),
      ),
      body: Center(
        child: Image.memory(
          imageData,
          width: 250,
          height: 250,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// ... الجزء الباقي من الكود
class ImageFilterScreen extends StatelessWidget {
  final Uint8List imageData;

  ImageFilterScreen({required this.imageData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Filter Screen'),
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Image.memory(
              imageData,
              width: 250,
              height: 250,
              fit: BoxFit.cover,
              color: Colors.blue,
              colorBlendMode: BlendMode.overlay,
            ),
          ),
        ),
      ),
    );
  }
}
