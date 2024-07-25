import 'package:flutter/material.dart';

void showCustomBottomSheet(BuildContext context, Widget content) {  
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          // color: Colors.pink[400],
        ),
        height: 700,
        child:  content,
        );
    },
  );
}


