/*
Name: main.dart
Description: Startup page for the Bronco Safe Application on all platforms
DMOD: 1/26/23
*/
import 'dart:io';

import 'package:bronco_safe/firebase_helpers.dart';
import 'package:bronco_safe/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  //initialize firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const BroncoSafe());
}

class BroncoSafe extends StatelessWidget {
  const BroncoSafe({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bronco Safe',
      theme: ThemeData(
          // This is the theme of your application.
          primaryColor: Colors.green.shade800),
      routes: {
        '/': (context) => HomePage(title: 'Bronco Safe'),
        '/login': (context) => const LoginPage()
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  setState() {}

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: []),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    //used for changing to the login page when signed out
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!FirebaseHelpers.checkAuthState()) {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
  }
}
