import 'package:flutter/material.dart';

class NormalButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  NormalButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color.fromARGB(255, 245, 203, 244), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 16),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.purple,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
