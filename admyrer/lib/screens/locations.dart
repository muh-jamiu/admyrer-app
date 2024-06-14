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
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          // padding: const EdgeInsets.all(15.0),
          children: [
            const Backgrounds(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     const  Column(
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
                            color: Colors.pink[300],
                          ),
                          const SizedBox(width: 15),
                          Icon(Icons.compass_calibration, color: Colors.purple[300]),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Expanded(child: User()),
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
    return ListView(
      children: [Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                "/images/placeholder1.jpeg",
                height: 400,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: const Text(
                'Muhammad Jamiu',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child:  Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: Colors.pink[300],
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  const Text(
                    'Lagos, Nigeria',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(                    
                    onTap: () => {},
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(26, 233, 30, 98),
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: Icon(Icons.cancel_outlined, color: Colors.pink[300], size: 25,),
                    ),
                  ),
                  InkWell(
                    onTap: () => {},
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(35, 155, 39, 176),
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: const Icon(Icons.replay_outlined, color: Colors.purple, size: 25,),
                    ),
                  ),
                  InkWell(
                    onTap: () => {},
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.pink[300],
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: const Icon(Icons.heart_broken, color: Colors.white, size: 25,),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )],
    );
  }
}
