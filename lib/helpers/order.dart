import 'package:admin_books_app/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderServices{
  String collection = "orders";
  Firestore _firestore = Firestore.instance;

int GetToTal() {
  int total= 0;
  _firestore.collection(collection).getDocuments().then((result) {
    for (DocumentSnapshot order in result.documents) {
      total += order.data['total'];
    }
  });
  return total;
}

  Future<List<OrderModel>> getOrders() async =>
      _firestore
          .collection(collection)
          .getDocuments()
          .then((result) {
        List<OrderModel> orders = [];
        for (DocumentSnapshot order in result.documents) {
          orders.add(OrderModel.fromSnapshot(order));
        }
        return orders;
      });

}