import 'package:admyrer/widget/backgrounds.dart';
import 'package:admyrer/widget/gradient_button.dart';
import 'package:flutter/material.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  void home() {
    Navigator.pushNamed(context, "/home");
  }

  final _codeControllers = List<TextEditingController>.generate(6, (index) => TextEditingController());
  final _focusNodes = List<FocusNode>.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    _codeControllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  void _onCodeChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
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
                        child: Text("Verification code has been sent to your mail inbox.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 50),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List<Widget>.generate(6, (index) {
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
                              onChanged: (value) => _onCodeChanged(value, index),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      GradientButton(text: "Verify Code", onPressed: () => {}),
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
