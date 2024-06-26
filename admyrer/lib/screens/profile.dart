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
import 'package:admyrer/screens/quiz.dart';
import 'package:admyrer/screens/login.dart';
import 'package:admyrer/screens/polls.dart';
import 'package:admyrer/screens/Likes.dart';
import 'package:admyrer/screens/disliked.dart';
import 'package:admyrer/screens/visits.dart';
import 'package:admyrer/screens/follows.dart';
import 'package:admyrer/screens/edit_profile.dart';
import 'package:admyrer/screens/live.dart';
import 'package:admyrer/screens/liked.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:admyrer/widget/bottom_open.dart';
import 'package:admyrer/widget/custom_sheet.dart';
import 'package:admyrer/screens/search_page.dart';
import 'package:admyrer/screens/web_date.dart';
import 'package:admyrer/screens/club.dart';
import 'package:admyrer/screens/speed_date.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ApiService _apiService = ApiService();
  UserModel user = UserModel(id: 0, firstName: "Guest", lastName: "Guest", username: "Guest", avatar: "null", email: "null");
  bool isLoading = true;
  late String _authToken;
  List<UserModel>  visits = [];
  List<UserModel>  likes = [];
  List<UserModel>  follows = [];

  void goLive(username, avatar) {
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => StartVid(username: username , avatar: avatar,)));
  }

  
  void goSpeed() {
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => SpeedDate(username: user.username , avatar: user.avatar,)));
  }
  
  void goWeb() {
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => WebDates(username: user.username , avatar: user.avatar,)));
  }

  void goClub() {
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => Club(username: user.username , avatar: user.avatar,)));
  }
    
  Future<void> getFollows() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _authToken = prefs.getString('authToken') ?? '';
    });
    
    try {
      final response = await _apiService.postRequest("get-follows", {
        "id": _authToken,
      });

      var data = json.decode(response.body);

      if (data["data"] == null || data["data"] == null) {
        showErrorToast('Invalid response data');
        return;
      }

      List<dynamic> userList = data["data"];
      List<UserModel> follows =
          userList.map((user) => UserModel.fromJson(user)).toList();

      setState(() {
        this.follows = follows;
      });

    } catch (e) {
      showErrorToast('An error occurred: $e');
      print(e);
    }
  }

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
      final response = await _apiService.postRequest("single-user", {
        "id": _authToken,
      });

      var data = json.decode(response.body);
      var userList = data["data"]["user"];
      UserModel user = UserModel.fromJson(userList);
      List<dynamic> visitList = data["data"]["visits"]["original"]["data"];
      List<UserModel> visits =
          visitList.map((user) => UserModel.fromJson(user)).toList();
      
      List<dynamic> likeList = data["data"]["likes"]["original"]["data"];
      List<UserModel> likes =
          likeList.map((user) => UserModel.fromJson(user)).toList();

      setState(() {
        this.user = user;
        this.likes = likes;
        this.visits = visits;
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
    super.initState();
    getUsers();
    getFollows();
  }

  void goEdit() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditProfile(user: user)));
  }

  void goPolls() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Polls()));
  }

  void goQuiz() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Quiz()));
  }


  void goSearch(String search) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SearchPage(search: search)));
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My profile',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 20,
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
                      : Settings(user: user, visit: visits.length, likes: likes.length, goEdit: goEdit),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(child: MyGridList(user: user, goPolls: goPolls, goQuiz: goQuiz, follows: follows, goLive: goLive, goWeb: goWeb, goSpeed: goSpeed, goClub: goClub))
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
  final int visit;
  final int likes;
  final Function goEdit;
  const Settings({super.key, required this.user, required this.likes,  required this.visit, required this.goEdit});

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
    var likes = widget.likes;
    var visit = widget.visit;
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
            onTap:() =>  widget.goEdit(),
            child: Container(
              padding: const EdgeInsets.all(10),
              width: 130,
              decoration: BoxDecoration(
                  color: Color.fromARGB(23, 233, 30, 98),
                  borderRadius: BorderRadius.circular(5)),
              child: const Row(
                children: [
                  Icon(
                    Icons.edit_note_outlined,
                    color: Colors.pink,
                    size: 25,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Edit Profile",
                    style: TextStyle(color: Colors.pink),
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.heart,
                    color: Color.fromARGB(255, 63, 63, 63)
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "$likes Likes",
                  style: const TextStyle(
                      fontSize: 15, color: Color.fromARGB(255, 63, 63, 63)),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.remove_red_eye,
                    color: Color.fromARGB(255, 63, 63, 63)),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "$visit Visits",
                  style: const TextStyle(
                      fontSize: 15, color: Color.fromARGB(255, 63, 63, 63)),
                ),
              ],
            ),
            const Row(
              children: [
                Icon(
                  Icons.share,
                  color: Color.fromARGB(255, 63, 63, 63),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Share",
                  style: TextStyle(
                      fontSize: 15, color: Color.fromARGB(255, 63, 63, 63)),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}

class MyGridList extends StatefulWidget {
  final UserModel user;
  final List<UserModel> follows;
  final Function goPolls;
  final Function goQuiz;
  final Function goLive;
  final Function goSpeed;
  final Function goWeb;
  final Function goClub;
  const MyGridList(
    {super.key, 
    required this.user,
    required this.goQuiz, 
    required this.goPolls, 
    required this.follows,
    required this.goLive,
    required this.goSpeed,
    required this.goWeb,
    required this.goClub,
    }
    );

  @override
  State<MyGridList> createState() => _MyGridListState();
}

class _MyGridListState extends State<MyGridList> {
  void logOutUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
  }

  Future<void> _showLogoutConfirmationDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content:const  Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                logOutUser(); // Proceed with logout
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showNightCLub() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Night Club'),
          content:const  Text('Are you sure you want to start night club video call?'),
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
                Navigator.of(context).pop(); // Dismiss the dialog
                widget.goClub(); // Proceed with logout
              },
            ),
          ],
        );
      },
    );
  }

  void goVisists() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Visits()));
  }

  void goMyLikes() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Likes()));
  }

  void goDisLikes() {
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => DislLike()));
  }

  void goLiked() {
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => Liked()));
  }

  void goFollows() {
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => Follows()));
  }

  List<String> users = [
    'User 1',
    'User 2',
    'User 3',
    'User 4',
    'User 5',
  ];

  List<String> selectedUsers = [];

  String? selectedUserOne;

  void _showUserSelectionOnlyOne() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) {
        return SelectOne(
          users: widget.follows,
          initiallySelectedUser: selectedUserOne,
          goSpeed: widget.goSpeed
        );
      },
    );

    if (selected != null) {
      setState(() {
        selectedUserOne = selected;
      });
    }
  }


  void _showUserSelectionModal() async {
    final selected = await showDialog<List<String>>(
      context: context,
      builder: (context) {
        return WebDate(
          users: widget.follows,
          initiallySelectedUsers: selectedUsers,
          goWeb: widget.goWeb,
        );
      },
    );

    if (selected != null) {
      setState(() {
        selectedUsers = selected;
      });
    }
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
          onTap: () => widget.goLive(widget.user.username, widget.user.avatar),
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
                Text("Start Live")
              ],
            ),
          ),
        ),
        InkWell(
          onTap: goFollows,
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
                Text("Friends")
              ],
            ),
          ),
        ),
        InkWell(
          onTap: _showNightCLub,
          child: Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(
                color: Color.fromARGB(34, 176, 39, 44),
                borderRadius: BorderRadius.circular(10)),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.moon,
                  color: Colors.purple,
                  size: 25,
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Night Club")
              ],
            ),
          ),
        ),

        InkWell(
          onTap: _showUserSelectionOnlyOne,
          child: Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(
                color: Color.fromARGB(34, 39, 44, 176),
                borderRadius: BorderRadius.circular(10)),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.forwardFast,
                  color: Colors.purple,
                  size: 25,
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Speed Date")
              ],
            ),
          ),
        ),

        InkWell(
          onTap: _showUserSelectionModal,
          child: Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(
                color: Color.fromARGB(34, 110, 176, 39),
                borderRadius: BorderRadius.circular(10)),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.peopleGroup,
                  color: Colors.purple,
                  size: 25,
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Web Date")
              ],
            ),
          ),
        ),
        
        InkWell(
          onTap: () => goVisists(),
          child: Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(
                color: Color.fromARGB(34, 39, 142, 176),
                borderRadius: BorderRadius.circular(10)),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.eye,
                  color: Colors.purple,
                  size: 25,
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Visits")
              ],
            ),
          ),
        ),
        InkWell(
          onTap: _showLogoutConfirmationDialog,
          child: Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(
                color: Color.fromARGB(34, 176, 39, 39),
                borderRadius: BorderRadius.circular(10)),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 const FaIcon(
                  FontAwesomeIcons.rightFromBracket,
                  color: Colors.purple,
                  size: 25,
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Log Out")
              ],
            ),
          ),
        ),
        InkWell(
          onTap: goLiked,
          child: Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(
                color: Color.fromARGB(34, 39, 176, 73),
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
                Text("People i liked")
              ],
            ),
          ),
        ),
        InkWell(
          onTap: goDisLikes,
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
                Text("People i disliked")
              ],
            ),
          ),
        ),
        InkWell(
          onTap: goMyLikes,
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
                Text("Likes")
              ],
            ),
          ),
        ),
          InkWell(
          onTap: () => widget.goQuiz(),
          child: Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(
                color: Color.fromARGB(33, 176, 39, 121),
                borderRadius: BorderRadius.circular(10)),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.circleQuestion,
                  color: Colors.purple,
                  size: 25,
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Quiz")
              ],
            ),
          ),
        ),
      
        InkWell(
          onTap: () => widget.goPolls(),
          child: Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(
                color: Color.fromARGB(33, 176, 117, 39),
                borderRadius: BorderRadius.circular(10)),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.squarePollVertical,
                  color: Colors.purple,
                  size: 25,
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Polls")
              ],
            ),
          ),
        ),
      
       ],
    );
  }
}


class WebDate extends StatefulWidget {
  final List<UserModel> users;
  final Function goWeb;
  final List<String> initiallySelectedUsers;

  WebDate({required this.users, required this.initiallySelectedUsers, required this.goWeb});

  @override
  _WebDateState createState() => _WebDateState();
}

class _WebDateState extends State<WebDate> {
  late List<String> _selectedUsers;

  @override
  void initState() {
    super.initState();
    _selectedUsers = List.from(widget.initiallySelectedUsers);
  }

  Future<void> _showWebDate() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Web Date'),
          content:const  Text('Starting web date with selected users?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Start', style: TextStyle(color: Colors.red)),
              onPressed: () {widget.goWeb(); Navigator.of(context).pop();},
            ),
          ],
        );
      },
    );
  }


  void _onUserSelected(bool selected, String user) {
    setState(() {
      if (selected) {
        _selectedUsers.add(user);
      } else {
        _selectedUsers.remove(user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:const  Text('Select Friends', style: TextStyle(fontSize: 15),),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.users.map((user) {
            return CheckboxListTile(
              activeColor: Colors.pink[400],
              value: _selectedUsers.contains(user.firstName),
              title: Text(user.firstName),
              onChanged: (bool? selected) {
                _onUserSelected(selected ?? false, user.firstName);
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_selectedUsers);
          _showWebDate();
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }
}

class SelectOne extends StatefulWidget {
  final List<UserModel> users;
  final Function goSpeed;
  final String? initiallySelectedUser;

  SelectOne({required this.users, this.initiallySelectedUser, required this.goSpeed});

  @override
  _SelectOneState createState() => _SelectOneState();
}

class _SelectOneState extends State<SelectOne> {
  String? _selectedUser;

  @override
  void initState() {
    super.initState();
    _selectedUser = widget.initiallySelectedUser;
  }

  void _onUserSelected(String? user) {
    setState(() {
      _selectedUser = user;
    });
  }

  Future<void> _showSpeedDate() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Speed Date'),
          content:const  Text('Starting Speed date with selected user?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Start', style: TextStyle(color: Colors.red)),
              onPressed: () {widget.goSpeed();  Navigator.of(context).pop();},
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select only one user', style: TextStyle(fontSize: 15),),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.users.map((user) {
            return RadioListTile<String>(
              activeColor:Colors.pink[400],
              value: user.firstName,
              groupValue: _selectedUser,
              title: Text(user.firstName),
              onChanged: (String? selected) {
                _onUserSelected(selected);
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_selectedUser);
            _showSpeedDate();
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }
}
