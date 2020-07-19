import 'package:admin_books_app/helpers/nxb.dart';
import 'package:admin_books_app/models/nxb.dart';
import 'package:flutter/material.dart';


class NXBProvider with ChangeNotifier{
  NXBServices _nxbServices = NXBServices();
  List<NXB> nxbList = [];
  List<NXB> searchedNXB = [];

  NXBProvider.initialize(){
    loadNXB();
  }

  loadNXB()async{
    nxbList = await _nxbServices.getNXB();
    notifyListeners();
  }

  Future<bool> deleteNXB({String nxbId}) async {
    try {
      _nxbServices.deleteNXB(nxbId:nxbId );
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateNXB({String nxbId, String name}) async {
    try {
      _nxbServices.updateNXB( nxbId : nxbId, name : name);
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future search({String name}) async {
    searchedNXB =
    await _nxbServices.searchNXB(nxbName: name);
    print("NXB ARE: ${searchedNXB.length}");
    notifyListeners();
  }

}