import 'package:admyrer/screens/password_text.dart';
import 'package:admyrer/widget/backgrounds.dart';
import 'package:admyrer/widget/gradient_button.dart';
import 'package:admyrer/widget/bootstrap_textfield.dart';
import 'package:admyrer/widget/google_login.dart';
import 'package:admyrer/widget/facebook.dart';
import 'package:admyrer/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final ApiService _apiService = ApiService();
  late Future<dynamic> data;  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void register() {
    Navigator.pushNamed(context, "/register");
  }

  void forgot() {
    Navigator.pushNamed(context, "/forgot");
  }

  void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }

  Future<void> _handleSignIn() async {
    final user = await _apiService.signInWithGoogle();
    print(user);

    if (user != null) {
      // Obtain the user's ID token
      final authHeaders = await user.authHeaders;
      final idToken = authHeaders['Authorization']?.split(' ')[1];
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: Icon(Icons.mark_chat_read_rounded, color: Colors.green[300],),
          title: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                // Navigator.pushNamed(context, "/verify");
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void verify() async {
      if (_formKey.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });

        final user = await _apiService.postRequest("login", {
          "username": _emailController.text,
          "password": _passwordController.text
        });
        
        if(user.statusCode != 200){
           showErrorToast(user.body);
           setState(() {
            isLoading = false;
          });
           return;
        }
        print(user.body);     

        // Navigator.pushNamed(context, "/verify");
      }
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
                  Form(
                    key: _formKey,
                    child: Column(
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
                          controller: _emailController,
                        ),
                        const SizedBox(height: 30),
                        PasswordText(
                          labelText: 'Password',
                          icon: Icons.lock_open_outlined,
                          controller: _passwordController,
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
                        GradientButton(text: "Login", onPressed: verify, isLoading: isLoading),
                      ],
                    ),
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
                            GoogleLogin(onPressed: _handleSignIn),
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
