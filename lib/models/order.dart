import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel{
  static const ID = "id";
  static const DESCRIPTION = "description";
  static const CART = "cart";
  static const USER_ID = "userId";
  static const TOTAL = "total";
  static const STATUS = "status";
  static const CREATED_AT = "createdAt";

  String id;
  String description;
  String userId;
  String status;
  int createdAt;
  int total;

  // public variable
  List cart;
  int totalOrderPrice;


  OrderModel.fromSnapshot(DocumentSnapshot snapshot){
    id = snapshot.data[ID];
    description = snapshot.data[DESCRIPTION];
    total = snapshot.data[TOTAL];
    status = snapshot.data[STATUS];
    userId = snapshot.data[USER_ID];
    createdAt = snapshot.data[CREATED_AT];
    cart = snapshot.data[CART];
  }


}