import 'package:flutter/material.dart';

class PasswordText extends StatelessWidget {
  final String labelText;
  final IconData? icon;
  final TextEditingController controller;

  PasswordText({
    required this.labelText,
    this.icon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 213, 213, 213)),
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 12, 0),
              child: Icon(icon, color: Colors.pink[300],),
            ),
            // const VerticalDivider(
            //   color: Color.fromARGB(255, 223, 223, 223),
            //   width: 1.0,
            // ),
          ],
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                 validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
                obscureText: true,
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: labelText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
