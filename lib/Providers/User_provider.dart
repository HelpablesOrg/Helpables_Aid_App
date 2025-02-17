import 'dart:async';
import 'package:aid_app/Providers/categories_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfoProvider with ChangeNotifier {
  bool isLoading = false;
  List<String> _members = [];
  bool isMemeber = false;
  StreamSubscription? _userSubscription;
  List<String> getmembers() {
    return [..._members];
  }

  checkLoading(bool check) {
    isLoading = check;
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
    snapshot.docs.forEach((user) {
      _members.add(user['Email']);
    });
    notifyListeners();
    // Then subscribe to real-time updates (skip the first snapshot to avoid duplicate work)
    _userSubscription = FirebaseFirestore.instance
        .collection('Users')
        .snapshots()
        .skip(1)
        .listen((event) {
      _members.clear();
      event.docs.forEach((user) {
        _members.add(user['Email']);
      });
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }
}
