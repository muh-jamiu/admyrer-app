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
import 'package:admyrer/screens/search_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:admyrer/widget/gradient_button.dart';
import 'package:admyrer/widget/normal_button.dart';

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

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 5,
      textColor: Colors.white,
      backgroundColor: Color.fromARGB(255, 98, 240, 176),
      fontSize: 15.0,
    );
  }

  Future<void> getUsers() async {
    if(users.length > 0){
        isLoading = false;
        return;
    }

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

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Initialize timezone
    tz.initializeTimeZones();
  }

  Future<void> getUsersByCountry(country) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await _apiService.postRequest("county-user", {
        "country": country,
      });

      var data = json.decode(response.body);

      if (data["data"] == null || data["data"] == null) {
        showErrorToast('Invalid response data');
        return;
      }

      List<dynamic> userList = data["data"];
      List<UserModel> users =
          userList.map((user) => UserModel.fromJson(user)).toList();

      if (users.length != 0) {
        setState(() {
          this.users = users;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showErrorToast('No matching user was found in $country');
      }
    } catch (e) {
      showErrorToast('An error occurred: $e');
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _scheduleNotification(DateTime dateTime) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your_channel_id', 'your_channel_name',
            channelDescription: 'your_channel_description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Hello!',
        'This is a notification for you.',
        tz.TZDateTime.from(dateTime, tz.local),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  String? _selectedCountry;
  bool isBoys = false;
  bool isGirls = false;
  bool isBoth = false;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _countries = [
    "Afghanistan",
    "Albania",
    "Algeria",
    "Andorra",
    "Angola",
    "Antigua and Barbuda",
    "Argentina",
    "Armenia",
    "Australia",
    "Austria",
    "Azerbaijan",
    "Bahamas",
    "Bahrain",
    "Bangladesh",
    "Barbados",
    "Belarus",
    "Belgium",
    "Belize",
    "Benin",
    "Bhutan",
    "Bolivia",
    "Bosnia and Herzegovina",
    "Botswana",
    "Brazil",
    "Brunei",
    "Bulgaria",
    "Burkina Faso",
    "Burundi",
    "Cabo Verde",
    "Cambodia",
    "Cameroon",
    "Canada",
    "Central African Republic",
    "Chad",
    "Chile",
    "China",
    "Colombia",
    "Comoros",
    "Congo, Democratic Republic of the",
    "Congo, Republic of the",
    "Costa Rica",
    "Croatia",
    "Cuba",
    "Cyprus",
    "Czech Republic",
    "Denmark",
    "Djibouti",
    "Dominica",
    "Dominican Republic",
    "East Timor (Timor-Leste)",
    "Ecuador",
    "Egypt",
    "El Salvador",
    "Equatorial Guinea",
    "Eritrea",
    "Estonia",
    "Eswatini (Swaziland)",
    "Ethiopia",
    "Fiji",
    "Finland",
    "France",
    "Gabon",
    "Gambia",
    "Georgia",
    "Germany",
    "Ghana",
    "Greece",
    "Grenada",
    "Guatemala",
    "Guinea",
    "Guinea-Bissau",
    "Guyana",
    "Haiti",
    "Honduras",
    "Hungary",
    "Iceland",
    "India",
    "Indonesia",
    "Iran",
    "Iraq",
    "Ireland",
    "Israel",
    "Italy",
    "Ivory Coast (Côte d'Ivoire)",
    "Jamaica",
    "Japan",
    "Jordan",
    "Kazakhstan",
    "Kenya",
    "Kiribati",
    "Korea, North",
    "Korea, South",
    "Kosovo",
    "Kuwait",
    "Kyrgyzstan",
    "Laos",
    "Latvia",
    "Lebanon",
    "Lesotho",
    "Liberia",
    "Libya",
    "Liechtenstein",
    "Lithuania",
    "Luxembourg",
    "Madagascar",
    "Malawi",
    "Malaysia",
    "Maldives",
    "Mali",
    "Malta",
    "Marshall Islands",
    "Mauritania",
    "Mauritius",
    "Mexico",
    "Micronesia",
    "Moldova",
    "Monaco",
    "Mongolia",
    "Montenegro",
    "Morocco",
    "Mozambique",
    "Myanmar (Burma)",
    "Namibia",
    "Nauru",
    "Nepal",
    "Netherlands",
    "New Zealand",
    "Nicaragua",
    "Niger",
    "Nigeria",
    "North Macedonia (Macedonia)",
    "Norway",
    "Oman",
    "Pakistan",
    "Palau",
    "Panama",
    "Papua New Guinea",
    "Paraguay",
    "Peru",
    "Philippines",
    "Poland",
    "Portugal",
    "Qatar",
    "Romania",
    "Russia",
    "Rwanda",
    "Saint Kitts and Nevis",
    "Saint Lucia",
    "Saint Vincent and the Grenadines",
    "Samoa",
    "San Marino",
    "Sao Tome and Principe",
    "Saudi Arabia",
    "Senegal",
    "Serbia",
    "Seychelles",
    "Sierra Leone",
    "Singapore",
    "Slovakia",
    "Slovenia",
    "Solomon Islands",
    "Somalia",
    "South Africa",
    "South Sudan",
    "Spain",
    "Sri Lanka",
    "Sudan",
    "Suriname",
    "Sweden",
    "Switzerland",
    "Syria",
    "Taiwan",
    "Tajikistan",
    "Tanzania",
    "Thailand",
    "Togo",
    "Tonga",
    "Trinidad and Tobago",
    "Tunisia",
    "Turkey",
    "Turkmenistan",
    "Tuvalu",
    "Uganda",
    "Ukraine",
    "United Arab Emirates",
    "United Kingdom",
    "United States",
    "Uruguay",
    "Uzbekistan",
    "Vanuatu",
    "Vatican City (Holy See)",
    "Venezuela",
    "Vietnam",
    "Yemen",
    "Zambia",
    "Zimbabwe"
  ];

  void goSearch(){    
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SearchPage(search: _searchController.text)));
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
                                  getUsersByCountry(_selectedCountry);
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
                            onTap: () {
                              showCustomBottomSheet(
                                context,
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const SizedBox(height: 20),
                                       TextField(
                                        controller: _searchController,
                                        decoration: const InputDecoration(
                                          labelText:
                                              'Search user by name, age, username, height etc.....',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      SwitchListTile(
                                        activeColor: Colors.pink[400],
                                        title: const Text('Boys'),
                                        value: !isBoys,
                                        onChanged: (bool value) {
                                          setState(() {
                                            isBoys = value;
                                          });
                                        },
                                      ),
                                      SwitchListTile(
                                        activeColor: Colors.pink[400],
                                        title: const Text('Girls'),
                                        value: isGirls,
                                        onChanged: (bool value) {
                                          setState(() {
                                            isGirls = value;
                                            isBoys = !value && !isBoth
                                                ? false
                                                : isBoys;
                                          });
                                        },
                                      ),
                                      SwitchListTile(
                                        title: const Text('Both'),
                                        activeColor: Colors.pink[400],
                                        value: isBoth,
                                        onChanged: (bool value) {
                                          setState(() {
                                            isBoth = value;
                                            if (value) {
                                              isBoys = true;
                                              isGirls = true;
                                            }
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      Column(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                        GradientButton(text: "Filter", onPressed: goSearch, isLoading: false),     
                                        const SizedBox(height: 20),                                    
                                        NormalButton(text: "Reset", onPressed:  () => {}),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Icon(Icons.more_vert_outlined,
                                color: Colors.pink[300]),
                          ),
                          const SizedBox(width: 15),
                          InkWell(
                              onTap: () {
                                DateTime scheduledTime =
                                    DateTime.now().add(Duration(seconds: 5));
                                _scheduleNotification(scheduledTime);
                              },
                              child: Icon(Icons.diamond_rounded,
                                  color: Colors.blue[300])),
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

  void goSingle(user) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Single(users: user)));
  }

  void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 5,
      textColor: Colors.white,
      backgroundColor: Color.fromARGB(255, 98, 240, 176),
      fontSize: 15.0,
    );
  }

  @override
  Widget build(BuildContext context) {
      void nextUser() {
    if(widget.users.length == index + 1){
       setState(() {
        index = 0;
      });
    }else{         
      setState(() {
        index += 1;
      });
    }

  }
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
