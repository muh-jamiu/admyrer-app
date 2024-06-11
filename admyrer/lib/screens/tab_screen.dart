import 'package:admyrer/screens/chat.dart';
import 'package:admyrer/screens/hot.dart';
import 'package:admyrer/screens/locations.dart';
import 'package:admyrer/screens/notifications.dart';
import 'package:admyrer/screens/profile.dart';
import 'package:admyrer/widget/backgrounds.dart';
import 'package:admyrer/widget/gradient_button.dart';
import 'package:flutter/material.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  void home() {
    Navigator.pushNamed(context, "/home");
  }

  int _currentIndex = 0;
  final List<Widget> _pages = [
    const Locations(),
    const Hot(),
    const Notifications(),
    const Chat(),
    const Profile(),
  ];

  final _pageController = PageController();
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.pink[50],
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: _pages,
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                )
              ]
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              selectedItemColor: Colors.pink[300],
              unselectedItemColor: Colors.grey[600],
              type:  BottomNavigationBarType.shifting,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.location_on_outlined),
                  label: 'Location',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.fire_hydrant_alt_outlined),
                  label: 'Hot',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notification_important_outlined),
                  label: 'Notifications',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_bubble_outline),
                  label: 'Chats',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
