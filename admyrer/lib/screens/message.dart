import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Message extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
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
      backgroundColor: Colors.grey[200], // Chat background color
      body: SafeArea(
        child: Column(
          children: [
            Container(
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.purple[400]),
                        onPressed: () {
                          // Implement back button functionality
                        },
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: FadeInImage.assetNetwork(
                              placeholder:
                                  "assets/images/no_profile_image.webp",
                              image: "avatar",
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
                      Text(
                        'User Name',
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
                      Icon(
                        Icons.camera_alt,
                        color: Colors.purple[400],
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                color: Colors.grey[200],
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
                  IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.purple[400],
                    ),
                    onPressed: () {
                      // Implement camera button functionality
                    },
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
