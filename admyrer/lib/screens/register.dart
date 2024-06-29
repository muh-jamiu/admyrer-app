import 'package:admyrer/widget/backgrounds.dart';
import 'package:admyrer/widget/gradient_button.dart';
import 'package:admyrer/screens/password_text.dart';
import 'package:admyrer/widget/bootstrap_textfield.dart';
import 'package:admyrer/widget/google_login.dart';
import 'package:admyrer/widget/facebook.dart';
import 'package:admyrer/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _LoginState();
}

class _LoginState extends State<Register> {
  final ApiService _apiService = ApiService();
  late Future<dynamic> data;  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void login() {
    Navigator.pushNamed(context, "/login");
  }

  
  void _signup() async {
      if (_formKey.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });

        final user = await _apiService.postRequest("register", {
          "username": _username.text,
          "email": _emailController.text,
          "first_name": _firstname.text,
          "last_name": _lastname.text,
          "password": _passwordController.text
        });
        
        if(user.statusCode != 200){
           showErrorToast("Something went wrong, Please try again", const Color.fromARGB(255, 238, 71, 126));
           setState(() {
            isLoading = false;
          });
           return;
        }else{
          showErrorToast("Account signup successfully", const Color.fromARGB(255, 100, 246, 190));
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('authToken', user.body);
          Future.delayed( const Duration(seconds:2), () {
            Navigator.pushReplacementNamed(context, "/verify");
          });
        }
 
      }
  }


  void showErrorToast(String message, Color color) {
    Fluttertoast.showToast(
      msg: "$message",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 5,
      textColor: Colors.white,
      backgroundColor: Colors.pink[300],
      fontSize: 15.0,
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
                    Form(
                    key: _formKey,
                      child: Column(
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
                          controller: _firstname,
                        ),
                        const SizedBox(height: 30),
                        BootstrapTextField(
                          labelText: 'Last Name',
                          icon: Icons.verified_user_outlined,
                          controller: _lastname,
                        ),
                        const SizedBox(height: 30),
                        BootstrapTextField(
                          labelText: 'Email Address',
                          icon: Icons.mail_outlined,
                          controller: _emailController,
                        ),
                        const SizedBox(height: 30),
                        BootstrapTextField(
                          labelText: 'Username',
                          icon: Icons.verified_user_outlined,
                          controller: _username,
                        ),
                        const SizedBox(height: 30),
                        PasswordText(
                          labelText: 'Password',
                          icon: Icons.lock_open_outlined,
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 50,),
                        GradientButton(text: "Sign up", onPressed:  _signup, isLoading: isLoading),
                      ],
                                        ),
                    ),
                  
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      const Divider(
                        color: Color.fromARGB(255, 215, 215, 215),
                        thickness: 1.0,
                      ),
                      const SizedBox(height: 20,),                  
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
