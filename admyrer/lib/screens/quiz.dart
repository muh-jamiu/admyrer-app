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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import "package:Admyrer/widget/background.dart";

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
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
      fontSize: 20.0,
    );
  }

  Future<void> getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _authToken = prefs.getString('authToken') ?? '';
    });

    try {
      final response = await _apiService.postRequest("get-visit", {
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
                            'Quiz',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),],
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
                                'Loading Quiz, please wait...',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        )
                      :
                  Container()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
