import 'package:admin_books_app/helpers/order.dart';
import 'package:admin_books_app/models/order.dart';
import 'package:flutter/material.dart';
import '../helpers/category.dart';
import '../models/category.dart';

class OrderProvider with ChangeNotifier {
  OrderServices _orderServices = OrderServices();
  List<OrderModel> orderList = [];
  OrderModel _orderModel;
  int total;

  OrderModel get orderModel => _orderModel ;

  OrderProvider.initialize() {
    loadOrder();
  }

  loadOrder() async {
    orderList = await _orderServices.getOrders();
    notifyListeners();
  }

}
