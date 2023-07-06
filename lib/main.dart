import 'package:flash_chat_app_final_flutter/screens/chat_screen.dart';
import 'package:flash_chat_app_final_flutter/screens/login_screen.dart';
import 'package:flash_chat_app_final_flutter/screens/registration_screen.dart';
import 'package:flash_chat_app_final_flutter/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  //initilization of Firebase app


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(





      initialRoute: WelcomeScreen.id ,
      routes: {
        WelcomeScreen.id : (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id:(context) => RegistrationScreen(),
        ChatScreen.id :(context)=> ChatScreen(),

      },
    );
  }
}
