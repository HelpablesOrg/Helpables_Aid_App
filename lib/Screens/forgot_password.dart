import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController= TextEditingController();
  @override
  void dispose(){
    _emailController.dispose();
    super.dispose();
  }
   Future passwordReset()async{
 try{
     await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
 } on FirebaseAuthException catch (e){
  print(e);
 }
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(elevation: 0,),body: Column(children: [
      Text("Enter email and we'll send you a password reset link."),

      Padding(
        padding: const EdgeInsets.all(10),
        child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                 
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        labelText: 'Email'),
                  ),
      ),
ElevatedButton(onPressed: (){
  passwordReset();
}, child: Text('Reset Password'))
    ],),);
  }
}