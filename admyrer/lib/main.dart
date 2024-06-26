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
// import 'package:pusher_client/pusher_client.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({super.key});

  late PusherChannelsFlutter pusher;
  late String channelName;
  late String eventName;

  Future<void> initPusher() async {
    pusher = PusherChannelsFlutter.getInstance();
    
    pusher.init(
      apiKey: '61cbedc7014185332c2d',
      cluster: 'mt1',
      onSubscriptionError: (String channel, dynamic e) {
        print("Subscription Error: ${e.message}");
      },
      onEvent: (PusherEvent event) {
        print("onEvent: $event");
      }
    );
    
    await pusher.subscribe(channelName: "app_event");


    
    // pusher.bind(channelName, eventName = 'my-event', (PusherEvent event) {
    //   print("Event: ${event.data}");
    // });

    await pusher.connect();
  }
  
  void _pusher() async{



    // PusherOptions options = PusherOptions(
    //   cluster: "mt1",
    //   encrypted: true,
    // );

    // pusher = PusherClient(
    //   "61cbedc7014185332c2d",
    //   options,
    //   autoConnect: true,
    // );

    // pusher.connect();
    // channel = pusher.subscribe("app_event");

    // channel.bind("app_event", (PusherEvent? event) {
    //   print("from main");
    // });
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
