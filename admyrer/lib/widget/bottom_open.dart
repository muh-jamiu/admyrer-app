import 'package:flutter/material.dart';

void showCustomBottomSheet(BuildContext context) {
  bool isBoys = false;
  bool isGirls = false;
  bool isBoth = false;

  TextEditingController _searchController = TextEditingController();
  
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          color: Colors.pink[400],
        ),
        height: 500,
        child:  Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SwitchListTile(
                title: Text('Boys'),
                value: isBoys,
                onChanged: (bool value) {
                },
              ),
              SwitchListTile(
                title: Text('Girls'),
                value: isGirls,
                onChanged: (bool value) {
                },
              ),
              SwitchListTile(
                title: Text('Both'),
                value: isBoth,
                onChanged: (bool value) {
                },
              ),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      // Handle search action
                    },
                    child: Text('Search'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                    },
                    child: Text('Reset'),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      );
    },
  );
}


