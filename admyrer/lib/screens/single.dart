import 'package:admyrer/widget/backgrounds.dart';
import 'package:admyrer/widget/gradient_button.dart';
import 'package:admyrer/widget/bootstrap_textfield.dart';
import 'package:admyrer/widget/google_login.dart';
import 'package:admyrer/widget/facebook.dart';
import 'package:flutter/material.dart';
import 'package:admyrer/services/api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:admyrer/models/user.dart';
import 'package:admyrer/screens/message.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Single extends StatefulWidget {
  final UserModel users;
  const Single({super.key, required this.users});

  @override
  State<Single> createState() => _SingleState();
}

class _SingleState extends State<Single> {
  final ApiService _apiService = ApiService();
  late UserModel user = widget.users;
  bool isLoading = true;

  void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP_RIGHT,
      timeInSecForIosWeb: 5,
      textColor: Colors.white,
      backgroundColor: Colors.pink[300],
      fontSize: 15.0,
    );
  }

 void goMessage(user) {
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => Message(user: user)));
  }

  @override
  Widget build(BuildContext context) {
      @override
      void initState() {
        super.initState();
        setState(() {
          user = widget.users;
        });
      }

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
                      Row(
                        children: [
                          InkWell(
                            onTap: () => {
                               Navigator.pop(context)
                            },
                            child: Icon(Icons.arrow_back, size: 25)
                            ),
                            const SizedBox(width: 15),
                          Text(
                            user.firstName,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 20,
                  ), Settings(user: user, goMessage: goMessage),
                  const SizedBox(
                    height: 10,
                  ),
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
  final UserModel user;
  final void Function(UserModel)  goMessage;
  const Settings({super.key, required this.user, required this.goMessage});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    var firstName = widget.user.firstName;
    var lastName = widget.user.lastName;
    var country = widget.user.country;
    var state = widget.user.state ?? "N/A";
    var avatar = widget.user.avatar;
    return Column(
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: const Color.fromARGB(255, 207, 37, 212),
                    width: 2.0)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                height: 115,
                width: 115,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: FadeInImage.assetNetwork(
                      placeholder: "assets/images/no_profile_image.webp",
                      image: avatar,
                      height: 115,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      imageErrorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return Image.asset(
                          'assets/images/no_profile_image.webp',
                          height: 115,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      }),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
            child: Text(
          '$firstName $lastName',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
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
            Text(
              '$state, $country',
              style: const TextStyle(
                  fontSize: 15, color: Color.fromARGB(255, 63, 63, 63)),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: InkWell(
            onTap:  () => widget.goMessage(widget.user),
            child: Container(
              padding: const EdgeInsets.all(10),
              width: 190,
              decoration: BoxDecoration(
                  color: Color.fromARGB(23, 233, 30, 98),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                children: [
                  const Icon(
                    Icons.edit_note_outlined,
                    color: Colors.pink,
                    size: 25,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () => widget.goMessage(widget.user),
                    child: Text(
                      "Chat with $firstName",
                      style: TextStyle(color: Colors.pink),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
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
  void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP_RIGHT,
      timeInSecForIosWeb: 3,
      textColor: Colors.white,
      backgroundColor: Color.fromARGB(255, 98, 240, 176),
      fontSize: 15.0,
    );
  }

 Future<void> _showStartVC() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Video Call Confirmation'),
          content:const  Text('Are you sure you want to start video call with this user?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Start', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();// Proceed with logout
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      childAspectRatio: 3 / 3,
      mainAxisSpacing: 10,
      children: [
         InkWell(
          onTap: _showStartVC,
          child: Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(
                color: Color.fromARGB(35, 155, 39, 176),
                borderRadius: BorderRadius.circular(10)),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.video,
                  color: Colors.purple,
                  size: 25,
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Video Call")
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () => showErrorToast("You follow this user"),
          child: Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(
                color: Color.fromARGB(34, 103, 176, 39),
                borderRadius: BorderRadius.circular(10)),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.userGroup,
                  color: Colors.purple,
                  size: 25,
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Follow")
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () => showErrorToast("You dislike this user"),
          child: Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(
                color: Color.fromARGB(34, 176, 48, 39),
                borderRadius: BorderRadius.circular(10)),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.thumbsDown,
                  color: Colors.purple,
                  size: 25,
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Disliked")
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () => showErrorToast("You like this user"),
          child: Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(
                color: Color.fromARGB(34, 39, 41, 176),
                borderRadius: BorderRadius.circular(10)),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.thumbsUp,
                  color: Colors.purple,
                  size: 25,
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Like")
              ],
            ),
          ),
        ),
       ],
    );
  }
}
