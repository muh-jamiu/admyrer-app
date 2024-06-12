import 'package:flutter/material.dart';

class GoogleLogin extends StatelessWidget {
  final VoidCallback onPressed;

  GoogleLogin({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40.0),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/download.png', // Make sure the Google logo image is in your assets folder
              height: 24.0,
              width: 24.0,
            ),
            const SizedBox(width: 12.0),
            const Text(
              'Continue with Google',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}