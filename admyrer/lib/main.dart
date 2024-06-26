import 'package:admyrer/screens/forgot.dart';
import 'package:admyrer/screens/login.dart';
import 'package:admyrer/screens/register.dart';
import 'package:admyrer/screens/tab_screen.dart';
import 'package:admyrer/screens/verify.dart';
import 'package:flutter/material.dart';
import './screens/onboarding_screen.dart';
import './screens/home.dart';
import './screens/step_Sceen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pusher_client/pusher_client.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({super.key});

  late PusherClient pusher;
  late Channel channel;
  
  void _pusher(){
    PusherOptions options = PusherOptions(
      cluster: "mt1",
      encrypted: true,
    );

    pusher = PusherClient(
      "61cbedc7014185332c2d",
      options,
      autoConnect: true,
    );

    pusher.connect();
    channel = pusher.subscribe("app_event");

    channel.bind("app_event", (PusherEvent? event) {
      print("from main");
    });
  }

  void initState() {
    _pusher();
  }
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  MyApp() {
    const InitializationSettings initializationSettings =   InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admyrer',
      initialRoute: '/',
       onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return _createRoute(const OnboardingScreen());
          case '/home':
            return _createRoute(const Home());
          case '/step':
            return _createRoute(const StepSceen());
          case '/login':
            return _createRoute(const Login());
          case '/register':
            return _createRoute(const Register());
          case '/forgot':
            return _createRoute(const Forgot());
          case '/verify':
            return _createRoute(const Verify());
          case '/tab':
            return _createRoute(const TabScreen());
          // Add more cases for additional pages
          default:
            return null;
        }
      },
    );
  }
}

Route _createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
      transitionDuration: const Duration(milliseconds: 300)
  );
}
