import 'package:admyrer/widget/backgrounds.dart';
import 'package:admyrer/widget/gradient_button.dart';
import 'package:admyrer/widget/bootstrap_textfield.dart';
import 'package:admyrer/widget/google_login.dart';
import 'package:admyrer/widget/facebook.dart';
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
        body: Stack(
          children: [
            Backgrounds(),
            _Tabs(),
          ],
        ),
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
        body: const TabBarView(
          children: [
            Center(child: Text('All')),
            Center(child: Text('Visits')),
            Center(child: Text('Likes')),
            Center(child: Text('Friends')),
          ],
        ),
      ),
    );
  }
}

