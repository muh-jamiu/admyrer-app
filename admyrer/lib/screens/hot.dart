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
// import "package:Admyrer/widget/background.dart";

class Hot extends StatefulWidget {
  Hot({Key? key}) : super(key: key);

  @override
  State<Hot> createState() => _HotState();
}

class _HotState extends State<Hot> {
  final ApiService _apiService = ApiService();
  List<UserModel> users = [];
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

  Future<void> getUsers() async {
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
      List<UserModel> users =
          userList.map((user) => UserModel.fromJson(user)).toList();

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
    getUsers();
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
                    height: 1,
                  ),
                  isLoading
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 120),
                              CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.pink),
                                strokeWidth: 6.0,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Loading, please wait...',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: ListView(
                            children: [
                              Users(
                                users: users,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              FirstSection(
                                users: users,
                              ),
                              const SizedBox(
                                height: 35,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Popular Matches",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600)),
                                  Text(
                                    "See All",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.purple[300]),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                  height: 400,
                                  child: AllUSers(
                                    users: users,
                                  )),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Other Users",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600)),
                                  Text(
                                    "See All",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.purple[300]),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                  height: 500,
                                  child: AllUSers(
                                    users: users,
                                  ))
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
  final List<UserModel> users;
  const Users({super.key, required this.users});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Wrap(
            children: widget.users.map((user) {
              return Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color.fromARGB(255, 207, 37, 212),
                                width: 2.0)),
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: FadeInImage.assetNetwork(
                                  placeholder:
                                      "assets/images/no_profile_image.webp",
                                  image: user.avatar,
                                  height: 55,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  imageErrorBuilder: (BuildContext context,
                                      Object error, StackTrace? stackTrace) {
                                    return Image.asset(
                                      'assets/images/no_profile_image.webp',
                                      height: 55,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        user.username,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w100,
                            color: Color.fromARGB(255, 40, 40, 40)),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class FirstSection extends StatefulWidget {
  final List<UserModel> users;
  const FirstSection({super.key, required this.users});

  @override
  State<FirstSection> createState() => _FirstSectionState();
}

class _FirstSectionState extends State<FirstSection> {
  var index = 0;
  void nextUser() {
    setState(() {
      index += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    var firstName = widget.users[index].firstName;
    var lastName = widget.users[index].lastName;
    var country = widget.users[index].country;
    var state = widget.users[index].state ?? "N/A";
    var avatar = widget.users[index].avatar;
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
                  child: FadeInImage.assetNetwork(
                      placeholder: "assets/images/no_profile_image.webp",
                      image: avatar,
                      height: 200,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      imageErrorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return Image.asset(
                          'assets/images/no_profile_image.webp',
                          height: 200,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      })),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Text(
                  '$firstName $lastName',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
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
                    Text(
                      '$state, $country',
                      style: const TextStyle(fontSize: 20),
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
                      onTap: nextUser,
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
                      onTap: nextUser,
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
  final List<UserModel> users;
  const AllUSers({super.key, required this.users});

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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: MyImageWidget(image: widget.users[0].avatar),
          ),
        ),
        InkWell(
          onTap: () => {},
          child: Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: MyImageWidget(image: widget.users[1].avatar),
          ),
        ),
        InkWell(
          onTap: () => {},
          child: Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: MyImageWidget(image: widget.users[2].avatar),
          ),
        ),
        InkWell(
          onTap: () => {},
          child: Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: MyImageWidget(image: widget.users[3].avatar),
          ),
        ),
      ],
    );
  }
}
