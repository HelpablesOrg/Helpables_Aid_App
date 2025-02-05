import 'package:aid_app/Modal/subCategory.dart';
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

  void fetchChosenSubCategories(final subCategories, String id) {
    _items = [];
    try {
      for (var element in _categoryitems) {
        if (element.id == id) {
          element.subCategory.forEach((data) {
            _items.add(SubCategory(title: data, qty: 0));
          });
        }
      }
      for (int i = 0; i < subCategories.length; i++) {
        subCategories[i].forEach((key, value) {
          for (int j = 0; j < _items.length; j++) {
            if (_items[j].title == key) {
              _items[j].qty = value;
            }
          }
        });
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> fetchSubCategories(String id) async {
    try {
      List<SubCategory> loadedCategories = [];
      for (var element in _categoryitems) {
        if (element.title == id) {
          element.subCategory.forEach((item) {
            loadedCategories.add(SubCategory(title: item, qty: 0));
          });
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
        element.subCategory.forEach(
          (element) {
            subcategories.add(element);
          },
        );
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
        data.docs.forEach((element) {
          loadedCategories.add(Category(
            id: element['id'],
            title: element['Title'],
            icon: IconData(element['icon'], fontFamily: 'MaterialIcons'),
            subCategory: element['SubCategories'],
          ));
        });
        _categoryitems = loadedCategories;
      });

      notifyListeners();
      return _categoryitems;
    } catch (error) {
      rethrow;
    }
  }
}
