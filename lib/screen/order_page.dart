import 'package:admin_books_app/helpers/screen_navigation.dart';
import 'package:admin_books_app/helpers/style.dart';
import 'package:admin_books_app/models/order.dart';
import 'package:admin_books_app/provider/app.dart';
import 'package:admin_books_app/provider/order.dart';
import 'package:admin_books_app/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin_books_app/widget/order_detail.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final app = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        elevation: 0.0,
        title: CustomText(text: "Orders"),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
        centerTitle: true,
      ),
      backgroundColor: white,
      body: ListView.builder(
          itemCount: orderProvider.orderList.length,
          itemBuilder: (_, index){
            OrderModel _order = orderProvider.orderList[index];
            return GestureDetector(
              onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => OderDetailPage(order: _order,)));},
              child: ListTile(
                leading: CustomText(
                  text: "${_order.total.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ",
                  weight: FontWeight.bold,
                ),
                title: Text(_order.description),
                subtitle: Text(DateTime.fromMillisecondsSinceEpoch(_order.createdAt).toString()),
                trailing: CustomText(text: _order.status, color: green,),
              ),
            );
          }),
    );
  }
}
