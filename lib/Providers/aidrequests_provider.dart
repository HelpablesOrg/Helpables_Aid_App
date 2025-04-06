import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helpables/Modal/AidRequestList.dart';

class AidRequestsProvider with ChangeNotifier {
  List<AidRequest> aid_requests = [];
  List<AidRequest> getRequestsList() {
    return [...aid_requests];
  }

  Future<void> fetchAidRequests() async {
    try {
      FirebaseFirestore.instance
          .collection('/AidRequestList')
          .snapshots()
          .listen((data) {
        List<AidRequest> loadedaidrequests = [];
        for (var element in data.docs) {
          loadedaidrequests.add(AidRequest(
            description: element['description'],
            imgUrls: element['imgUrls'],
            location: element['location'],
            owner: element['owner'],
            subCategories: element['subCategories'],
            title: element['title'],
            CategoryTitle: element['Category Title'],
          ));
        }
        aid_requests = loadedaidrequests;
      });

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
