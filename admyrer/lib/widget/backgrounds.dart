
import 'package:flutter/material.dart';

class Backgrounds extends StatelessWidget {
  const Backgrounds({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/firstbackgroundeffects.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
