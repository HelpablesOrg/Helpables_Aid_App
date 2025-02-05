import 'package:aid_app/Providers/User_provider.dart';
import 'package:aid_app/Providers/add_aid_requestprov.dart';
import 'package:aid_app/Providers/categories_providers.dart';
import 'package:aid_app/Providers/login_and_signup_provider.dart';
import 'package:aid_app/Screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginAndSignupProvider()),
        ChangeNotifierProvider(create: (context) => AddAidRequestProvider()),
        ChangeNotifierProvider(create: (context) => UserInfoProvider()),
        ChangeNotifierProvider(create: (context) => CategoriesProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     Provider.of<UserInfoProvider>(context, listen: false).setUserDetails();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
