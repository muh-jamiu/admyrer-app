import 'package:admyrer/widget/backgrounds.dart';
import 'package:admyrer/widget/gradient_button.dart';
import 'package:admyrer/widget/bootstrap_textfield.dart';
import 'package:admyrer/widget/google_login.dart';
import 'package:admyrer/widget/facebook.dart';
import 'package:admyrer/widget/image_my_placeholder.dart';
import 'package:admyrer/models/user.dart';
import 'package:admyrer/models/polls_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:admyrer/services/api_service.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:admyrer/screens/single.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import "package:Admyrer/widget/background.dart";

class Polls extends StatefulWidget {
  const Polls({super.key});

  @override
  State<Polls> createState() => _PollsState();
}

class _PollsState extends State<Polls> {
  final ApiService _apiService = ApiService();
  List<UserModel> users = [];
  List<PollsModel> polls = [];
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
      final response = await _apiService.getRequest("get-polls");
      
      var data = json.decode(response.body);

      if (data["data"] == null || data["data"] == null) {
        showErrorToast('Invalid response data');
        return;
      }
      
      List<dynamic> pollList = data["data"];
      List<PollsModel> polls =
          pollList.map((user) => PollsModel.fromJson(user)).toList();

      setState(() {
        this.polls = polls;
        isLoading = false;
      });

    } catch (e) {
      // showErrorToast('An error occurred: $e');
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
                            'Polls',
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
                                'Loading Polls, please wait...',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        )
                      :
                  Container(
                    child: polls.isEmpty ? const Column(children: [
                      SizedBox(height: 60),
                      Center(child: Text("Empty", style: TextStyle(fontSize: 30),),),
                      Center(child: Text("There are no polls available at the moment", style: TextStyle(fontSize: 30),),)
                    ],) :
                    Expanded(child: PollScreen(polls: polls),),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}



class PollScreen extends StatefulWidget {
  final List<PollsModel> polls;
  const PollScreen({super.key, required this.polls});
  @override
  State<PollScreen> createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  @override
  Widget build(BuildContext context) {
      var polls = widget.polls;
      List<String> test = [];
     return ListView.builder(
      itemCount: polls.length,
      itemBuilder: (context, index) {   
        return PollWidget(
            pollTitle: polls[index].title,
            options: polls[index].options.split(RegExp(r'[, \n]')),
        );
      },
    );
  }
}

class PollWidget extends StatefulWidget {
  final String pollTitle;
  final List<String> options;

  PollWidget({required this.pollTitle, required this.options});

  @override
  _PollWidgetState createState() => _PollWidgetState();
}

class _PollWidgetState extends State<PollWidget> {
  int? _selectedOptionIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple[400],
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10,),
            Text(
              widget.pollTitle + " ?",
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            ...List.generate(widget.options.length, (index) {
              return ListTile(
                title: Text(widget.options[index], style: const TextStyle(color:Colors.white),),
                leading: Radio<int>(
                  activeColor: Colors.pink[400],
                  value: index,
                  groupValue: _selectedOptionIndex,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedOptionIndex = value;
                    });
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
