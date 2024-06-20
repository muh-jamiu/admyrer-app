import 'package:admyrer/widget/backgrounds.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:admyrer/services/api_service.dart';
import 'dart:convert';
import 'package:admyrer/models/user.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          // padding: const EdgeInsets.all(15.0),
          children: [
            const Backgrounds(),
            Padding(
              padding: EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: const Text(
                      'Chat List',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Users(users: users),
                  const Divider(
                    color: Color.fromARGB(255, 215, 215, 215),
                    thickness: 1.0,
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
                      : Expanded(child: ChatList(users: users))
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
      child: Row(children: [
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
                    const SizedBox(width: 20),
                  ],
                ),
              ],
            );
          }).toList(),
        ),
      ]),
    );
  }
}

class ChatList extends StatefulWidget {
  final List<UserModel> users;
  const ChatList({super.key, required this.users});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final items = List<String>.generate(25, (index) => 'Item $index');
  @override
  Widget build(BuildContext context) {
    var users = widget.users;
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Row(
            children: [
              Container(
                height: 45,
                width: 45,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: FadeInImage.assetNetwork(
                      placeholder: "assets/images/no_profile_image.webp",
                      image: users[index].avatar,
                      height: 45,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      imageErrorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return Image.asset(
                          'assets/images/no_profile_image.webp',
                          height: 45,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      }),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    users[index].firstName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.start,
                  ),
                  const Text(
                    "Last Message Notifications",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w100,
                        color: Color.fromARGB(255, 35, 35, 35)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
