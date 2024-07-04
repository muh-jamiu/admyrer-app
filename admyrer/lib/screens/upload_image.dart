import 'package:admyrer/widget/backgrounds.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:admyrer/services/api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admyrer/screens/update.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {

  final ApiService _apiService = ApiService();
  File? _image;
  bool isLoading = false;
  late String _authToken;
  final ImagePicker _picker = ImagePicker();

  
  void showErrorToast(String message, Color color) {
    Fluttertoast.showToast(
      msg: "$message",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 5,
      textColor: Colors.white,
      backgroundColor: Colors.pink[300],
      fontSize: 15.0,
    );
  }


  
  void _upload_() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _authToken = prefs.getString('authToken') ?? '';
    });

    if (true) {
      setState(() {
        isLoading = true;
      });

      final user = await _apiService.postRequest("update-user", {
        "image": _image,
        "id": _authToken ?? "0",
      });

      if (user.statusCode != 200) {
        showErrorToast("Something went wrong, Please try again",
            const Color.fromARGB(255, 238, 71, 126));
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Update()));
        return;
      } else {
        showErrorToast("Image uploaded successfully",
            const Color.fromARGB(255, 100, 246, 190));
        Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Update()));
        });
      }
    }
  }


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
                  isLoading
                      ? SpinKitThreeBounce(
                          color: Colors.pink[400],
                          size: 25.0,
                        )
                      : 
                  TextButton(
                    onPressed: _upload_,
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

