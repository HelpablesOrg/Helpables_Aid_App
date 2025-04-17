import '../Modal/LocationHelper.dart';
import '../Providers/User_provider.dart';
import '../Providers/add_aid_requestprov.dart';
import '../Providers/categories_providers.dart';
import '../Providers/login_and_signup_provider.dart';
import '../Screens/login.dart';
import '../Screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const String apiKey = String.fromEnvironment("GOOGLE_MAPS_API_KEY", defaultValue: "");
  await LocationHelper.saveApiKey(apiKey);
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: Provider.of<UserInfoProvider>(context, listen: false)
              .setUserDetails(),
          builder: (context, userDetailsSnapshot) {
            if (userDetailsSnapshot.connectionState ==
                ConnectionState.waiting) {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasData) {
                  final user = snapshot.data;
                  Provider.of<UserInfoProvider>(context, listen: false)
                      .memberCheck(user?.email.toString(), context);
                  return HomeScreen();
                }

                return LoginScreen();
              },
            );
          }),
    );
  }
}
