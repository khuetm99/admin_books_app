import 'package:cloud_firestore/cloud_firestore.dart';


class UserModel{
  static const ID = "id";
  static const NAME = "name";
  static const EMAIL = "email";
  static const STRIPE_ID = "stripeId";
  static const CART = "cart";
  static const FAVORITE = "favorite";
  static const ADMIN = "admin";

  String _name;
  String _email;
  String _id;
  String _stripeId;
  int _priceSum = 0;
  int _quantitySum = 0;

  bool _admin;

//  getters
  String get name => _name;
  String get email => _email;
  String get id => _id;
  String get stripeId => _stripeId;
  bool get admin => _admin;

//  public variable
  List cart;
  int totalCartPrice;
  List favorite;

  UserModel.fromSnapshot(DocumentSnapshot snapshot){
    _name = snapshot.data[NAME];
    _email = snapshot.data[EMAIL];
    _id = snapshot.data[ID];
    _admin = snapshot.data[ADMIN];
    _stripeId = snapshot.data[STRIPE_ID];
    cart = snapshot.data[CART] ?? [];
    favorite = snapshot.data[FAVORITE] ?? [];
  }

  int getTotalPrice({List cart}){
    if(cart == null){
      return 0;
    }
    for(Map cartItem in cart){
      _priceSum += cartItem["price"] * cartItem["quantity"];
    }

    int total = _priceSum;

    print("THE TOTAL IS $total");
    print("THE TOTAL IS $total");
    print("THE TOTAL IS $total");
    print("THE TOTAL IS $total");
    print("THE TOTAL IS $total");

    return total;
  }

// List<CartItemModel> _convertCartItems(List<Map> cart){
//    List<CartItemModel> convertedCart = [];
//    for(Map cartItem in cart){
//      convertedCart.add(CartItemModel.fromMap(cartItem));
//    }
//    return convertedCart;
//  }

}