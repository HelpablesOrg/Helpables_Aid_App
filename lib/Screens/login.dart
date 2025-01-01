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
      body: Column(
        children: [
          Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1),
              height: MediaQuery.of(context).size.height * 0.67,
              child: Loginform()),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.24,
              child: Google_Login()),
        ],
      ),
    ));
  }
}
