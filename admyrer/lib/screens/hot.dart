import 'package:admyrer/widget/backgrounds.dart';
import 'package:admyrer/widget/gradient_button.dart';
import 'package:admyrer/widget/bootstrap_textfield.dart';
import 'package:admyrer/widget/google_login.dart';
import 'package:admyrer/widget/facebook.dart';
import 'package:flutter/material.dart';

class Hot extends StatefulWidget {
  const Hot({super.key});

  @override
  State<Hot> createState() => _HotState();
}

class _HotState extends State<Hot> {
  void register() {
    Navigator.pushNamed(context, "/register");
  }

  void forgot() {
    Navigator.pushNamed(context, "/forgot");
  }

  void verify() {
    Navigator.pushNamed(context, "/tab");
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Stack(
          // padding: const EdgeInsets.all(15.0),
          children: [
            Backgrounds(),
            Center(child: Text("Hot"),)
          ],
        ),
      ),
    );
  }
}
