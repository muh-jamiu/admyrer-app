import 'package:admyrer/models/recent_model.dart';
import 'package:admyrer/widget/backgrounds.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:admyrer/services/api_service.dart';
import 'dart:convert';
import 'package:admyrer/models/user.dart';
import 'package:admyrer/screens/message.dart';
import 'package:admyrer/screens/ai_chat.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final ApiService _apiService = ApiService();
  List<UserModel> users = [];
  bool isLoading = true;
  late String _authToken;
  late RecentModel _recent;

  void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
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
      final response = await _apiService.postRequest("get-follows", {
        "id": _authToken,
      });

      
      // final recent = await _apiService.postRequest("get-recent", {
      //   "sender": _authToken,
      // });

      var data = json.decode(response.body);
      // var recent_data = json.decode(recent.body);
      // print(recent_data);

      if (data["data"] == null || data["data"]== null) {
        showErrorToast('Invalid response data');
        return;
      }

      
      // var recent_list = recent_data["data"];
      // RecentModel _recent = RecentModel.fromJson(recent_list);
      // print(_recent);

      List<dynamic> userList = data["data"];
      List<UserModel> users =
          userList.map((user) => UserModel.fromJson(user)).toList();

      setState(() {
        // this._recent = _recent;
        this.users = users;
        isLoading = false;
      });

    } catch (e) {
      // showErrorToast('An error occurred: $e');
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

  void goMessage(user) {
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => Message(user: user)));
  }

  void goAi(user) {
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => AiChat()));
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
                    height: 40,
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
                  Users(users: users, goMessage: goMessage, goAi: goAi),
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
                                strokeWidth: 3.0,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Loading, please wait...',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      : Expanded(child: ChatList(users: users,  goMessage: goMessage))
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
  final void Function(UserModel)  goMessage;
  final void Function(String)  goAi;
  const Users({super.key, required this.users, required this.goMessage, required this.goAi});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      height: 10,
                      width:10,
                    ),
                    InkWell(
                      onTap:  () => widget.goAi("nothing"),
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Color.fromARGB(255, 5, 219, 76),
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
                                      "assets/images/ai.webp",
                                  image: "assets/images/ai.webp",
                                  height: 55,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  imageErrorBuilder: (BuildContext context,
                                      Object error, StackTrace? stackTrace) {
                                    return Image.asset(
                                      'assets/images/ai.webp',
                                      height: 55,
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
                      width: 20,
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  children: [
                    Text(
                      "Admyrer AI",
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 2, 2, 2)),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ],
            ),
        Wrap(
          children: widget.users.map((user) {
            return Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () => widget.goMessage(user),
                      child: Container(
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
  final void Function(UserModel)  goMessage;
  const ChatList({super.key, required this.users, required this.goMessage});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final items = List<String>.generate(25, (index) => 'Item $index');
  @override
  Widget build(BuildContext context) {
    var users = widget.users;
    return users.length == 0 ?
    
    const Column(children: [
      SizedBox(height: 40,),
      Center(child: Text("You don't have any friends"),)
    ],)
    :
    ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: InkWell(
            onTap: () => widget.goMessage(users[index]),
            child: Row(
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
                      "Last Message...",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w100,
                          color: Color.fromARGB(255, 35, 35, 35)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
