import 'package:admyrer/widget/backgrounds.dart';
import 'package:admyrer/widget/gradient_button.dart';
import 'package:admyrer/widget/bootstrap_textfield.dart';
import 'package:admyrer/widget/google_login.dart';
import 'package:admyrer/widget/facebook.dart';
import 'package:flutter/material.dart';
// import "package:Admyrer/widget/background.dart";

class Hot extends StatefulWidget {
  const Hot({super.key});

  @override
  State<Hot> createState() => _HotState();
}

class _HotState extends State<Hot> {
  void register() {
    Navigator.pushNamed(context, "/register");
  }

  void forgot() {
    Navigator.pushNamed(context, "/forgot");
  }

  void verify() {
    Navigator.pushNamed(context, "/tab");
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Explore',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.more_vert_outlined,
                            color: Colors.grey[800],
                          ),
                          const SizedBox(width: 15),
                          Icon(Icons.diamond_rounded, color: Colors.blue[300]),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        const Users(),
                        const SizedBox(
                          height: 15,
                        ),
                        FirstSection(),
                        const SizedBox(
                          height: 35,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Popular Matches",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600)),
                            Text(
                              "See All",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.purple[300]),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(height: 400, child: AllUSers()),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Other Users",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600)),
                            Text(
                              "See All",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.purple[300]),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(height: 500, child: AllUSers())
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(10, (index) {
          return Column(
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color.fromARGB(255, 207, 37, 212),
                            width: 2.0)),
                    child: const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage("assets/images/placeholder1.jpeg"),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                children: [
                  SizedBox(width: 20),
                  Text(
                    "Larvish007",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w100,
                        color: Color.fromARGB(255, 40, 40, 40)),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}

class FirstSection extends StatefulWidget {
  const FirstSection({super.key});

  @override
  State<FirstSection> createState() => _FirstSectionState();
}

class _FirstSectionState extends State<FirstSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  "assets/images/placeholder1.jpeg",
                  height: 200,
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
                child: Row(
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () => {},
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(26, 233, 30, 98),
                            borderRadius: BorderRadius.circular(50)),
                        child: Icon(
                          Icons.cancel_outlined,
                          color: Colors.pink[300],
                          size: 25,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () => {},
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.pink[300],
                            borderRadius: BorderRadius.circular(50)),
                        child: const Icon(
                          Icons.heart_broken,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        )
      ],
    );
  }
}

class AllUSers extends StatefulWidget {
  const AllUSers({super.key});

  @override
  State<AllUSers> createState() => _AllUSersState();
}

class _AllUSersState extends State<AllUSers> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      childAspectRatio: 3 / 3,
      mainAxisSpacing: 15,
      children: [
        InkWell(
          onTap: () => {},
          child: Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset("assets/images/placeholder1.jpeg", fit: BoxFit.cover),
          ),
        ),
        InkWell(
          onTap: () => {},
          child: Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset("assets/images/placeholder1.jpeg", fit: BoxFit.cover),
          ),
        ),
        InkWell(
          onTap: () => {},
          child: Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset("assets/images/placeholder1.jpeg", fit: BoxFit.cover),
          ),
        ),
        InkWell(
          onTap: () => {},
          child: Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset("assets/images/placeholder1.jpeg", fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}
