import 'package:admin_books_app/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class CategoryServices{
  String collection = "categories";
  Firestore _firestore = Firestore.instance;
  StorageReference firebaseStorageRef;

  void createCategory({String name, String image}) async{
    var id = Uuid();
    String categoryId = id.v1();
    _firestore.collection(collection).document(categoryId).setData(
          {'id': categoryId, 'name': name, 'image': image});
  }


  void deleteCategory({String categoryId, String imageUrl}){
    _firestore.collection(collection).document(categoryId).delete();
    var fileUrl = Uri.decodeFull(path.basename(imageUrl)).replaceAll(new RegExp(r'(\?alt).*'), '');
     firebaseStorageRef  = FirebaseStorage.instance.ref().child(fileUrl);
     firebaseStorageRef.delete();
  }

  void updateCategory({String categoryId, String name, String image}){
    _firestore.collection(collection).document(categoryId).updateData({'id':categoryId,'name': name, 'image':image});
  }


  Future<List<Category>> getCategories() async =>
      _firestore.collection(collection).getDocuments().then((result) {
        List<Category> categories = [];
        for (DocumentSnapshot category in result.documents) {
          categories.add(Category.fromSnapshot(category));
        }
        return categories;
      });


  Future<List<Category>> searchCategory({String categoryName}) {
    // code to convert the first character to uppercase
    String searchKey = categoryName[0].toUpperCase() +
        categoryName.substring(1);
    return _firestore
        .collection(collection)
        .orderBy("name")
        .startAt([searchKey])
        .endAt([searchKey + '\uf8ff'])
        .getDocuments()
        .then((result) {
      List<Category> categories = [];
      for (DocumentSnapshot product in result.documents) {
        categories.add(Category.fromSnapshot(product));
      }
      return categories;
    });
  }



}