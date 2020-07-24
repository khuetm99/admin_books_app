import 'package:cloud_firestore/cloud_firestore.dart';

class CartItemModel {
  static const ID = "id";
  static const NAME = "name";
  static const IMAGE = "image";
  static const PRODUCT_ID = "productId";
  static const QUANTITY = "quantity";
  static const PRICE = "price";

  String id;
  String name;
  String image;
  String productId;
  int quantity;
  int price;

  CartItemModel({this.id, this.name, this.image, this.productId, this.quantity,
      this.price});

  CartItemModel.fromMap(Map data){
    id = data[ID];
    name =  data[NAME];
    image =  data[IMAGE];
    productId = data[PRODUCT_ID];
    price = data[PRICE];
    quantity = data[QUANTITY];
  }

  Map toMap() => {
    ID: id,
    IMAGE: image,
    NAME: name,
    PRODUCT_ID: productId,
    QUANTITY: quantity,
    PRICE: price
  };


}
