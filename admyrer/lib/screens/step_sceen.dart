import 'package:admyrer/services/api_service.dart';
import 'package:admyrer/widget/backgrounds.dart';
import 'package:admyrer/widget/gradient_button.dart';
import 'package:admyrer/widget/normal_button.dart';
import 'package:flutter/material.dart';
import 'package:admyrer/screens/upload_image.dart';
import 'package:admyrer/screens/update.dart';
import 'package:admyrer/screens/register.dart';
import 'package:admyrer/screens/login.dart';

class StepSceen extends StatefulWidget {
  const StepSceen({super.key});

  @override
  State<StepSceen> createState() => _StepSceenState();
}

class _StepSceenState extends State<StepSceen> {
  bool isLoading = false;

  void login() {    
    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => Login()));
  }

  void register() {
    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => Register()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          // padding: const EdgeInsets.all(15.0),
          children: [
            const Backgrounds(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/TitileImages.png",
                    width: 300,
                    height: 300,
                  ),
                  const Center(
                    child: Text("Discover Your Dream Partner",
                        style:
                            TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  ),
                  const Center(
                    child: Text(
                        "Swipe right to like someone and if you both like each others, it's a match",
                        textAlign: TextAlign.center,
                        style: TextStyle()),
                  ),
                  const SizedBox(height: 50,),
                  GradientButton(text: "Login", onPressed:  login, isLoading:isLoading),
                  const SizedBox(height: 30,),
                  NormalButton(text: "Register", onPressed:  register),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
