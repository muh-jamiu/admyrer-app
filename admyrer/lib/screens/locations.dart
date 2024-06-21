import 'package:admyrer/widget/backgrounds.dart';
import 'package:admyrer/widget/bottom_open.dart';
import 'package:flutter/material.dart';
import 'package:admyrer/services/api_service.dart';
import 'package:admyrer/services/hive_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:admyrer/models/user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:admyrer/screens/single.dart';

class Locations extends StatefulWidget {
  bool isLoading;

  Locations({Key? key, required this.isLoading}) : super(key: key);

  @override
  State<Locations> createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
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
    getUsers();
  }

  String? _selectedCountry;

  final List<String> _countries = [
    'United States',
    'Canada',
    'Mexico',
    'United Kingdom',
    'Germany',
    'France',
    'India',
    'China',
    'Japan',
    'Australia',
  ];

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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Locations',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined),
                              const SizedBox(
                                height: 10,
                              ),
                              DropdownButton<String>(
                                hint: const Text('Select a country'),
                                value: _selectedCountry,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedCountry = newValue;
                                  });
                                },
                                items: _countries.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {showCustomBottomSheet(context);},
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
                      : Expanded(child: User(users: users)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class User extends StatefulWidget {
  final List<UserModel> users;
  const User({super.key, required this.users});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
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

  @override
  Widget build(BuildContext context) {
    var firstName = widget.users[index].firstName;
    var lastName = widget.users[index].lastName;
    var country = widget.users[index].country;
    var state = widget.users[index].state ?? "N/A";
    var avatar = widget.users[index].avatar;
    return ListView(
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
                      height: 400,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      imageErrorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return Image.asset(
                          'assets/images/no_profile_image.webp',
                          height: 400,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      }),
                ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    InkWell(
                      onTap: nextUser,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(35, 155, 39, 176),
                            borderRadius: BorderRadius.circular(50)),
                        child: const Icon(
                          Icons.replay_outlined,
                          color: Colors.purple,
                          size: 25,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: nextUser,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.pink[300],
                            borderRadius: BorderRadius.circular(50)),
                        child: const Center(
                          child: FaIcon(
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
            ],
          ),
        )
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dropdown Menu Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _selectedCountry;

  final List<String> _countries = [
    'United States',
    'Canada',
    'Mexico',
    'United Kingdom',
    'Germany',
    'France',
    'India',
    'China',
    'Japan',
    'Australia',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dropdown Menu Example'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DropdownButton<String>(
                hint: Text('Select a country'),
                value: _selectedCountry,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCountry = newValue;
                  });
                },
                items: _countries.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Text(
                _selectedCountry != null
                    ? 'Selected country: $_selectedCountry'
                    : 'No country selected',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
