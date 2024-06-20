import 'package:admyrer/screens/chat.dart';
import 'package:admyrer/screens/hot.dart';
import 'package:admyrer/screens/locations.dart';
import 'package:admyrer/screens/notifications.dart';
import 'package:admyrer/screens/profile.dart';
import 'package:admyrer/models/user.dart';
import 'package:flutter/material.dart';
import 'package:admyrer/services/api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<UserModel>> futureUsers;
  List<UserModel> users = [];
  bool isLoading = true;
  late List<Widget> _pages; 

  void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP_RIGHT,
      timeInSecForIosWeb: 5,
      textColor: Colors.white,
      fontSize: 20.0,
    );
  }

  Future<void> _handleSignIn() async {
    setState((){
      isLoading = false;
    });

    try {
      final response = await _apiService.postRequest("buildPage", {
        "id": 10,
      });

      var data = json.decode(response.body);

      if (data["data"] == null || data["data"]["random"] == null) {
        showErrorToast('Invalid response data');
        return;
      }

      List<dynamic> userList = data["data"]["random"];
      List<UserModel> users = userList.map((user) => UserModel.fromJson(user)).toList();

      setState(() {
        this.users = users;
        isLoading = false;
      });

      print(users);
    } catch (e) {
      showErrorToast('An error occurred: $e');
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() { 
    super.initState();
    // _handleSignIn(); 

    _pages = [
    Locations(isLoading: isLoading,),
    Hot(),
    const Notifications(),
    const Chat(),
    const Profile(),
  ];
  }

  void home() {
    Navigator.pushNamed(context, "/home");
  }

  int _currentIndex = 0;
  

  final _pageController = PageController();
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 200),
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
        backgroundColor: Colors.pink[400],
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: _pages,
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
              )
            ]),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              selectedItemColor: Colors.pink[300],
              unselectedItemColor: Colors.grey[600],
              type: BottomNavigationBarType.shifting,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.location_on_outlined),
                  label: 'Location',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.fireplace_outlined),
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
