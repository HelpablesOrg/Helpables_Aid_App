import 'package:helpables/Providers/add_aid_requestprov.dart';
import 'package:helpables/Providers/categories_providers.dart';
import 'package:helpables/Screens/aidreqlist.dart';
import 'package:helpables/Widgets/filter.dart';

import '../Providers/User_provider.dart';
import '../Screens/add_aid_request_screen.dart';
import '../Screens/login.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? selectedCategory;
  String? selectedLocation;
  String searchQuery = "";

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<CategoriesProvider>(context, listen: false).fetchCategories();
  }

  Future<void> signOut() async {
    try {
      if (await _googleSignOut.isSignedIn()) {
        await _googleSignOut.signOut();
      }
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  void _clearFilters() {
    setState(() {
      selectedCategory = null;
      selectedLocation = null;
    });
  }

  void _updateSearch(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  void _openFilterScreen() async {
    final result = await showModalBottomSheet<Map<String, String?>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterScreen(
        selectedCategory: selectedCategory,
        selectedLocation: selectedLocation,
      ),
    );

    if (result != null) {
      setState(() {
        selectedCategory = result['category'];
        selectedLocation = result['location'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey),
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.indigo[900]),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search By title or category",
                    hintStyle: TextStyle(color: Colors.indigo[900]),
                  ),
                  onChanged: _updateSearch,
                ),
              ),
              IconButton(
                icon: Icon(Icons.menu, color: Colors.indigo[900]),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                if (index == 1) {
                  signOut();
                } else {
                  setState(() {
                    _selectedIndex = index;
                  });
                  Navigator.pop(context);
                }
              },
              labelType: NavigationRailLabelType.all,
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.list),
                  selectedIcon: Icon(Icons.list_alt),
                  label: Text('Aid Requests'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.logout, color: Colors.red),
                  selectedIcon: Icon(Icons.logout, color: Colors.red),
                  label: Text('Sign Out', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Provider.of<UserInfoProvider>(context, listen: true)
              .isMemeber
          ? FloatingActionButton(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.add,
                color: Colors.blue[900],
              ),
              onPressed: () {
                Provider.of<AddAidRequestProvider>(context, listen: false)
                    .cleardata();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AddAidRequestScreen();
                }));
              })
          : null,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed:
                      (selectedCategory != null || selectedLocation != null)
                          ? _clearFilters
                          : _openFilterScreen,
                  icon: Icon(
                    (selectedCategory != null || selectedLocation != null)
                        ? Icons.clear
                        : Icons.filter_alt,
                    color: Colors.white,
                  ),
                  label: Text('Filter', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
                SizedBox(width: 8),
                if (selectedCategory != null)
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedCategory = null;
                      });
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                    label: Text(selectedCategory!,
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                SizedBox(width: 8),
                if (selectedLocation != null)
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedLocation = null;
                      });
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                    label: Text(selectedLocation!,
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.76,
            width: MediaQuery.of(context).size.width,
            child: _getScreenForIndex(_selectedIndex),
          ),
        ],
      ),
    );
  }

  Widget _getScreenForIndex(int index) {
    return AidRequestList(
      category: selectedCategory,
      location: selectedLocation,
      searchQuery: searchQuery,
    );
  }
}
