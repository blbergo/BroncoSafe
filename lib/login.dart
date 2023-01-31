import 'package:bronco_safe/firebase_helpers.dart';
import 'package:flutter/material.dart';

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(title: const Text("Login")),
          body: const Card(
            child: LoginForm(),
          ),
        ));
  }
}

//state object
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// Create a Form widget.
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

//form state
class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const ListTile(
              title: Text("BroncoSafe Login"),
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
                    String email = emailController.text.toString();
                    String pass = passController.text.toString();

                    if (await FirebaseHelpers.authUser(email, pass)) {
                      Navigator.popAndPushNamed(context, "/");
                    }
                  }
                },
                child: Text("Login"))
          ],
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }
}
