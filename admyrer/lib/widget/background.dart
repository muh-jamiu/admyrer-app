
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/firstbackgroundeffects.png'),
          fit: BoxFit.cover,
        ),
      ),
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          Image.asset("assets/images/main_logo.png", width: 200, height: 200,),
          const Center(
            // child: Text(
            //   'ADMYRER',
            //   style: TextStyle(
            //     fontSize: 30,
            //     color: Colors.white,
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}
