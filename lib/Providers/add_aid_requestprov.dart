import 'package:aid_app/Modal/PlaceLocation.dart';
import 'package:aid_app/Modal/subCategory.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddAidRequestProvider with ChangeNotifier {
  static List<File> _imagesItems = [];
  List<File> get imagesItems {
    return [..._imagesItems];
  }

  String _title = '';
  static String _catId = '';
  String _description = '';
  PlaceLocation? _pickedLocation;
  List<Map<String, int>> subCategories = [];

  void addImage(List<File> imageFile) {
    _imagesItems.addAll(imageFile);
    notifyListeners();
  }

  static getCatId(String id, final categories) {
    for (int i = 0; i < categories.length; i++) {
      if (categories[i].id == id) {
        _catId = categories[i].id;
      }
    }
  }

  void getCategoryId(String id) {
    _catId = id;
    subCategories = [];
  }

  cleardata() {
    _title = '';
    _description = '';
    _catId = '';
    _pickedLocation = null;
    _imagesItems = [];
    subCategories = [];
  }

  void getSubCat(SubCategory subcategory) {
    if (subCategories.isEmpty && subcategory.qty > 0) {
      subCategories.add({subcategory.title: subcategory.qty});
    }
    for (int i = 0; i < subCategories.length; i++) {
      if (!subCategories[i].containsKey(subcategory.title) &&
          subcategory.qty > 0) {
        subCategories.add({subcategory.title: subcategory.qty});
      } else if (subCategories[i].containsKey(subcategory.title) &&
          subcategory.qty > 0) {
        subCategories
            .removeWhere((item) => item.containsKey(subcategory.title));

        subCategories.add({subcategory.title: subcategory.qty});
      }
      if (subcategory.qty == 0) {
        subCategories
            .removeWhere((item) => item.containsKey(subcategory.title));
      }
    }
  }

  void getTitle(String title) {
    _title = title;
  }

  void getDescription(String description) {
    _description = description;
  }

  void getLocation(PlaceLocation location) {
    _pickedLocation = location;
  }

  String validateRequestData() {
    if (_pickedLocation == null) {
      return "Please choose a location.";
    }
    if (_imagesItems.length == 0) {
      return "Please add at least one image.";
    }
    if (_catId == '') {
      return "Please select a category";
    }
    if (subCategories.length == 0) {
      return "Please add amount to at least one Sub-Category.";
    }
    return "true";
  }

  removeSubCategories() {
    subCategories = [];
  }

  static removeImages() {
    _imagesItems = [];
  }

  Future<void> addAidRequest() async {
    String userid = FirebaseAuth.instance.currentUser!.uid;

    List<String> imgUrls = [];
    int len = _imagesItems.length <= 5 ? _imagesItems.length : 5;

    for (int i = 0; i < len; i++) {
      var imagePath = _imagesItems[i].toString();
      var temp = imagePath.lastIndexOf('/');
      var result = imagePath.substring(temp + 1);
      final ref = FirebaseStorage.instanceFor(
              bucket: 'gs://aid-request-app.firebasestorage.app')
          .ref()
          .child('pictures')
          .child(result);
      await ref.putFile(_imagesItems[i]);
      var imgUrl = await ref.getDownloadURL();
      imgUrls.add(imgUrl);
    }
    imgUrls.length > 0
        ? FirebaseFirestore.instance.collection('AidRequestList').add({
            'Category Title': _catId,
            'title': _title,
            'description': _description,
            'imgUrls': imgUrls,
            'location': {
              'address': _pickedLocation!.address,
              'latitude': _pickedLocation!.latitude,
              'longitude': _pickedLocation!.longitude
            },
            'subCategories': subCategories,
            'owner': userid,
          })
        : null;
  }

  imagesToBeDeleted(int index) {
    _imagesItems.removeAt(index);

    notifyListeners();
  }
}
