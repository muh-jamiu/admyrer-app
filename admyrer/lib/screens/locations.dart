import 'package:admyrer/widget/backgrounds.dart';
import 'package:flutter/material.dart';

class Locations extends StatefulWidget {
  const Locations({super.key});

  @override
  State<Locations> createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: const Stack(
          // padding: const EdgeInsets.all(15.0),
          children: [
            Backgrounds(),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Locations',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined),
                              SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'Nigeria',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.more,
                            color: Colors.pink,
                          ),
                          SizedBox(width: 15),
                          Icon(Icons.lock_clock_outlined),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  User(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQlURaEXw8yHRfSZOUq-_itLj9rIMMCaTFhFQ&s",
              height: 500,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: const Text(
              'Muhammad Jamiu',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
            child: const Row(children: [
              Icon(Icons.location_on_outlined, color: Colors.pink,),
              SizedBox(width: 2,),
              Text(
              'Lagos, Nigeria',
              style: TextStyle(fontSize: 20),
            ),
            ],),
          )
        ],
      ),
    );
  }
}
