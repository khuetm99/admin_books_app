import 'package:cloud_firestore/cloud_firestore.dart';


class Product {
  static const ID = "id";
  static const AUTHOR = "author";
  static const NAME = "name";
  static const RATING = "rating";
  static const NXB = "nxb";
  static const IMAGE = "image";
  static const PRICE = "price";
  static const OLD_PRICE = "old_price";
  static const DESCRIPTION = "description";
  static const CATEGORY = "category";

//  String _id;
//  String _name;
//  String _author;
//  String _category;
//  String _image;
//  String _description;
//  String _nxb;
//
//  double _rating;
//  String _price;
//  String _old_price;

  String id;
  String name;
  String author;
  String category;
  String image;
  String description;
  String nxb;

  String old_price;
  String rating;

  int price;

    Product({this.id, this.name,this.author, this.category, this.image, this.description,
      this.nxb, this.rating, this.price, this.old_price});


  Product.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.data[ID];
    author = snapshot.data[AUTHOR];
    image = snapshot.data[IMAGE];
    description = snapshot.data[DESCRIPTION];
    price = snapshot.data[PRICE];
    category = snapshot.data[CATEGORY];
    rating = snapshot.data[RATING];
    name = snapshot.data[NAME];
    nxb = snapshot.data[NXB];
    old_price = snapshot.data[OLD_PRICE];
  }

  Map toMap() => {
    ID : id,
    AUTHOR : author,
    IMAGE : image,
    DESCRIPTION : description,
    PRICE : price,
    CATEGORY : category,
    RATING : rating,
    NAME : name,
    NXB : nxb,
    OLD_PRICE : old_price,
  };

}
