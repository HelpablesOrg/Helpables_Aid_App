import 'package:flutter/material.dart';

class LoginAndSignupProvider with ChangeNotifier {
  bool isLogin = true;
  String email = '';
  String password = '';
  void notify(bool Login) {
    isLogin = Login;
    notifyListeners();
  }

  void getPasswordandEmail(String pass, String mail) {
    password = pass;
    email = mail;
    notifyListeners();
  }

  String getEmail() {
    return email;
  }
  String getPass() {
    return password;
  }
}
