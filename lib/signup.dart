import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'firebase_helpers.dart';

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Signup")),
      body: Column(
        children: <Widget>[SignupForm()],
      ),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

// Create a Form widget.
class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  SignupFormState createState() {
    return SignupFormState();
  }
}

//form state
class SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const ListTile(
              title: Text("BroncoSafe Signup"),
            ),
            TextFormField(
              controller: fNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter a name';
                }
                return null;
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "First Name"),
            ),
            TextFormField(
              controller: lNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter a name';
                }
                return null;
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Last Name"),
            ),
            TextFormField(
              controller: emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter an email';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your CPP Email"),
            ),
            TextFormField(
              controller: passController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter a password';
                }
                return null;
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your Bronco Safe Password"),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    //firebase code
                    String fName = fNameController.text.toString();
                    String lName = lNameController.text.toString();
                    String email = emailController.text.toString();
                    String pass = passController.text.toString();

                    if (await FirebaseHelpers.createUser(
                            fName, lName, email, pass) ==
                        "success") {
                      Navigator.popAndPushNamed(context, "/");
                    }
                  }
                },
                child: Text("Signup"))
          ],
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    fNameController.dispose();
    lNameController.dispose();
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }
}
