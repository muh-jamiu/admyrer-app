import 'package:admyrer/widget/backgrounds.dart';
import 'package:admyrer/widget/gradient_button.dart';
import 'package:admyrer/widget/bootstrap_textfield.dart';
import 'package:admyrer/widget/google_login.dart';
import 'package:admyrer/widget/facebook.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
                        'My profile',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.more_vert_outlined,
                            color: Colors.pink[300],
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
                  const SizedBox(
                    height: 20,
                  ),
                  const Settings(),
                  const SizedBox(height: 20,),
                  const Expanded(child: MyGridList())
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: const Color.fromARGB(255, 207, 37, 212),
                    width: 2.0)),
            child: const Padding(
              padding: EdgeInsets.all(5.0),
              child: CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage("/images/placeholder1.jpeg"),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Center(
            child: Text(
          "Ganiu Jamiu",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
              style: TextStyle(
                  fontSize: 15, color: Color.fromARGB(255, 63, 63, 63)),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: InkWell(
            onTap: () => {},
            child: Container(
              padding: const EdgeInsets.all(10),
              width: 130,
              decoration: BoxDecoration(
                  color: Color.fromARGB(23, 233, 30, 98),
                  borderRadius: BorderRadius.circular(5)),
              child: const Row(
                children: [
                  Icon(
                    Icons.edit_note_outlined,
                    color: Colors.pink,
                    size: 25,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Edit Profile",
                    style: TextStyle(color: Colors.pink),
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Icon(Icons.heart_broken_sharp,
                    color: Color.fromARGB(255, 63, 63, 63)),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "10 Likes",
                  style: TextStyle(
                      fontSize: 15, color: Color.fromARGB(255, 63, 63, 63)),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.remove_red_eye,
                    color: Color.fromARGB(255, 63, 63, 63)),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "10 Visits",
                  style: TextStyle(
                      fontSize: 15, color: Color.fromARGB(255, 63, 63, 63)),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.share,
                  color: Color.fromARGB(255, 63, 63, 63),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Share",
                  style: TextStyle(
                      fontSize: 15, color: Color.fromARGB(255, 63, 63, 63)),
                ),
              ],
            )
          ],
        ),
        
      ],
    );
  }
}

class MyGridList extends StatefulWidget {
  const MyGridList({super.key});

  @override
  State<MyGridList> createState() => _MyGridListState();
}

class _MyGridListState extends State<MyGridList> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        childAspectRatio: 3/3,
        mainAxisSpacing: 10,
        children: [
          InkWell(
            onTap: () => {},
            child: Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Color.fromARGB(35, 155, 39, 176),
                borderRadius: BorderRadius.circular(10)
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.replay_outlined, color: Colors.purple, size: 25,),
                  SizedBox(height: 10,),
                  Text("Live")
                ],
              ),
            ),
          ),
           InkWell(
            onTap: () => {},
            child: Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Color.fromARGB(35, 155, 39, 176),
                borderRadius: BorderRadius.circular(10)
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.replay_outlined, color: Colors.purple, size: 25,),
                  SizedBox(height: 10,),
                  Text("Live")
                ],
              ),
            ),
          ),
         InkWell(
            onTap: () => {},
            child: Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Color.fromARGB(35, 155, 39, 176),
                borderRadius: BorderRadius.circular(10)
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.replay_outlined, color: Colors.purple, size: 25,),
                  SizedBox(height: 10,),
                  Text("Live")
                ],
              ),
            ),
          ),
         InkWell(
            onTap: () => {},
            child: Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Color.fromARGB(35, 155, 39, 176),
                borderRadius: BorderRadius.circular(10)
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.replay_outlined, color: Colors.purple, size: 25,),
                  SizedBox(height: 10,),
                  Text("Live")
                ],
              ),
            ),
          ),
         InkWell(
            onTap: () => {},
            child: Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Color.fromARGB(35, 155, 39, 176),
                borderRadius: BorderRadius.circular(10)
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.replay_outlined, color: Colors.purple, size: 25,),
                  SizedBox(height: 10,),
                  Text("Live")
                ],
              ),
            ),
          ),
         InkWell(
            onTap: () => {},
            child: Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Color.fromARGB(35, 155, 39, 176),
                borderRadius: BorderRadius.circular(10)
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.replay_outlined, color: Colors.purple, size: 25,),
                  SizedBox(height: 10,),
                  Text("Live")
                ],
              ),
            ),
          ),
         InkWell(
            onTap: () => {},
            child: Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Color.fromARGB(35, 155, 39, 176),
                borderRadius: BorderRadius.circular(10)
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.replay_outlined, color: Colors.purple, size: 25,),
                  SizedBox(height: 10,),
                  Text("Live")
                ],
              ),
            ),
          ),
         InkWell(
            onTap: () => {},
            child: Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Color.fromARGB(35, 155, 39, 176),
                borderRadius: BorderRadius.circular(10)
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.replay_outlined, color: Colors.purple, size: 25,),
                  SizedBox(height: 10,),
                  Text("Live")
                ],
              ),
            ),
          ),
         InkWell(
            onTap: () => {},
            child: Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Color.fromARGB(35, 155, 39, 176),
                borderRadius: BorderRadius.circular(10)
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.replay_outlined, color: Colors.purple, size: 25,),
                  SizedBox(height: 10,),
                  Text("Live")
                ],
              ),
            ),
          ),
         InkWell(
            onTap: () => {},
            child: Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Color.fromARGB(35, 155, 39, 176),
                borderRadius: BorderRadius.circular(10)
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.replay_outlined, color: Colors.purple, size: 25,),
                  SizedBox(height: 10,),
                  Text("Live")
                ],
              ),
            ),
          ),
        
        ],
    );
  }
}
