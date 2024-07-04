import 'package:admyrer/screens/update.dart';
import 'package:admyrer/screens/verify.dart';
import 'package:admyrer/widget/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Future<void> _checkOnboardingAndTokenStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    if (token != null) {
      Timer(
      const Duration(
        seconds: 5
      ),
      (){
         Navigator.pushReplacementNamed(context, "/tab");
      });
    }else{
      Timer(
      const Duration(
        seconds: 5
      ),
      (){
        //  Navigator.pushReplacementNamed(context, "/step");
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => Verify()));
      });
    }
  }

  @override
  void initState() { 
    super.initState();
    _checkOnboardingAndTokenStatus(); 
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            const Background(),
            CustomPaint(
              painter: CirclePainter(),
              size: Size(double.infinity, double.infinity),
            ),
          ],
        ),
      //   floatingActionButton: FloatingActionButton(
      //   onPressed: () => {
      //     // Navigator.pushNamed(context, "/step")
      //     Navigator.pushNamed(context, "/step")
      //   },
      //   backgroundColor: Colors.pink[400],
      //   child: const Icon(Icons.arrow_forward, color: Colors.white,),
      // ),
      // back
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Define paint properties
    final paint = Paint()
      ..color = Colors.pink.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    // Draw the circles
    canvas.drawCircle(Offset(size.width - 30, 40), 80, paint);
    paint.color = Colors.pink.withOpacity(0.4);
    canvas.drawCircle(Offset(size.width - 50, 60), 100, paint);
    paint.color = Colors.pink.withOpacity(0.2);
    canvas.drawCircle(Offset(size.width - 70, 80), 110, paint);

    // Draw the bottom-left circles
    paint.color = Colors.pink.withOpacity(0.6);
    canvas.drawCircle(Offset(50, size.height - 10), 80, paint);
    paint.color = Colors.pink.withOpacity(0.4);
    canvas.drawCircle(Offset(80, size.height - 30), 100, paint);
    paint.color = Colors.pink.withOpacity(0.2);
    canvas.drawCircle(Offset(100, size.height - 50), 110, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}