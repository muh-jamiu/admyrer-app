import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:admyrer/models/user.dart';
import 'package:admyrer/services/api_service.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AiChat extends StatefulWidget {
  const AiChat({super.key});
  @override
  _AiChatState createState() => _AiChatState();
}

class _AiChatState extends State<AiChat> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  bool isLoading = true;
  bool _isTyping = false;

  void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 5,
      textColor: Colors.white,
      backgroundColor: Colors.pink[300],
      fontSize: 20.0,
    );
  }


  Future<void> postMessage(String message) async {
     setState(() {
        _isTyping = true;
      });

    try {
      final response = await _apiService.postRequest("chat-ai", {
        "message":  message,
      });

      var data = json.decode(response.body);

      if (data["data"] == null || data["data"] == null) {
        showErrorToast('Invalid response data');
        return;
      }

      setState(() {
        _isTyping = false;
        _messages.add({
          'text': data["data"],
          'isMe': false,
        });
      });


    } catch (e) {
      showErrorToast('An error occurr, Please try again');
      print(e);
      setState(() {
        _isTyping = false;
        isLoading = false;
      });
    }
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      postMessage( _controller.text);
      setState(() {
        _messages.add({
          'text': _controller.text,
          'isMe': true,
        });
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // backgroundColor: Colors.grey[200], // Chat background color
      body: Container(
        decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  gradient: LinearGradient(
                    colors: [Color.fromARGB(255, 230, 249, 239), Colors.white],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back,
                        color: Color.fromARGB(255, 71, 188, 139),),
                          onPressed: () {
                             Navigator.pop(context);
                          },
                        ),
                        const SizedBox(width: 10),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: FadeInImage.assetNetwork(
                                placeholder:
                                    "assets/images/no_profile_image.webp",
                                image: "assets/images/ai.webp",
                                height: 60,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                imageErrorBuilder: (BuildContext context,
                                    Object error, StackTrace? stackTrace) {
                                  return Image.asset(
                                    'assets/images/no_profile_image.webp',
                                    height: 60,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  );
                                }),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Admyrer AI Assitant',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  gradient: LinearGradient(
                    colors: [Color.fromARGB(255, 230, 249, 239), Colors.white],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                        return ChatBubble(
                        text: _messages[index]['text'],
                        isMe: _messages[index]['isMe'],
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Type a message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    _isTyping ? 
                    const SpinKitThreeBounce(
                      color: Color.fromARGB(255, 71, 188, 139),
                      size: 20.0,
                    ) :
                    IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Color.fromARGB(255, 71, 188, 139),
                      ),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;

  const ChatBubble({
    required this.text,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: isMe ? Color.fromARGB(255, 104, 200, 163) : Colors.grey,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                text,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Positioned(
              top: 0,
              left: isMe ? null : -6,
              right: isMe ? -6 : null,
              child: CustomPaint(
                painter: ChatBubbleTrianglePainter(isMe: isMe),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubbleTrianglePainter extends CustomPainter {
  final bool isMe;

  ChatBubbleTrianglePainter({required this.isMe});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = isMe ? Color.fromARGB(255, 39, 176, 137) : Colors.grey
      ..style = PaintingStyle.fill;

    var path = Path();
    if (isMe) {
      path.moveTo(0, 0);
      path.lineTo(-10, 0);
      path.lineTo(0, 10);
      path.close();
    } else {
      path.moveTo(0, 0);
      path.lineTo(10, 0);
      path.lineTo(0, 10);
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
