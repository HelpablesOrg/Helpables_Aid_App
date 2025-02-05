import 'package:aid_app/Providers/categories_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfoProvider with ChangeNotifier {
  bool isLoading = false;
  List<String> _members = [];
  bool isMemeber = false;
  List<String> getmembers() {
    return [..._members];
  }

  checkLoading(bool check) {
    isLoading = check;
  }

  memberCheck(String? email, BuildContext context) {
    if (_members.contains(email)) {
      isMemeber = true;
      Provider.of<CategoriesProvider>(context, listen: false).fetchCategories();
    } else {
      isMemeber = false;
    }
    notifyListeners();
  }

  Future<void> setUserDetails() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .snapshots()
        .listen((event) {
      event.docs.forEach((user) {
        _members.add(user['Email']);
      });
      notifyListeners();
    });
  }
}
