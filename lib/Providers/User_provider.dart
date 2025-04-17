import 'dart:async';
import '../Providers/categories_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfoProvider with ChangeNotifier {
  bool isLoading = false;
  final List<String> _members = [];
  bool isMemeber = false;
  StreamSubscription? _userSubscription;
  List<String> getmembers() {
    return [..._members];
  }

  checkLoading(bool check) {
    isLoading = check;
    notifyListeners();
  }

  memberCheck(String? email, BuildContext context) {
    if (_members.contains(email)) {
      isMemeber = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<CategoriesProvider>(context, listen: false)
            .fetchCategories();
      });
    } else {
      isMemeber = false;
    }
  }

  Future<void> setUserDetails() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Users').get();
    _members.clear();
    for (var user in snapshot.docs) {
      _members.add(user['Email']);
    }
    notifyListeners();
    _userSubscription = FirebaseFirestore.instance
        .collection('Users')
        .snapshots()
        .skip(1)
        .listen((event) {
      _members.clear();
      for (var user in event.docs) {
        _members.add(user['Email']);
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }
}
