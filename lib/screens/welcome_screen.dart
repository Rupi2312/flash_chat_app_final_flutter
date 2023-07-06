
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat_app_final_flutter/screens/registration_screen.dart';
import 'package:flutter/material.dart';

import '../componenets/RoundedButton.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {

  static const String id="welcome_screen";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  late AnimationController controller;
 late Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller= AnimationController(

      duration: Duration(seconds: 1),
      vsync: this ,

    );

    animation= ColorTween(begin: Colors.blueGrey,end:Colors.white).animate(controller);

    // animation= CurvedAnimation(parent: controller, curve: Curves.decelerate);
   // controller.reverse(from: 1.0);
    controller.forward();
    // animation.addStatusListener((status) {
    //
    //   if(status== AnimationStatus.completed)
    //    { controller.reverse(from: 1.0);}
    //   else if( status== AnimationStatus.dismissed)
    //     {
    //       controller.forward();
    //     }
    //
    //
    // });
    controller.addListener(() {

      setState(() {

      });
      print(controller.value);

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value ,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Hello world!',
                      textStyle: const TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.w900,
                      ),
                      speed: const Duration(milliseconds: 300),
                    ),
                  ],

                  totalRepeatCount: 4,
                  pause: const Duration(milliseconds: 1000),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
                // Text(
                //   'Flash Chat',
                //   style: TextStyle(
                //     fontSize: 45.0,
                //     fontWeight: FontWeight.w900
                //     ,
                //   ),
                // ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundButton(color: Colors.lightBlueAccent,title:"Login",onPressed: () {
              Navigator.pushNamed(context, LoginScreen.id);
              //Go to registration screen.
            }),

            RoundButton(color: Colors.blueAccent,title:"Register",onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
                //Go to registration screen.
              }),
          ],
        ),
      ),
    );
  }
}

