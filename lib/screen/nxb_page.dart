import 'package:admin_books_app/helpers/screen_navigation.dart';
import 'package:admin_books_app/helpers/style.dart';
import 'package:admin_books_app/provider/app.dart';
import 'package:admin_books_app/provider/nxb.dart';
import 'package:admin_books_app/screen/nxb_search.dart';
import 'package:admin_books_app/widget/CustomShapeClipper.dart';
import 'package:admin_books_app/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class NXBPage extends StatefulWidget {
  @override
  _NXBPageState createState() => _NXBPageState();
}

class _NXBPageState extends State<NXBPage> {
  final _key = GlobalKey<ScaffoldState>();
  Color firstColor = Color(0xFFF47D15);
  Color secondColor = Color(0xFFEF772C);

  @override
  Widget build(BuildContext context) {
    final nxbProvider = Provider.of<NXBProvider>(context);
    final app = Provider.of<AppProvider>(context);
    nxbProvider.loadNXB();
    return Scaffold(
        key: _key,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor:Color(0xFFEF772C),
          elevation: 0.0,
          title: Text(
            "Nxb List",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.close, color: white,),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        backgroundColor: Colors.white,
        body: app.isLoading
            ? Loading()
            : SafeArea(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      ClipPath(
                        clipper: CustomShapeClipper(),
                        child: Container(
                          height: 135,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [firstColor, secondColor],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8, left: 8, right: 10, bottom: 9),
                        child: Container(
                          height: 51,
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.search,
                              color: red,
                            ),
                            title: TextField(
                              textInputAction: TextInputAction.search,
                              onSubmitted: (pattern)async{
                                await nxbProvider.search(name: pattern);
                                changeScreen(context, NXBSearchScreen());
                              },
                              decoration: InputDecoration(
                                hintText: "Tìm kiếm nhà xuất bản",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: nxbProvider.nxbList.length,
                        itemBuilder: (BuildContext context, int index) {
                          TextEditingController nxbController = TextEditingController(
                              text: nxbProvider.nxbList[index].name);
                          return Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(4, 4, 0, 4),
                                  child: Card(
                                      child: Container(
                                    height: 80,
                                    decoration:
                                        BoxDecoration(color: Colors.white, boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[300],
                                          offset: Offset(-2, -1),
                                          blurRadius: 5),
                                    ]),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    nxbProvider.nxbList[index].name,
                                                    style: TextStyle(
                                                        fontSize: 23,
                                                        color: Colors.black87,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                  ))),
                            secondaryActions: <Widget>[
                              Container(
                                height: 80,
                                child: IconSlideAction(
                                  caption: 'Edit',
                                  color: Colors.blueAccent,
                                  icon: Icons.edit,
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                              child: Container(
                                                height: 200,
                                                width: 400,
                                                child: Column(children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: TextFormField(
                                                      controller: nxbController,
                                                      validator: (value) {
                                                        if (value.isEmpty) {
                                                          return 'Name cannot be empty';
                                                        }
                                                      },
                                                      decoration: InputDecoration(
                                                          labelText: 'Name',
                                                          hintText: "add name nxb"),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 45,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceEvenly,
                                                    children: <Widget>[
                                                      SizedBox(
                                                          width: 100.0,
                                                          child: RaisedButton(
                                                            onPressed: () async{
                                                              app.changeLoading();
                                                              bool value = await nxbProvider.updateNXB(
                                                                  nxbId: nxbProvider.nxbList[index].id,
                                                                  name: nxbController.value.text);
                                                              if (value) {
                                                                nxbProvider.loadNXB();
                                                                _key.currentState
                                                                    .showSnackBar(
                                                                    SnackBar(
                                                                      content:
                                                                      Text("Updated !"),
                                                                      duration: Duration(
                                                                          milliseconds: 4000),
                                                                    ));
                                                                app.changeLoading();
                                                                Navigator.pop(context);
                                                                return;
                                                              } else {
                                                                print(
                                                                    "ITEM WAS NOT REMOVED");
                                                                app.changeLoading();
                                                              }
                                                            },
                                                            child: Text(
                                                              "Update",
                                                              style: TextStyle(
                                                                  color: Colors.white),
                                                            ),
                                                            color: const Color(0xFF1BC0C5),
                                                          )),
                                                      SizedBox(
                                                          width: 100.0,
                                                          child: RaisedButton(
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            child: Text(
                                                              "Cancel",
                                                              style: TextStyle(
                                                                  color: Colors.white),
                                                            ),
                                                            color: Colors.red,
                                                          ))
                                                    ],
                                                  ),
                                                ]),
                                              ));
                                        });
                                  },
                                ),
                              ),
                              Container(
                                height: 80,
                                child: IconSlideAction(
                                  caption: 'Delete',
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () async {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(20.0)),
                                              child: Container(
                                                  height: 250,
                                                  width: 350,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          'Bạn có muốn xóa nhà xuất bản không ?',
                                                          style: TextStyle(fontSize: 16),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        SizedBox(
                                                          width: 200.0,
                                                          child: RaisedButton(
                                                            onPressed: () async {
                                                              app.changeLoading();
                                                              bool value = await nxbProvider
                                                                  .deleteNXB(
                                                                  nxbId:
                                                                  nxbProvider.nxbList[index].id);
                                                              if (value) {
                                                                nxbProvider.loadNXB();
                                                                _key.currentState
                                                                    .showSnackBar(
                                                                    SnackBar(
                                                                      content:
                                                                      Text("Removed !"),
                                                                      duration: Duration(
                                                                          milliseconds: 4000),
                                                                    ));
                                                                app.changeLoading();
                                                                Navigator.pop(context);
                                                                return;
                                                              } else {
                                                                print( "ITEM WAS NOT REMOVED");
                                                                app.changeLoading();
                                                              }
                                                            },
                                                            child: Text(
                                                              "Accept",
                                                              style: TextStyle(
                                                                  color: Colors.white),
                                                            ),
                                                            color:
                                                            const Color(0xFF1BC0C5),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            width: 200.0,
                                                            child: RaisedButton(
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                              },
                                                              child: Text(
                                                                "Reject",
                                                                style: TextStyle(
                                                                    color: Colors.white),
                                                              ),
                                                              color: Colors.red,
                                                            ))
                                                      ])));
                                        });
                                  },
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                ],
              ),
            ));
  }
}
