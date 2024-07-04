import 'package:admyrer/widget/backgrounds.dart';
import 'package:flutter/material.dart';
import 'package:admyrer/services/api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Update extends StatefulWidget {
  const Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  final ApiService _apiService = ApiService();
  late Future<dynamic> data;
  final TextEditingController _state = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  late String _authToken;

  void showErrorToast(String message, Color color) {
    Fluttertoast.showToast(
      msg: "$message",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 5,
      textColor: Colors.white,
      backgroundColor: Colors.pink[300],
      fontSize: 15.0,
    );
  }

  void _update_() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _authToken = prefs.getString('authToken') ?? '';
    });
    if (true) {
      setState(() {
        isLoading = true;
      });

      final user = await _apiService.postRequest("update-user", {
        "state": _state.text,
        "city": _city.text,
        "gender": _selectedGender,
        "relationship": _slsectedRelation,
        "country": _selectedCountry,
        "work_status": _selectedEmploy,
        "height": _selectheight,
        "id": _authToken ?? "0",
      });

      if (user.statusCode != 200) {
        showErrorToast("Something went wrong, Please try again",
            const Color.fromARGB(255, 238, 71, 126));
        setState(() {
          isLoading = false;
        });
        return;
      } else {
        showErrorToast("Account updated successfully",
            const Color.fromARGB(255, 100, 246, 190));
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, "/tab");
        });
      }
    }
  }

  String? _selectedCountry;
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

  String? _slsectedRelation;
  final List<String> _relationship = [
    "Single",
    "Married",
    "Divorce",
    "Prefer not to say"
  ];

  String? _selectedGender;
  final List<String> _gender = [
    "Male",
    "Female",
    "Transgender",
    "Prefer not to say"
  ];

  String? _selectedEmploy;
  final List<String> _employ = [
    "Employed",
    "Self-Employ",
    "Student",
    "Prefer not to say",
    "Not Employ"
  ];

  String? _selectheight;
  final List<String> _height = [
    "70m- 100 cm",
    "100 - 120 cm",
    "120 - 150 cm",
    "150 - 180 cm",
    "180 - 200 cm",
    "200 - 220 cm"
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
              child: ListView(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Center(
                      child: Text(
                    "Complete your profile",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )),
                  const SizedBox(
                    height: 50,
                  ),
                  DropdownButton<String>(
                    hint: const Text('Select a country'),
                    value: _selectedCountry,
                    icon: null,
                    iconSize: 0,
                    elevation: 16,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCountry = newValue;
                      });
                    },
                    items: _countries
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButton<String>(
                    hint: const Text('Select gender'),
                    value: _selectedGender,
                    icon: null,
                    iconSize: 0,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    },
                    items:
                        _gender.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButton<String>(
                    hint: const Text('Relationship Status'),
                    value: _slsectedRelation,
                    icon: null,
                    iconSize: 0,
                    onChanged: (String? newValue) {
                      setState(() {
                        _slsectedRelation = newValue;
                      });
                    },
                    items: _relationship
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButton<String>(
                    hint: const Text('Employment'),
                    value: _selectedEmploy,
                    icon: null,
                    iconSize: 0,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedEmploy = newValue;
                      });
                    },
                    items:
                        _employ.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButton<String>(
                    hint: const Text('Height'),
                    value: _selectheight,
                    icon: null,
                    iconSize: 0,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectheight = newValue;
                      });
                    },
                    items:
                        _height.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _state,
                    decoration: const InputDecoration(
                      labelText: 'State',
                      // border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _city,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      // border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  isLoading
                      ? SpinKitThreeBounce(
                          color: Colors.pink[400],
                          size: 25.0,
                        )
                      : TextButton(
                          onPressed: _update_,
                          child: const Text(
                            "Continue",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
