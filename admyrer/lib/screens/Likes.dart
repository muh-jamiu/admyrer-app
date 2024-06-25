import 'package:admyrer/widget/backgrounds.dart';
import 'package:admyrer/widget/gradient_button.dart';
import 'package:admyrer/widget/bootstrap_textfield.dart';
import 'package:admyrer/widget/google_login.dart';
import 'package:admyrer/widget/facebook.dart';
import 'package:admyrer/widget/image_my_placeholder.dart';
import 'package:admyrer/models/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:admyrer/services/api_service.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:admyrer/screens/single.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import "package:Admyrer/widget/background.dart";

class Likes extends StatefulWidget {
  const Likes({super.key});

  @override
  State<Likes> createState() => _LikesState();
}

class _LikesState extends State<Likes> {
  final ApiService _apiService = ApiService();
  List<UserModel> users = [];
  bool isLoading = true;
  late String _authToken;

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

  Future<void> getUsers() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _authToken = prefs.getString('authToken') ?? '';
    });
    try {
      final response = await _apiService.postRequest("my-likes", {
        "id": _authToken,
      });

      var data = json.decode(response.body);

      if (data["data"] == null || data["data"] == null) {
        showErrorToast('Invalid response data');
        return;
      }

      List<dynamic> userList = data["data"];
      List<UserModel> users =
          userList.map((user) => UserModel.fromJson(user)).toList();

      setState(() {
        this.users = users;
        isLoading = false;
      });

    } catch (e) {
      showErrorToast('An error occurred: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
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
                          const Text(
                            'Likes',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  isLoading
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 100),
                              CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.pink),
                                strokeWidth: 3.0,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Loading, please wait...',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        )
                      :
                  Container(
                      height: 700,
                      child: 
                    users.length == 0 ? 
                    const Center(child: Column(
                      children: [
                        SizedBox(height: 80,),
                        Text("Empty", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                        Text("You don't have any likes at the moment"),
                      ],
                    ),)
                    : ListUser(
                        users: users,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ListUser extends StatefulWidget {
  final List<UserModel> users;
  const ListUser({super.key, required this.users});

  @override
  State<ListUser> createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  void goSingle(user) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Single(users: user)));
  }
  
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      childAspectRatio: 3 / 3,
      mainAxisSpacing: 15,
      children: 
        List.generate(widget.users.length, (index){
          return  InkWell(
          onTap: () => goSingle(widget.users[index]),
            child: ImageWithTextAndIcon(
                name: widget.users[index].firstName,
                image: widget.users[index].avatar,
                icon: Icons.heart_broken),
          );
        })
    );
  }
}

class ImageWithTextAndIcon extends StatefulWidget {
  final String name;
  final String image;
  final IconData icon;
  const ImageWithTextAndIcon(
      {super.key, required this.name, required this.icon, required this.image});
  @override
  State<ImageWithTextAndIcon> createState() => _ImageWithTextAndIconState();
}

class _ImageWithTextAndIconState extends State<ImageWithTextAndIcon> {
  @override
  Widget build(BuildContext context) {
    var name = widget.name;
    var image = widget.image;
    var icon = widget.icon;
    return Container(
      width: 100,
      height: 250,
      child: Stack(
        children: [
          // Image with rounded corners
          ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage.assetNetwork(
                  placeholder: "assets/images/no_profile_image.webp",
                  image: image,
                  height: 250,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  imageErrorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return Image.asset(
                      'assets/images/no_profile_image.webp',
                      height: 250,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  })),
          // Positioned icon at the top
          Positioned(
            top: 10,
            right: 10,
            child:FaIcon(
                            FontAwesomeIcons.heart,
                            color: Colors.white,
                            size: 30,
                          ),
          ),
          // Positioned text at the bottom
          Positioned(
            bottom: 20,
            left: 10,
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w100,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
