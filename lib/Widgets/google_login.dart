import 'package:aid_app/Providers/login_and_signup_provider.dart';
import 'package:aid_app/Screens/forgot_password.dart';
import 'package:aid_app/Screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class Google_Login extends StatefulWidget {
  const Google_Login({super.key});

  @override
  State<Google_Login> createState() => _Google_LoginState();
}

class _Google_LoginState extends State<Google_Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;
  Future<void> _signUpandLoginWithGoogle(BuildContext ctx, bool isLogin) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
      }
      setState(() {
        _isLoading = true;
      });
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth!.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      if (userCredential.additionalUserInfo?.isNewUser == true) {
        await _googleSignIn.disconnect().catchError((e) {});
        await _googleSignIn.signOut();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'You dont have an account, please create a new account.')));
      } else if (isLogin) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You have successfully logged in')));
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('You have successfully create a new account')));
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
    } catch (e) {
      await _googleSignIn.disconnect().catchError((e) {});
      await _googleSignIn.signOut();

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google Sign in failed. Please try again')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginAndSignupProvider>(context, listen: true);
    bool isLogin = provider.isLogin;
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (isLogin)
              Align(
                alignment: Alignment.center,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
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
                text: isLogin ? 'Log in with Google' : 'Sign Up with Google',
                elevation: 4,
                onPressed: () {
                  _signUpandLoginWithGoogle(context, isLogin);
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                      Provider.of<LoginAndSignupProvider>(context,
                              listen: false)
                          .notify(isLogin);
                    });
                  },
                  child: Text(isLogin
                      ? "Don't have an account? Sign Up"
                      : 'Already have an account? Log In')),
            )
          ],
        ),
        if (_isLoading)
          Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
