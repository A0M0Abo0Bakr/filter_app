import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'permission_service.dart';
import 'media_service_interface.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 70,
              left: 50,
              right: 50,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: const Center(
                  child: Text(
                    'Welcome to our application',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage("Images/fci.jpg"),
                  ),
                  SizedBox(height: 20),
                  AvatarUploader(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AvatarUploader extends StatefulWidget {
  const AvatarUploader({Key? key});

  @override
  _AvatarUploaderState createState() => _AvatarUploaderState();
}

class _AvatarUploaderState extends State<AvatarUploader> {
  final MediaServiceInterface _mediaService = PermissionServiceImpl();

  File? selectedImageFile;

  Future<void> _pickImageSource() async {
    await _showCupertinoModalPopup();
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        File pickedImageFile = File(pickedFile.path);
        await _getImageFromFile(pickedImageFile);
      }
    } catch (e) {
      // Handle the error
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        File pickedFile = File(result.files.first.path!);
        await _getImageFromFile(pickedFile);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error picking image from gallery: $e");
      }
    }
  }

  Future<void> _getImageFromFile(File file) async {
    final pickedImageFile = await _mediaService.compressFile(file);

    if (pickedImageFile != null) {
      setState(() => selectedImageFile = pickedImageFile);
      // Open the new page with the image
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageViewerScreen(imagePath: pickedImageFile.path),
        ),
      );
    }
  }

  Future<void> _showCupertinoModalPopup() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            color: Colors.black,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildListTile('Camera', _pickImageFromCamera),
              const SizedBox(height: 7.0),
              _buildListTile('Gallery', _pickImageFromGallery),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListTile(String title, Function() onTapFunction) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        onTap: () async {
          Navigator.pop(context);
          await onTapFunction();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
          side: const BorderSide(color: Colors.red),
        ),
      ),
      onPressed: () async {
        await _pickImageSource();
        setState(() {});
      },
      child: const Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          '<<Your Image>>',
          style: TextStyle(
            fontSize: 35.0,
          ),
        ),
      ),
    );
  }
}

class PermissionServiceImpl implements PermissionService, MediaServiceInterface {
  @override
  Future<PermissionServiceResult> requestPhotosPermission() async {
    // Implement the logic for requesting photos permission
    return PermissionServiceResult(true); // You may adjust this based on the actual logic
  }

  @override
  Future<bool> handlePhotosPermission(BuildContext context) async {
    // Implement the logic for handling photos permission
    return true; // Replace with the actual logic
  }

  @override
  Future<PermissionServiceResult> requestCameraPermission() async {
    // Implement the logic for requesting camera permission
    return PermissionServiceResult(true); // You may adjust this based on the actual logic
  }

  @override
  Future<bool> handleCameraPermission(BuildContext context) async {
    // Implement the logic for handling camera permission
    return true; // Replace with the actual logic
  }

  @override
  Future<File?> compressFile(File file, {int quality = 30}) async {
    // Provide an empty implementation or the actual logic if needed
    return null;
  }

  @override
  Future<File?> uploadImage(BuildContext context, AppImageSource appImageSource, {bool shouldCompress = true}) async {
    // Provide an empty implementation or the actual logic if needed
    return null;
  }
}

class ImageViewerScreen extends StatelessWidget {
  final String imagePath;

  const ImageViewerScreen({Key? key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Viewer'),
      ),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}

class NewPage extends StatelessWidget {
  final Uint8List imageData;

  NewPage({required this.imageData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Page'),
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
