import 'package:flutter/material.dart';

class MyImageWidget extends StatefulWidget {
  final String image;
  const MyImageWidget({super.key, required this.image});

  @override
  State<MyImageWidget> createState() => _MyImageWidgetState();
}

class _MyImageWidgetState extends State<MyImageWidget> {
  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
        placeholder: "assets/images/no_profile_image.webp",
        image: widget.image,
        height: 400,
        fit: BoxFit.cover,
        width: double.infinity,
        imageErrorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          return Image.asset(
            'assets/images/no_profile_image.webp',
            height: 400,
            fit: BoxFit.cover,
            width: double.infinity,
          );
        });
  }
}
