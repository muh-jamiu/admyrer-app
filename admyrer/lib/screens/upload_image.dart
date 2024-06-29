import 'package:admyrer/widget/backgrounds.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {

    File? _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            const Backgrounds(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView(
                 children: <Widget>[
                  const SizedBox(height: 30,),
                  const Center(
                    child: Text("Upload Profile Picture", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                  ),
                  const SizedBox(height: 10,),
                  const Center(
                    child: Text("Profile picture let your friends easily recognise you", style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 76, 76, 76)), textAlign: TextAlign.center,)
                  ),
                  const SizedBox(height: 20,),
            if (_image != null) ...[
              Image.file(
                _image!,
                width: 300,
                height: 400,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _removeImage,
                child: const Text('Remove Image'),
              ),
            ] else ...[
              const SizedBox(height: 20),
              InkWell(
                onTap: _pickImage,
                child: Container(
                  decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color.fromARGB(255, 230, 243, 249), Colors.white],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  height: 400,
                  width: 300,
                  child: const Center(child: Text('Pick Image')),
                ),
              )
            ],
           const SizedBox(height: 20),
            if (_image != null)
              Row(
                children: [
                  TextButton(
                    onPressed: _pickImage,
                    child: const Text('Change', style: TextStyle(color: Colors.red),),
                  ),
                  const SizedBox(width: 15,),
                  TextButton(
                    onPressed: (){},
                    child: const Text('Upload'),
                  ),
                ],
              ),

            const Text("Uploading nude or explicit pictures is strictly prohibited on our platform. Any content that violates this rule will be immediately removed, and your account may be suspended or permanently banned. We are committed to maintaining a safe and respectful environment for all users. Please adhere to our guidelines and respect the community standards.", style: TextStyle(fontSize: 12, color: Colors.red))
            
          ],
        
              ),
            ),
          ],
        ),
      ),
    );
  }
}

