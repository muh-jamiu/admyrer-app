import 'package:admyrer/models/chatModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:admyrer/models/user.dart';
import 'package:admyrer/services/api_service.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:admyrer/screens/single.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class Message extends StatefulWidget {
  final UserModel user;
  const Message({super.key, required this.user});
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  late UserModel user = widget.user;
  List<ChatModel> conversation = [];
  final ApiService _apiService = ApiService();
  bool isLoading = true;
  late String _authToken;
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();  

  Future<void> triggerPuser() async {
    try {
      final response = await _apiService.postRequest("notify", {
        "username": "jamiu",
        "title": "You have a new message from Jamiu",
        "message":_controller.text,
      });
    } catch (e) {
      print(e);
    }
  }

   void _pusher() async{
    PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
    try {
      await pusher.init(
        apiKey: "be7a4955db605d26a6bc",
        cluster: "mt1",
        onConnectionStateChange: (String change, String e) async {
          showErrorToast("previousState: ${e}, currentState: ${change}");
        },
        onError: (String e, int? i, dynamic d) {
          showErrorToast("pusher Error: ${e}");
        },
        onSubscriptionError: (String channel, dynamic e) {
          showErrorToast("Subscription Error: ${e.message}");
        },
        onEvent: (PusherEvent event){
          pusher.trigger(event);
          showErrorToast('pusher event ${event.eventName}, ${event.channelName}, ${event.data}');
        },
      );

      await pusher.subscribe(channelName: "app_event", 
      onEvent: (event) {
        showErrorToast("Got channel event: $event");
      },
       onSubscriptionSucceeded: (channelName, data) {
          showErrorToast("Subscribed to $channelName");
        },
      );

      await pusher.connect();      
      await pusher.onEvent!(PusherEvent(channelName: "app_event", eventName: "app_event", data: "on event data"));
      await pusher.trigger(PusherEvent(channelName: "app_event", eventName: "app_event", data: "on trigger data"));

    } catch (e) {
      showErrorToast("ERROR: $e");
      print("ERROR: $e");
    }
  }


  Future<void> _pickImage() async {
    // Request storage permission
    PermissionStatus status = await Permission.storage.request();

    if (true) {
      final pickedFile = await _picker.getImage(source: ImageSource.gallery);
      setState(() {
        _imageFile = pickedFile;
      });
    } else {
      // Handle the case when the user denies the permission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Storage permission is required to access the gallery.')),
      );
    }
  }

  void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      textColor: Colors.white,
      backgroundColor:  Color.fromARGB(255, 100, 246, 190),
      fontSize: 15.0,
    );
  }

  Future<void> getMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _authToken = prefs.getString('authToken') ?? '';
    });

    try {
      final response = await _apiService.postRequest("get-message", {
        "sender": _authToken,
        "reciever": widget.user.id,
      });

      var data = json.decode(response.body);

      if (data["data"] == null || data["data"] == null) {
        showErrorToast('Invalid response data');
        return;
      }

      List<dynamic> userList = data["data"];
      List<ChatModel> conversation =
          userList.map((user) => ChatModel.fromJson(user)).toList();


      for(var msg in conversation){
        if(msg.sender == _authToken){
          setState(() {
            _messages.add({
              'text': msg.message,
              'isMe': true,
            });
          });
        }else{
           setState(() {
            _messages.add({
              'text': msg.message,
              'isMe': false,
            });
          });
        }
      }

      setState(() {
        this.conversation = conversation;
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

  Future<void> postMessage(message) async {
    triggerPuser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _authToken = prefs.getString('authToken') ?? '';
    });

    try {
      final response = await _apiService.postRequest("save-message", {
        "sender": _authToken,
        "reciever": widget.user.id,
        "message": message,
      });

      showErrorToast('Message sent successfully');
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
    getMessage();
    _pusher();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _controller.text,
          'isMe': true,
        });
        postMessage(_controller.text);
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      user = widget.user;
    }

    var firstName = user.firstName;
    var avatar = user.avatar;
    var lastName = user.lastName;

    return Scaffold(
      // backgroundColor: Colors.grey[200], // Chat background color
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 249, 230, 236), Colors.white],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon:
                              Icon(Icons.arrow_back, color: Colors.purple[400]),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Single(users: user)));
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: FadeInImage.assetNetwork(
                                  placeholder:
                                      "assets/images/no_profile_image.webp",
                                  image: avatar,
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
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '$firstName $lastName',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.video,
                          color: Colors.purple[400],
                        ),
                        SizedBox(width: 15),
                        InkWell(
                          onTap: _pickImage,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.purple[400],
                          ),
                        ),
                      ],
                    )
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
                      colors: [
                        Color.fromARGB(255, 249, 230, 236),
                        Colors.white
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: isLoading
                      ? Center(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 60,
                              ),
                              SpinKitThreeBounce(
                                color: Colors.pink[400],
                                size: 35.0,
                              )
                            ],
                          ),
                        )
                      : ListView.builder(
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
                    InkWell(
                      onTap: _pickImage,
                      child: IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.purple[400],
                        ),
                        onPressed: () {
                          // Implement camera button functionality
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.purple[400],
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
                color: isMe ? Colors.purple[300] : Colors.grey,
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
      ..color = isMe ? Colors.purple : Colors.grey
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
