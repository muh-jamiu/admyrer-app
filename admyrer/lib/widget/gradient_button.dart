import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  bool isLoading = false;

  GradientButton(
      {required this.text, required this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Colors.pink,
              Color.fromARGB(255, 218, 42, 249),
              Color.fromARGB(255, 146, 1, 171)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 16),
        child: Center(
          child: isLoading
              ? const SpinKitThreeBounce(
                  color: Colors.white,
                  size: 25.0,
                )
              : Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
