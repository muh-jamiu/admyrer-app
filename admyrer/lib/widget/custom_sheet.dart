import 'package:flutter/material.dart';
import 'package:admyrer/widget/gradient_button.dart';
import 'package:admyrer/widget/normal_button.dart';

class CustomSheet extends StatefulWidget {
  final Function goSearch;
  const CustomSheet({super.key, required this.goSearch});

  @override
  State<CustomSheet> createState() => _CustomSheetState();
}

class _CustomSheetState extends State<CustomSheet> {
  bool isBoys = false;
  bool isGirls = false;
  bool isBoth = false;
  final TextEditingController _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 20),
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search user by name, age, username, height etc.....',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            activeColor: Colors.pink[400],
            title: const Text('Boys'),
            value: !isBoys,
            onChanged: (bool value) {
              setState(() {
                isBoys = value;
              });
            },
          ),
          SwitchListTile(
            activeColor: Colors.pink[400],
            title: const Text('Girls'),
            value: isGirls,
            onChanged: (bool value) {
              setState(() {
                isGirls = value;
                isBoys = !value && !isBoth ? false : isBoys;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Both'),
            activeColor: Colors.pink[400],
            value: isBoth,
            onChanged: (bool value) {
              setState(() {
                isBoth = value;
                if (value) {
                  isBoys = true;
                  isGirls = true;
                }
              });
            },
          ),
          const SizedBox(height: 16),
          Column(
            // mainAxisAlignment:
            //     MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GradientButton(
                  text: "Filter", onPressed: () =>  widget.goSearch(_searchController.text), isLoading: false),
              const SizedBox(height: 20),
              NormalButton(text: "Reset", onPressed: () => {}),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
