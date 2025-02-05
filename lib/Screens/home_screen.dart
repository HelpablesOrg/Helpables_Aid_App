import 'package:aid_app/Providers/User_provider.dart';
import 'package:aid_app/Providers/add_aid_requestprov.dart';
import 'package:aid_app/Screens/add_aid_request_screen.dart';
import 'package:aid_app/Screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignOut = GoogleSignIn();

  Future<void> signOut() async {
    try {
      if (await _googleSignOut.isSignedIn()) {
        await _googleSignOut.signOut();
      }
      await _auth.signOut();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LoginScreen();
                }));
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: Center(
          child: ElevatedButton(
              onPressed: () {
                signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LoginScreen();
                }));
              },
              child: Text('Sign Out')),
        ),
        floatingActionButton:
            Provider.of<UserInfoProvider>(context, listen: true).isMemeber
                ? FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AddAidRequestScreen();
                      }));
                    })
                : null);
  }
}
