import 'package:cloud_firestore/cloud_firestore.dart';

class NXB {
  static const ID = "id";
  static const NAME = "name";


  String name;
  String id;


  NXB({this.id, this.name});

  NXB.fromSnapshot(DocumentSnapshot snapshot){
    id = snapshot.data[ID];
    name = snapshot.data[NAME];
  }


}
