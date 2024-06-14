import 'package:admyrer/widget/backgrounds.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body:_Tabs(),
      ),
    );
  }
}


class _Tabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
          bottom:const TabBar(
            indicatorColor: Color.fromARGB(248, 239, 4, 121),
            labelColor: Color.fromARGB(248, 239, 4, 121),
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Visits'),
              Tab(text: 'Likes'),
              Tab(text: 'Friends'),
            ],
          ),
        ),
        body: const Stack(
          children: [
            Backgrounds(),
            TabBarView(
            children: [
              All(),
              Visits(),
              Likes(),
              Friends(),
            ],
          )],
        ),
      ),
    );
  }
}


//visits
class Visits extends StatefulWidget {
  const Visits({super.key});

  @override
  State<Visits> createState() => _VisitsState();
}

class _VisitsState extends State<Visits> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          SizedBox(height: 80,),
          Text("Empty!", style: TextStyle(fontSize: 25, fontWeight:FontWeight.bold),),
          SizedBox(height: 20,),
          Text("You don't have any visits at the moment"),
        ],
      ),
    );
  }
}

// all
class All extends StatefulWidget {
  const All({super.key});

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {
  final items = List<String>.generate(5, (index) => 'Item $index');
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage("assets/images/placeholder1.jpeg"),
                ),
                const SizedBox(width: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(items[index], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),textAlign: TextAlign.start,),
                    const Text("Messaga Notifications", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w100, color: Color.fromARGB(255, 70, 70, 70)),),
                  ],
                ),
              ],
            ),
          );
        },
    );
  }
}


// likes
class Likes extends StatefulWidget {
  const Likes({super.key});

  @override
  State<Likes> createState() => _LikesState();
}

class _LikesState extends State<Likes> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          SizedBox(height: 80,),
          Text("Empty!", style: TextStyle(fontSize: 25, fontWeight:FontWeight.bold),),
          SizedBox(height: 20,),
          Text("You don't have any likes at the moment"),
        ],
      ),
    );
  }
}


//friends
class Friends extends StatefulWidget {
  const Friends({super.key});

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          SizedBox(height: 80,),
          Text("Empty!", style: TextStyle(fontSize: 25, fontWeight:FontWeight.bold),),
          SizedBox(height: 20,),
          Text("You don't have any friend request at the moment"),
        ],
      ),
    );
  }
}