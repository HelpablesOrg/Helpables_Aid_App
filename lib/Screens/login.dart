import 'package:aid_app/Widgets/google_login.dart';
import 'package:aid_app/Widgets/loginform.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.08),
                height: MediaQuery.of(context).size.height * 0.79,
                child: Loginform()),
            Container(
              alignment: Alignment.bottomCenter,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Google_Login()),
          ]
        ),
      ),
    ));
  }
}
