import 'package:admyrer/screens/register.dart';
import 'package:admyrer/screens/tab_screen.dart';
import 'package:admyrer/widget/backgrounds.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Reviews extends StatefulWidget {
  const Reviews({super.key});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  void goTab() {
    Navigator.pushReplacementNamed(context, "/tab");
  }

  void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: "$message",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 5,
      textColor: Colors.white,
      backgroundColor: Color.fromARGB(255, 98, 240, 178),
      fontSize: 15.0,
    );
  }


  final Map<String, int> ratings = {
    'Communication': 0,
    'Honesty': 0,
    'Respect': 0,
    'Compatibility': 0,
    'Overall Experience': 0,
    'Safety': 0,
    'Authencity': 0,
    'Effort': 0,
    'Recommendation': 0,
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
                children: [
                  const SizedBox(height: 30),
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
                  Expanded(
                    child: ListView(
                      children: [
                        const Text(
                          'Communication',
                          style: TextStyle(fontSize: 18),
                        ),
                        buildStarRating('Communication'),
                        Divider(color: Colors.grey[300]),
                        const Text(
                          'Honesty',
                          style: TextStyle(fontSize: 18),
                        ),
                        buildStarRating('Honesty'),
                        Divider(color: Colors.grey[300]),
                        const Text(
                          'Respect',
                          style: TextStyle(fontSize: 18),
                        ),
                        buildStarRating('Respect'),
                        Divider(color: Colors.grey[300]),
                        const Text(
                          'Compatibility',
                          style: TextStyle(fontSize: 18),
                        ),
                        buildStarRating('Compatibility'),
                        Divider(color: Colors.grey[300]),
                        const Text(
                          'Overall Experience',
                          style: TextStyle(fontSize: 18),
                        ),
                        buildStarRating('Overall Experience'),
                        Divider(color: Colors.grey[300]),
                        const Text(
                          'Safety',
                          style: TextStyle(fontSize: 18),
                        ),
                        buildStarRating('Safety'),
                        Divider(color: Colors.grey[300]),
                        const Text(
                          'Authencity',
                          style: TextStyle(fontSize: 18),
                        ),
                        buildStarRating('Authencity'),
                        Divider(color: Colors.grey[300]),
                        const Text(
                          'Effort',
                          style: TextStyle(fontSize: 18),
                        ),
                        buildStarRating('Effort'),
                        Divider(color: Colors.grey[300]),
                        const Text(
                          'Recommendation',
                          style: TextStyle(fontSize: 18),
                        ),
                        buildStarRating('Recommendation'),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.pushReplacementNamed(context, "/tab");
                                Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => TabScreen()));
                              },
                            ),
                            TextButton(
                              child: const Text(
                                'Submit Review',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                showErrorToast("Reviews Submitted");
                                Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => TabScreen()));
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
