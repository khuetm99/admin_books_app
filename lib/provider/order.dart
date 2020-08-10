import 'package:admin_books_app/helpers/order.dart';
import 'package:admin_books_app/models/order.dart';
import 'package:flutter/material.dart';
import '../helpers/category.dart';
import '../models/category.dart';

class OrderProvider with ChangeNotifier {
  OrderServices _orderServices = OrderServices();
  List<OrderModel> orderList = [];
  OrderModel _orderModel;
  int _totalSales = 0;

  OrderModel get orderModel => _orderModel ;
  int get totalSales => _totalSales;

  OrderProvider.initialize() {
    loadOrder();
  }

  loadOrder() async {
    orderList = await _orderServices.getOrders();
    notifyListeners();
  }

  getTotalSales() async {
    for (OrderModel order in orderList) {
          _totalSales = _totalSales + order.total;
    }
    _totalSales = _totalSales ;
    notifyListeners();
  }

}
