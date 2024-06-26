import 'package:admyrer/widget/backgrounds.dart';
import 'package:admyrer/widget/gradient_button.dart';
import 'package:admyrer/widget/bootstrap_textfield.dart';
import 'package:admyrer/widget/google_login.dart';
import 'package:admyrer/widget/facebook.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void register() {
    Navigator.pushNamed(context, "/register");
  }

  void forgot() {
    Navigator.pushNamed(context, "/forgot");
  }

  void verify() {
    Navigator.pushNamed(context, "/tab");
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 40),
                      Center(
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Welcome ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: 'Back',
                                style: TextStyle(
                                    color: Colors.purple,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Center(
                        child: Text("Login to continue finding partner",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20)),
                      ),
                      const SizedBox(height: 50),
                      BootstrapTextField(
                        labelText: 'Email Address or Username',
                        icon: Icons.verified_user_outlined,
                        controller: TextEditingController(),
                      ),
                      const SizedBox(height: 30),
                      BootstrapTextField(
                        labelText: 'Password',
                        icon: Icons.lock_open_outlined,
                        controller: TextEditingController(),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: forgot,
                        child: const Text(
                          "Forgot Password?",
                          textAlign: TextAlign.end,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      GradientButton(text: "Login", onPressed: verify),
                    ],
                  ),
                  Column(
                    children: [
                      const Divider(
                        color: Color.fromARGB(255, 215, 215, 215),
                        thickness: 1.0,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GoogleLogin(onPressed: () => {}),
                            Facebook(onPressed: () => {}),
                            Facebook(onPressed: () => {}),
                          ]),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: InkWell(
                          onTap: register,
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Not a member? ',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 81, 81, 81),
                                    fontSize: 16,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Register Now',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 241, 44, 126),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
