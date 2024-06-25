import 'package:admyrer/widget/backgrounds.dart';
import 'package:admyrer/widget/gradient_button.dart';
import 'package:admyrer/widget/bootstrap_textfield.dart';
import 'package:admyrer/widget/google_login.dart';
import 'package:admyrer/widget/facebook.dart';
import 'package:admyrer/widget/image_my_placeholder.dart';
import 'package:admyrer/models/user.dart';
import 'package:admyrer/models/live_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:admyrer/services/api_service.dart';
import 'dart:convert';
import 'package:admyrer/screens/allUsers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:admyrer/screens/single.dart';
import 'package:admyrer/widget/bottom_open.dart';
import 'package:admyrer/widget/custom_sheet.dart';
import 'package:admyrer/screens/search_page.dart';

// import "package:Admyrer/widget/background.dart";

class Hot extends StatefulWidget {
  Hot({Key? key}) : super(key: key);

  @override
  State<Hot> createState() => _HotState();
}

class _HotState extends State<Hot> {
  final ApiService _apiService = ApiService();
  List<UserModel> users = [];
  List<UserModel> allUser = [];
  List<Livemodel> lives = [];
  List<Livemodel> clubs = [];
  bool isLoading = true;

   Future<void> getClubs() async {
    try {
      final response = await _apiService.getRequest("club");

      var data = json.decode(response.body);

      if (data["data"] == null || data["data"]["random"] == null) {
        showErrorToast('Invalid response data');
        return;
      }

      List<dynamic> userList = data["data"]["random"];
      List<Livemodel> clubs =
          userList.map((user) => Livemodel.fromJson(user)).toList();

      setState(() {
        this.clubs = clubs;
      });
    } catch (e) {
      // showErrorToast('An error occurred: $e');
      print(e);
    }
  }


  Future<void> getLives() async {
    try {
      final response = await _apiService.getRequest("live");

      var data = json.decode(response.body);

      if (data["data"] == null || data["data"]["random"] == null) {
        showErrorToast('Invalid response data');
        return;
      }

      List<dynamic> userList = data["data"]["random"];
      List<Livemodel> lives =
          userList.map((user) => Livemodel.fromJson(user)).toList();

      setState(() {
        this.lives = lives;
      });
    } catch (e) {
      // showErrorToast('An error occurred: $e');
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

      List<dynamic> alluserList = data["data"]["all"];
      List<UserModel> allusers =
          alluserList.map((user) => UserModel.fromJson(user)).toList();

      setState(() {
        this.users = users;
        this.allUser = allusers;
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
    getLives();
  }

  void goAll() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AllUsers(users: users)));
  }

  void goAllUser() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AllUsers(users: allUser)));
  }

  void goSearch(String search) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => SearchPage(search: search)));
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
                          InkWell(
                            onTap: () {
                              showCustomBottomSheet(
                                context,
                                CustomSheet(goSearch: goSearch),
                              );
                            },
                            child: Icon(Icons.more_vert_outlined,
                                color: Colors.pink[300]),
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
                                  InkWell(
                                    onTap: goAll,
                                    child: Text(
                                      "See All",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.purple[300]),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                  height: 600,
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
                                  InkWell(
                                    onTap: goAllUser,
                                    child: Text(
                                      "See All",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.purple[300]),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                  height: 620,
                                  child: _AllUSersOneState(
                                    users: allUser,
                                  )),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Active Live Users",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600)),
                                  InkWell(
                                    onTap: () => {},
                                    child: Text(
                                      "See All",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.purple[300]),
                                    ),
                                  ),
                                ],
                              ),
                              lives.length == 0
                                  ? const Column(
                                      children: [
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Center(
                                          child: Text(
                                              "There are no live users at the moment"),
                                        )
                                      ],
                                    )
                                  : 
                              Container(
                                height: 280,
                                child: LiveUsers(users: lives),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Active Night Clubs",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600)),
                                  InkWell(
                                    onTap: () => {},
                                    child: Text(
                                      "See All",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.purple[300]),
                                    ),
                                  ),
                                ],
                              ),
                              
                              clubs.length == 0
                                  ? const Column(
                                      children: [
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Center(
                                          child: Text(
                                              "There are no active night clubs at the moment"),
                                        )
                                      ],
                                    )
                                  : Container(
                                      height: 300,
                                      child: ClubUsers(users: clubs),
                                    )
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
    void goSingle(user) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Single(users: user)));
    }

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
                      InkWell(
                        onTap: () => goSingle(user),
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 207, 37, 212),
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

  void goSingle(user) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Single(users: user)));
  }

  void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      textColor: Colors.white,
      backgroundColor: Color.fromARGB(255, 98, 240, 176),
      fontSize: 15.0,
    );
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
              InkWell(
                onTap: () => goSingle(widget.users[index]),
                child: ClipRRect(
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
              ),
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
                      onTap: () {
                        nextUser();
                        showErrorToast("You dislike this user");
                      },
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
                      onTap: () {
                        nextUser();
                        showErrorToast("You like this user");
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.pink[300],
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: const FaIcon(
                            FontAwesomeIcons.heart,
                            color: Colors.white,
                            size: 25,
                          ),
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
  void goSingle(user) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Single(users: user)));
  }

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
          onTap: () => goSingle(widget.users[0]),
          child: ImageWithTextAndIcon(
              name: widget.users[0].firstName,
              image: widget.users[0].avatar,
              icon: Icons.heart_broken),
        ),
        InkWell(
          onTap: () => goSingle(widget.users[1]),
          child: ImageWithTextAndIcon(
              name: widget.users[1].firstName,
              image: widget.users[1].avatar,
              icon: Icons.heart_broken),
        ),
        InkWell(
          onTap: () => goSingle(widget.users[2]),
          child: ImageWithTextAndIcon(
              name: widget.users[2].firstName,
              image: widget.users[2].avatar,
              icon: Icons.heart_broken),
        ),
        InkWell(
          onTap: () => goSingle(widget.users[3]),
          child: ImageWithTextAndIcon(
              name: widget.users[3].firstName,
              image: widget.users[3].avatar,
              icon: Icons.heart_broken),
        ),
        InkWell(
          onTap: () => goSingle(widget.users[4]),
          child: ImageWithTextAndIcon(
              name: widget.users[4].firstName,
              image: widget.users[4].avatar,
              icon: Icons.heart_broken),
        ),
        InkWell(
          onTap: () => goSingle(widget.users[5]),
          child: ImageWithTextAndIcon(
              name: widget.users[5].firstName,
              image: widget.users[5].avatar,
              icon: Icons.heart_broken),
        ),
      ],
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
            child: FaIcon(
              FontAwesomeIcons.heart,
              color: Colors.pink[300],
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

class _AllUSersOneState extends StatefulWidget {
  final List<UserModel> users;
  const _AllUSersOneState({super.key, required this.users});

  @override
  State<_AllUSersOneState> createState() => __AllUSersOneStateState();
}

class __AllUSersOneStateState extends State<_AllUSersOneState> {
  void goSingle(user) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Single(users: user)));
  }

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
          onTap: () => goSingle(widget.users[0]),
          child: ImageWithTextAndIcon(
              name: widget.users[0].firstName,
              image: widget.users[0].avatar,
              icon: Icons.heart_broken),
        ),
        InkWell(
          onTap: () => goSingle(widget.users[1]),
          child: ImageWithTextAndIcon(
              name: widget.users[1].firstName,
              image: widget.users[1].avatar,
              icon: Icons.heart_broken),
        ),
        InkWell(
          onTap: () => goSingle(widget.users[2]),
          child: ImageWithTextAndIcon(
              name: widget.users[2].firstName,
              image: widget.users[2].avatar,
              icon: Icons.heart_broken),
        ),
        InkWell(
          onTap: () => goSingle(widget.users[3]),
          child: ImageWithTextAndIcon(
              name: widget.users[3].firstName,
              image: widget.users[3].avatar,
              icon: Icons.heart_broken),
        ),
        InkWell(
          onTap: () => goSingle(widget.users[4]),
          child: ImageWithTextAndIcon(
              name: widget.users[4].firstName,
              image: widget.users[4].avatar,
              icon: Icons.heart_broken),
        ),
        InkWell(
          onTap: () => goSingle(widget.users[5]),
          child: ImageWithTextAndIcon(
              name: widget.users[5].firstName,
              image: widget.users[5].avatar,
              icon: Icons.heart_broken),
        ),
      ],
    );
  }
}

class LiveUsers extends StatefulWidget {
  final List<Livemodel> users;
  const LiveUsers({super.key, required this.users});

  @override
  State<LiveUsers> createState() => _LiveUsersState();
}

class _LiveUsersState extends State<LiveUsers> {
  void goSingle(user) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Single(users: user)));
  }

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
          onTap: () => goSingle(widget.users[0]),
          child: ImageWithTextAndIcon(
              name: widget.users[0].username ?? "",
              image: widget.users[0].avatar ?? "",
              icon: Icons.heart_broken),
        ),
        InkWell(
          onTap: () => goSingle(widget.users[1]),
          child: ImageWithTextAndIcon(
              name: widget.users[1].username ?? "",
              image: widget.users[1].avatar ?? "",
              icon: Icons.heart_broken),
        ),
      ],
    );
  }
}

class ClubUsers extends StatefulWidget {
  final List<Livemodel> users;
  const ClubUsers({super.key, required this.users});

  @override
  State<ClubUsers> createState() => _ClubUsersState();
}

class _ClubUsersState extends State<ClubUsers> {
  void goSingle(user) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Single(users: user)));
  }

  bool isShow = true;
  @override
  Widget build(BuildContext context) {
    return isShow
        ? const Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Center(
                child: Text("There are no live users at the moment"),
              )
            ],
          )
        : GridView.count(
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            childAspectRatio: 3 / 3,
            mainAxisSpacing: 15,
            children: [
              InkWell(
                onTap: () => goSingle(widget.users[0]),
                child: ImageWithTextAndIcon(
                    name: widget.users[0].username ?? "",
                    image: widget.users[0].avatar ?? "",
                    icon: Icons.heart_broken),
              ),
              InkWell(
                onTap: () => goSingle(widget.users[1]),
                child: ImageWithTextAndIcon(
                    name: widget.users[1].username ?? "",
                    image: widget.users[1].avatar ?? "",
                    icon: Icons.heart_broken),
              ),
            ],
          );
  }
}
