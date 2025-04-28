import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Providers/aidrequests_provider.dart';
import 'Providers/add_aid_requestprov.dart';
import 'Providers/categories_providers.dart';
import 'Providers/login_and_signup_provider.dart';
import 'Providers/User_provider.dart';
import 'Modal/LocationHelper.dart';
import 'Screens/login.dart';
import 'Screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Save Google Maps API Key
  const String apiKey = String.fromEnvironment("GOOGLE_MAPS_API_KEY", defaultValue: "");
  await LocationHelper.saveApiKey(apiKey);

  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginAndSignupProvider()),
        ChangeNotifierProvider(create: (context) => AddAidRequestProvider()),
        ChangeNotifierProvider(create: (context) => UserInfoProvider()),
        ChangeNotifierProvider(create: (context) => CategoriesProvider()),
        ChangeNotifierProvider(create: (context) => AidRequestsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    try {
      await Provider.of<UserInfoProvider>(context, listen: false).setUserDetails();
      await Provider.of<AidRequestsProvider>(context, listen: false).fetchAidRequests();

      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          Provider.of<UserInfoProvider>(context, listen: false).memberCheck(user.email.toString(), context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      });
    } catch (e) {
      print('Initialization error: $e');
      // Optional: Show error page here if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
