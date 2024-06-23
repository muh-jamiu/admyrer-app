import 'package:admyrer/widget/backgrounds.dart';
import 'package:admyrer/widget/gradient_button.dart';
import 'package:admyrer/screens/password_text.dart';
import 'package:admyrer/widget/bootstrap_textfield.dart';
import 'package:admyrer/widget/google_login.dart';
import 'package:admyrer/widget/facebook.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _LoginState();
}

class _LoginState extends State<Register> {
  bool isLoading = false;
  void login() {
    Navigator.pushNamed(context, "/login");
  }

  void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: "$message",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 5,
      textColor: Colors.white,
      backgroundColor: Colors.pink[300],
      fontSize: 20.0,
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [Stack(
            // padding: const EdgeInsets.all(15.0),
            children: [
              const Backgrounds(),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                    children: [
                      const SizedBox(height: 40),
                       Center(
                        child:  RichText(
                          text:const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Welcome To ',
                                style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: 'Admyrer',
                                style: TextStyle(color: Colors.purple, fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      const Center(
                        child: Text(
                            "Sign up to continue finding partner",
                            textAlign: TextAlign.center,
                           style:
                                TextStyle(fontSize: 20)),
                      ),
                      const SizedBox(height: 50),
                      BootstrapTextField(
                        labelText: 'First Name',
                        icon: Icons.verified_user_outlined,
                        controller: TextEditingController(),
                      ),
                      const SizedBox(height: 30),
                      BootstrapTextField(
                        labelText: 'Last Name',
                        icon: Icons.verified_user_outlined,
                        controller: TextEditingController(),
                      ),
                      const SizedBox(height: 30),
                      BootstrapTextField(
                        labelText: 'Email Address',
                        icon: Icons.mail_outlined,
                        controller: TextEditingController(),
                      ),
                      const SizedBox(height: 30),
                      BootstrapTextField(
                        labelText: 'Username',
                        icon: Icons.verified_user_outlined,
                        controller: TextEditingController(),
                      ),
                      const SizedBox(height: 30),
                      PasswordText(
                        labelText: 'Password',
                        icon: Icons.lock_open_outlined,
                        controller: TextEditingController(),
                      ),
                      const SizedBox(height: 50,),
                      GradientButton(text: "Sign up", onPressed:  () => showErrorToast("Something went wrong, Please try again"), isLoading: isLoading),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      const Divider(
                        color: Color.fromARGB(255, 215, 215, 215),
                        thickness: 1.0,
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GoogleLogin(onPressed: () => {}),
                          Facebook(onPressed: () => {}),
                          Facebook(onPressed: () => {}),
                        ]
                      ),
                      const SizedBox(height: 30,),                    
                      Center(
                        child:  InkWell(
                          onTap: login,
                          child: RichText(
                            text:const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Already have an account? ',
                                  style: TextStyle(color: Color.fromARGB(255, 81, 81, 81), fontSize: 16,),
                                ),
                                TextSpan(
                                  text: 'Login',
                                  style: TextStyle(color: Color.fromARGB(255, 241, 44, 126), fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,), 
                    ],
                  )
                  ],
                ),
              ),
            ],
          )],
        ),
      ),
    );
  }
}
