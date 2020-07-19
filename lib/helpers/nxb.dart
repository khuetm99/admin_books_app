import 'package:admin_books_app/models/nxb.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class NXBServices{
  String collection = 'nxb';
  Firestore _firestore = Firestore.instance;

  void createNXB(String name){
    var id = Uuid();
    String nxbId = id.v1();

    _firestore.collection(collection).document(nxbId).setData({'id' : nxbId ,'name': name});
  }

  void deleteNXB({String nxbId}){
    _firestore.collection(collection).document(nxbId).delete();

  }

  void updateNXB({String nxbId, String name}){
    _firestore.collection(collection).document(nxbId).updateData({'id':nxbId,'name': name});
  }

  Future<List<NXB>> getNXB() async =>
      _firestore.collection(collection).getDocuments().then((result) {
        List<NXB> nxbList = [];
        for (DocumentSnapshot category in result.documents) {
          nxbList.add(NXB.fromSnapshot(category));
        }
        return nxbList;
      });

  Future<List<NXB>> searchNXB({String nxbName}) {
    // code to convert the first character to uppercase
    String searchKey = nxbName[0].toUpperCase() +
        nxbName.substring(1);
    return _firestore
        .collection(collection)
        .orderBy("name")
        .startAt([searchKey])
        .endAt([searchKey + '\uf8ff'])
        .getDocuments()
        .then((result) {
      List<NXB> nxbList = [];
      for (DocumentSnapshot product in result.documents) {
        nxbList.add(NXB.fromSnapshot(product));
      }
      return nxbList;
    });
  }

}