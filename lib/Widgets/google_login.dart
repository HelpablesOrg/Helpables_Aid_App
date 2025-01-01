import 'package:aid_app/Screens/forgot_password.dart';
import 'package:aid_app/Screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Google_Login extends StatefulWidget {
  const Google_Login({super.key});

  @override
  State<Google_Login> createState() => _Google_LoginState();
}

class _Google_LoginState extends State<Google_Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<void> _signInWithGoogleForExistingAccount(BuildContext ctx) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("Google Sign-In cancelled by user.");
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth!.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;
      if (userCredential.additionalUserInfo?.isNewUser == true) {
        await _googleSignIn.disconnect().catchError((e) {
          print("No previous Google user to disconnect: $e");
        });
        await _googleSignIn.signOut();
        print("Sign-in failed: User does not exist in Firebase.");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You have successfully logged in')));
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
      print("User logged in: ${user?.email}");
    } catch (e) {
      print("Google sign in error: $e");
      await _googleSignIn.disconnect().catchError((e) {
        print("No previous Google user to disconnect: $e");
      });
      await _googleSignIn.signOut();
      print("Sign-in failed: User does not exist in Firebase.");

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google Sign in failed. Please try again')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ForgotPassword();
                }));
              },
              child: Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.grey, fontSize: 17),
              )),
        ),
        Divider(indent: 40, endIndent: 40),
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: SignInButton(
            Buttons.Google,
            text: 'Log in with Google',
            elevation: 4,
            onPressed: () => _signInWithGoogleForExistingAccount(context),
          ),
        )
      ],
    );
  }
}
