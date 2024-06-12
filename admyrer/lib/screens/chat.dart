import 'package:admyrer/widget/backgrounds.dart';
import 'package:admyrer/widget/gradient_button.dart';
import 'package:admyrer/widget/bootstrap_textfield.dart';
import 'package:admyrer/widget/google_login.dart';
import 'package:admyrer/widget/facebook.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Stack(
          // padding: const EdgeInsets.all(15.0),
          children: [
            const Backgrounds(),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  const Text('Chat List', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Users(),
                  SizedBox(height: 10,),
                  Divider(
                    color: Color.fromARGB(255, 215, 215, 215),
                    thickness: 1.0,
                  ),
                  Expanded(child: ChatList())
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
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          
          children: List.generate(10, (index) {
            return Column(
              children: [
                Row(
                  children: [
                  const SizedBox(width: 20, height: 10,),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color.fromARGB(255, 207, 37, 212),
                          width: 3.0
                        )
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage("images/icon.png"),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                const Row(
                  children: [
                    SizedBox(width: 20),
                    Text("Larvish007", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w100, color: Colors.grey),),
                  ],
                ),
              ],
            );
          }),
        ),
      );
  }
}


class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
   final items = List<String>.generate(5, (index) => 'Item $index');
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage("images/icon.png"),
                ),
                const SizedBox(width: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(items[index], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),textAlign: TextAlign.start,),
                    const Text("Messaga Notifications", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w100, color: Colors.grey),),
                  ],
                ),
              ],
            ),
          );
        },
    );
  }
}