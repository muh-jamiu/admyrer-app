import 'package:admyrer/widget/backgrounds.dart';
import 'package:admyrer/widget/gradient_button.dart';
import 'package:admyrer/widget/bootstrap_textfield.dart';
import 'package:admyrer/widget/google_login.dart';
import 'package:admyrer/widget/facebook.dart';
import 'package:admyrer/widget/image_my_placeholder.dart';
import 'package:admyrer/models/user.dart';
import 'package:admyrer/models/quiz.dart';
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
      fontSize: 15.0,
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
                              onTap: () => {Navigator.pop(context)},
                              child: Icon(Icons.arrow_back, size: 25)),
                          const SizedBox(width: 15),
                          const Text(
                            'Quiz',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ],
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
                      : Expanded(
                          child: QuizScreen(),
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

class QuizScreen extends StatefulWidget {
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Question> questions = [
    Question(question: "What is your ideal date night?", answers: [
      "Romantic dinner and a movie",
      "Outdoor adventure and hiking",
      "Game night and drinks",
      "Live music and dancing"
    ]),
    Question(question: "What are your thoughts on commitment?", answers: [
      "I'm looking for a long-term partner",
      "I'm open to commitment, but not rushed",
      "I prefer casual relationships",
      "I'm not sure yet"
    ]),
    Question(question: "What is your love language?", answers: [
      "Words of affirmation",
      "Quality time",
      "Receiving gifts",
      "Physical touch"
    ]),
    Question(
        question: "What are your deal-breakers in a relationship?",
        answers: [
          "Dishonesty and lack of trust",
          "Disrespect and poor communication",
          "Infidelity and betrayal",
          "All of the above"
        ]),
    Question(question: "What is your idea of a perfect partner?", answers: [
      "Someone who is supportive and encouraging",
      "Someone who is funny and adventurous",
      "Someone who is intelligent and ambitious",
      "Someone who is loyal and dependable"
    ]),
    Question(
        question: "How important is communication in a relationship to you?",
        answers: [
          "Very important - we should talk every day",
          "Somewhat important - we should communicate regularly",
          "Not very important - we can figure it out as we go",
          "Not at all important - actions speak louder than words"
        ]),
    Question(question: "What is your take on trust and loyalty?", answers: [
      "Trust is earned, and loyalty is a must",
      "Trust is assumed, and loyalty is expected",
      "Trust is built over time, and loyalty is a choice",
      "Trust and loyalty are not essential"
    ]),
    Question(question: "How do you handle conflicts?", answers: [
      "I address them head-on and openly",
      "I try to compromise and find a middle ground",
      "I avoid them and hope they resolve themselves",
      "I become defensive and emotional"
    ]),
    Question(
        question: "What are your thoughts on independence and interdependence?",
        answers: [
          "I value independence and personal space",
          "I believe in interdependence and teamwork",
          "I think a balance between both is ideal",
          "I'm not sure yet"
        ]),
    Question(
        question: "What is your idea of a healthy work-life balance?",
        answers: [
          "Prioritizing work and providing for loved ones",
          "Balancing work and personal life equally",
          "Prioritizing personal life and happiness",
          "I'm still figuring it out"
        ]),
    Question(question: "What are your hobbies and interests?", answers: [
      "Outdoor activities and sports",
      "Creative pursuits and art",
      "Reading and learning",
      "Music and dancing"
    ]),
    Question(question: "What kind of music do you enjoy?", answers: [
      "Pop and rock",
      "Hip-hop and R&B",
      "Classical and jazz",
      "Country and folk"
    ]),
    Question(question: "What is your favorite travel destination?", answers: [
      "Beaches and tropical islands",
      "Cities and cultural hubs",
      "National parks and outdoor adventures",
      "Historical landmarks and museums"
    ]),
    Question(
        question: "What is your idea of a perfect weekend getaway?",
        answers: [
          "Relaxing at a spa or spa resort",
          "Exploring a new city or town",
          "Hiking or camping in nature",
          "Attending a music festival or concert"
        ]),
    Question(
        question: "What are your thoughts on finances and budgeting?",
        answers: [
          "I prioritize saving and investing",
          "I believe in living within my means",
          "I'm working on improving my financial literacy",
          "I'm not sure yet"
        ]),
    Question(
        question: "What is your idea of a perfect romantic evening?",
        answers: [
          "Candlelit dinner and wine",
          "Sunset picnic and stroll",
          "Cooking dinner together at home",
          "Surprise weekend getaway"
        ]),
    Question(question: "How important is family to you?", answers: [
      "Very important - family comes first",
      "Somewhat important - family is a priority",
      "Not very important - I prioritize personal goals",
      "Not at all important - I'm focused on my own life"
    ]),
    Question(
        question: "What are your thoughts on children and parenthood?",
        answers: [
          "I want kids someday",
          "I'm open to having kids, but not sure yet",
          "I don't want kids",
          "I'm not sure yet"
        ]),
    Question(
        question:
            "What is your idea of a perfect partner's personality traits?",
        answers: [
          "Kind, supportive, and encouraging",
          "Funny, adventurous, and spontaneous",
          "Intelligent, ambitious, and driven",
          "Loyal, dependable, and honest"
        ]),
    Question(
        question:
            "How do you prioritize emotional intelligence and empathy in a relationship?",
        answers: [
          "Very important - we should prioritize emotional support",
          "Somewhat important - we should be understanding and supportive",
          "Not very important - we can figure it out as we go",
          "Not at all important - actions speak louder than words"
        ])
  ];

  var index = 0;
  void nextQuiz() {
   if(index != 20){
     setState((){
      isClick = false;
      index += 1;
      showIndex += 1;
    });    
   }
  }

  void prevQuiz() {
    if(index != 0){
      setState((){
        index -= 1;
        showIndex -= 1;
      });   
    }
    
  }
  var showIndex = 0;
  void initState(){
     setState((){
         showIndex = index + 1;
      });   
  }

  bool isClick = false;


  void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: Color.fromARGB(255, 101, 250, 205),
      textColor: Colors.white,
      fontSize: 15.0
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PollWidget(
          pollTitle: questions[index].question,
          options: questions[index].answers,
          isClick: isClick
        ),
        const SizedBox(height: 20),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: prevQuiz,
                  label: const Text("Prev"),
                  icon: const Icon(Icons.arrow_back),
                ),
                index == 19
                    ? ElevatedButton.icon(
                        onPressed: (){
                          showErrorToast("Your quiz response has been saved");
                          Navigator.pop(context);
                        },
                        label: const Text("Save Quiz",  style: TextStyle(color: Colors.purple)),
                        icon: const Icon(Icons.check, color: Colors.purple),
                      )
                    :
                     ElevatedButton.icon(
                        onPressed: nextQuiz,
                        label: const Text("Next",  style: TextStyle(color: Colors.purple,)),
                        icon: const Icon(Icons.arrow_forward, color: Colors.purple),
                      )
              ],
            ),
          
            const SizedBox(height: 30),
            Center(child: Text("$showIndex out of 20", style: TextStyle(color: Colors.purple, fontSize: 15),))
          ],
        ),
      ],
    );
  }
}

class PollWidget extends StatefulWidget {
  final String pollTitle;
  bool isClick;
  final List<String> options;

  PollWidget({required this.pollTitle, required this.options, required this.isClick});

  @override
  _PollWidgetState createState() => _PollWidgetState();
}

class _PollWidgetState extends State<PollWidget> {
  int? _selectedOptionIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.pink[400],
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.pollTitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ...List.generate(widget.options.length, (index) {
              return ListTile(
                title: Text(widget.options[index]),
                leading: Radio<int>(
                  activeColor: Colors.white,
                  value: index,
                  groupValue: _selectedOptionIndex,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedOptionIndex = value;
                      widget.isClick = true;
                      print(widget.isClick);
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
