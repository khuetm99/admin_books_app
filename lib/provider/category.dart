import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../helpers/category.dart';
import '../models/category.dart';

class CategoryProvider with ChangeNotifier {
  CategoryServices _categoryServices = CategoryServices();
  List<Category> categories = [];
  List<Category> searchedCategories = [];

  CategoryProvider.initialize() {
    loadCategories();
  }

  loadCategories() async {
    categories = await _categoryServices.getCategories();
    notifyListeners();
  }

  Future<bool> deleteCategory({String categoryId, String imageUrl}) async {
    try {
      _categoryServices.deleteCategory(categoryId: categoryId, imageUrl: imageUrl);
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateCategory({String categoryId, String name , String image}) async {
    try {
      _categoryServices.updateCategory( categoryId : categoryId, name : name, image : image);
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future search({String name}) async {
    searchedCategories =
        await _categoryServices.searchCategory(categoryName: name);
    print("CATE ARE: ${searchedCategories.length}");
    notifyListeners();
  }
}
