import 'package:admin_books_app/helpers/order.dart';
import 'package:admin_books_app/helpers/user.dart';
import 'package:admin_books_app/models/order.dart';
import 'package:admin_books_app/models/user.dart';
import 'package:flutter/material.dart';
import '../helpers/category.dart';
import '../models/category.dart';

class UserProvider with ChangeNotifier {
  UserServices _userServices = UserServices();
  List<UserModel> userList = [];


  UserProvider.initialize() {
    loadUser();
  }

  loadUser() async {
    userList = await _userServices.getUsers();
    notifyListeners();
  }

}
