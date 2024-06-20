import 'package:flutter/material.dart';

class MyImageWidget extends StatefulWidget {
  final String image;
  const MyImageWidget({super.key,  required this.image});

  @override
  State<MyImageWidget> createState() => _MyImageWidgetState();
}

class _MyImageWidgetState extends State<MyImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Image.network(
  widget.image,
  fit: BoxFit.cover,
  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) {
      return child; // Image is fully loaded
    } else {
      return Image.asset('assets/images/icon.png');
    }
  },
  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
    return Image.asset('assets/images/icon.png'); // Path to your error image
  },
);

  }
}