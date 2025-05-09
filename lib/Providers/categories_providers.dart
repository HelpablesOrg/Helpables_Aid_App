import '../Modal/subCategory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Modal/Category.dart';

class CategoriesProvider with ChangeNotifier {
  List<SubCategory> _items = [];
  List<SubCategory> get items {
    return [..._items];
  }

  List<Category> _categoryitems = [];
  List<Category> get categoryitems {
    List<Category> temp = _categoryitems;
    temp.sort((a, b) => a.title.compareTo(b.title));
    _categoryitems = temp;
    return [..._categoryitems];
  }

  clearLists() {
    _items = [];
  }

  Future<void> fetchSubCategories(String id) async {
    try {
      List<SubCategory> loadedCategories = [];
      for (var element in _categoryitems) {
        if (element.title == id) {
          for (var item in element.subCategory) {
            loadedCategories.add(SubCategory(title: item, qty: 0));
          }
        }
      }
      _items = loadedCategories;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<String> getCategory() {
    List<String> categories = [];
    for (var element in _categoryitems) {
      categories.add(element.id);
    }
    return categories;
  }

  List<String> getSubCategory(String id) {
    List<String> subcategories = [];

    for (var element in _categoryitems) {
      if (element.title == id) {
        for (var element in element.subCategory) {
            subcategories.add(element);
          }
      }
    }

    return subcategories;
  }

  String getCatTitle(String id) {
    for (int i = 0; i < categoryitems.length; i++) {
      if (_categoryitems[i].title == id || _categoryitems[i].id == id) {
        return _categoryitems[i].title;
      }
    }
    return 'null';
  }

  Future<List<Category>> fetchCategories() async {
    try {
      _categoryitems = [];
      FirebaseFirestore.instance
          .collection('/Categories')
          .snapshots()
          .listen((data) {
        List<Category> loadedCategories = [];
        for (var element in data.docs) {
          loadedCategories.add(Category(
            id: element['id'],
            title: element['Title'],
            subCategory: element['SubCategories'],
          ));
        }
        _categoryitems = loadedCategories;
      });

      notifyListeners();
      return _categoryitems;
    } catch (error) {
      rethrow;
    }
  }
}
