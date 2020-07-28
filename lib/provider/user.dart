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
  UserModel _userModel;

//  getter
  UserModel get userModel => _userModel;

  UserProvider.initialize() {
    loadUser();
  }

  loadUser() async {
    userList = await _userServices.getUsers();
    notifyListeners();
  }

  Future<bool> deleteUser({String uid}) async {
    try {
      _userServices.deleteUser(uid: uid);
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateUser({String uid, String name , String email}) async {
    try {
      _userServices.updateUser( uid : uid, name : name, email : email);
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

}
