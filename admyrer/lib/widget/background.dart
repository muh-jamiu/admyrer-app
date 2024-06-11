
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/drawable/firstbackgroundeffects.png'),
          fit: BoxFit.cover,
        ),
      ),
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          Image.asset("images/drawable/icon_splash.png", width: 200, height: 200,),
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
