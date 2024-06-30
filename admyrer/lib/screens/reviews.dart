import 'package:admyrer/screens/register.dart';
import 'package:admyrer/screens/tab_screen.dart';
import 'package:admyrer/widget/backgrounds.dart';
import 'package:flutter/material.dart';

class Reviews extends StatefulWidget {
  const Reviews({super.key});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  void goTab() {
    Navigator.pushReplacementNamed(context, "/tab");
  }

  final Map<String, int> ratings = {
    'Cleanliness': 0,
    'Experience': 0,
    'Location': 0,
  };

  Widget buildStarRating(String category) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < (ratings[category] ?? 0) ? Icons.star : Icons.star_border,
            color:
                index < (ratings[category] ?? 0) ? Colors.yellow : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              ratings[category] = index + 1;
            });
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          // padding: const EdgeInsets.all(15.0),
          children: [
            const Backgrounds(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 80),
                      Center(
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Make a ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: 'Review',
                                style: TextStyle(
                                    color: Colors.purple,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ListView(
                        children: [
                          const Text(
                            'Cleanliness',
                            style: TextStyle(fontSize: 18),
                          ),
                          buildStarRating('Cleanliness'),
                          SizedBox(height: 20),
                          const Text(
                            'Experience',
                            style: TextStyle(fontSize: 18),
                          ),
                          buildStarRating('Experience'),
                          SizedBox(height: 20),
                          const Text(
                            'Location',
                            style: TextStyle(fontSize: 18),
                          ),
                          buildStarRating('Location'),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
