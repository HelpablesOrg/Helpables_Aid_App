// ignore_for_file: unused_local_variable

import 'package:aid_app/Providers/User_provider.dart';
import 'package:aid_app/Providers/login_and_signup_provider.dart';
import 'package:aid_app/Screens/home_screen.dart';
import 'package:aid_app/Widgets/email_password.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class Loginform extends StatefulWidget {
  const Loginform({super.key});
  @override
  State<StatefulWidget> createState() => _LoginformState();
}

class _LoginformState extends State<Loginform> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> handleSubmit(bool isLogin, BuildContext ctx) async {
    if (!_formKey.currentState!.validate()) return;
    final provider = Provider.of<UserInfoProvider>(context, listen: false);
    provider.setUserDetails();
    if (isLogin) {
      try {
        setState(() {
          provider.checkLoading(true);
        });
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: Provider.of<LoginAndSignupProvider>(ctx, listen: false)
                    .getEmail(),
                password:
                    Provider.of<LoginAndSignupProvider>(ctx, listen: false)
                        .getPass());
        Provider.of<UserInfoProvider>(ctx, listen: false)
            .memberCheck(userCredential.user?.email, ctx);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("You are logged in.")));
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      } catch (e) {
        String error = e.toString().replaceAll(RegExp(r'\[firebase.*?\]'), '');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error logging in: $error")));
      } finally {
        setState(() {
          provider.checkLoading(false);
        });
      }
    } else {
      try {
        setState(() {
          provider.checkLoading(true);
        });
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: Provider.of<LoginAndSignupProvider>(ctx, listen: false)
              .getEmail(),
          password:
              Provider.of<LoginAndSignupProvider>(ctx, listen: false).getPass(),
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Account created: ${userCredential.user?.email}')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Error signing up: ${e.toString().replaceFirst('[firebase_auth/email-already-in-use]', "").trim()}')));
      } finally {
        setState(() {
          provider.checkLoading(false);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginAndSignupProvider>(context, listen: true);
    bool isLogin = provider.isLogin;
    return Stack(
      children: [
        Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/9-removebg-preview.png',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.19,
              width: MediaQuery.of(context).size.width * 0.6,
            ),
          ),
          Text(
            isLogin ? 'Log in to your account' : 'Create a new account',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
          ),
          Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    EmailandPass(formKey: _formKey),
                    SizedBox(height: 22),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          handleSubmit(isLogin, context);
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(400, 40),
                            padding: EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            backgroundColor: Colors.blue[900]),
                        child: Text(
                          isLogin ? 'Log in' : 'Sign Up',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ]),
      ],
    );
  }
}
