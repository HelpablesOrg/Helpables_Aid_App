import 'package:flutter/material.dart';

class Category {
  final String id;
  final String title;

  final List<dynamic> subCategory;
  Category({
    required this.id,
    required this.title,
    required this.subCategory,
  });
}
