import 'package:admin_books_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices {
  String collection = "users";
  Firestore _firestore = Firestore.instance;

  Future<List<UserModel>> getUsers() async =>
      _firestore.collection(collection).getDocuments().then((result) {
        List<UserModel> users = [];
        for (DocumentSnapshot category in result.documents) {
          users.add(UserModel.fromSnapshot(category));
        }
        return users;
      });

}