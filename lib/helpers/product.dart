import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import '../models/products.dart';


class ProductServices {
  String collection = "products";
  Firestore _firestore = Firestore.instance;
  StorageReference firebaseStorageRef;

  void createProduct({String name, String image, String category, String author, String nxb, String description, String rating, String old_price, int price} ){
    var id = Uuid();
    String productId = id.v1();

    _firestore.collection(collection).document(productId).setData({'id': productId, 'name': name, 'image':image, 'category':category, 'author':author, 'nxb':nxb, 'description':description, 'rating':rating, 'old_price':old_price,'price':price });
  }

  void deleteProduct({String productId, String imageUrl}){
    _firestore.collection(collection).document(productId).delete();
    var fileUrl = Uri.decodeFull(path.basename(imageUrl)).replaceAll(new RegExp(r'(\?alt).*'), '');
    firebaseStorageRef  = FirebaseStorage.instance.ref().child(fileUrl);
    firebaseStorageRef.delete();
  }

  void updateProduct({String productId, String name, String image, String category, String author, String nxb, String description, String rating, String old_price, int price }){
    _firestore.collection(collection).document(productId).updateData({'name': name, 'image':image, 'category':category, 'author':author, 'nxb':nxb, 'description':description, 'rating':rating, 'old_price':old_price,'price':price});
  }


  Future<List<Product>> getProducts() async =>
      _firestore.collection(collection).getDocuments().then((result) {
        List<Product> products = [];
        for (DocumentSnapshot product in result.documents) {
          products.add(Product.fromSnapshot(product));
        }
        return products;
      });

  Future<List<Product>> getProductsById({String id}) async =>
      _firestore
          .collection(collection)
          .where("id", isEqualTo: id)
          .getDocuments()
          .then((result) {
        List<Product> products = [];
        for (DocumentSnapshot order in result.documents) {
          products.add(Product.fromSnapshot(order));
        }
        return products;
      });

  Future<List<Product>> getProductsOfCategory({String category}) async =>
      _firestore
          .collection(collection)
          .where("category", isEqualTo: category)
          .getDocuments()
          .then((result) {
        List<Product> products = [];
        for (DocumentSnapshot product in result.documents) {
          products.add(Product.fromSnapshot(product));
        }
        return products;
      });

  Future<List<Product>> getProductsOfRating({String rating}) async =>
      _firestore
          .collection(collection)
          .where("rating", isEqualTo: rating)
          .getDocuments()
          .then((result) {
        List<Product> products = [];
        for (DocumentSnapshot product in result.documents) {
          products.add(Product.fromSnapshot(product));
        }
        return products;
      });

  Future<List<Product>> searchProducts({String productName}) {
    // code to convert the first character to uppercase
    String searchKey = productName[0].toUpperCase() + productName.substring(1);
    return _firestore
        .collection(collection)
        .orderBy("name")
        .startAt([searchKey])
        .endAt([searchKey + '\uf8ff'])
        .getDocuments()
        .then((result) {
      List<Product> products = [];
      for (DocumentSnapshot product in result.documents) {
        products.add(Product.fromSnapshot(product));
      }
      return products;
    });
  }

}

