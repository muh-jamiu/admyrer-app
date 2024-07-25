import 'package:admyrer/widget/backgrounds.dart';
import 'package:admyrer/widget/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:admyrer/services/api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admyrer/screens/update.dart';
import 'package:admyrer/screens/upload_image.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  bool isLoading = false;
  final ApiService _apiService = ApiService();
  final _codeControllers = List<TextEditingController>.generate(
      4, (index) => TextEditingController());
  final _focusNodes = List<FocusNode>.generate(4, (index) => FocusNode());
  late String _authToken;

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

  void verifyCode() async {
      var first =_codeControllers[0].text;
      var sec =_codeControllers[1].text;
      var third =_codeControllers[2].text;
      var fourth =_codeControllers[3].text;
    List<String> code = [
      _codeControllers[0].text,
      _codeControllers[1].text,
      _codeControllers[2].text,
      _codeControllers[3].text,
    ];
    var _code = '$first$sec$third$fourth';
     SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _authToken = prefs.getString('authToken') ?? '';
    });
    if (code.length >= 3) {
      setState(() {
        isLoading = true;
      });

      final user = await _apiService.postRequest("verify", {
        "code": _code,
        "id": _authToken
      });

      if (user.statusCode != 200) {
        showErrorToast("Invalid code, Please try again",
            const Color.fromARGB(255, 238, 71, 126));
        setState(() {
          isLoading = false;
        });
        return;
      } else {
        showErrorToast("Code verified successfully",
            const Color.fromARGB(255, 100, 246, 190));
        Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => UploadImage()));
        });
      }
    }
  }

  void home() {
    Navigator.pushNamed(context, "/tab");
  }

  @override
  void dispose() {
    _codeControllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  void _onCodeChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
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
                  Column(
                    children: [
                      const SizedBox(height: 80),
                      Center(
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Account ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: 'Verification',
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
                        child: Text(
                            "Verification code has been sent to your mail inbox.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List<Widget>.generate(4, (index) {
                          return SizedBox(
                            width: 50,
                            child: TextField(
                              controller: _codeControllers[index],
                              focusNode: _focusNodes[index],
                              maxLength: 1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 24),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                counterText: "",
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) =>
                                  _onCodeChanged(value, index),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      GradientButton(
                          text: "Verify Code",
                          onPressed: verifyCode,
                          isLoading: isLoading),
                    ],
                  ),
                  Column(
                    children: [
                      const Divider(
                        color: Color.fromARGB(255, 215, 215, 215),
                        thickness: 1.0,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () => {},
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: "Didn't recieve code? ",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 81, 81, 81),
                                    fontSize: 16,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Resend Code',
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
