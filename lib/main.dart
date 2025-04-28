
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: Future.wait([
            Provider.of<UserInfoProvider>(context, listen: false)
                .setUserDetails(),
            Provider.of<AidRequestsProvider>(context, listen: false)
                .fetchAidRequests(),
          ]),
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
