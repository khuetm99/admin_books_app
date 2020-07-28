import 'package:admin_books_app/provider/app.dart';
import 'package:admin_books_app/provider/user.dart';
import 'package:admin_books_app/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _key = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final app = Provider.of<AppProvider>(context);

    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "User List",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body : app.isLoading
          ? Loading()
          : SafeArea(
          child : ListView.builder(
              itemCount: user.userList.length,
              itemBuilder: (_,index){
                TextEditingController usernameController = TextEditingController(
                    text: user.userList[index].name);
                TextEditingController emailController = TextEditingController(
                    text: user.userList[index].email);


                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: Padding(
                      padding:  EdgeInsets.fromLTRB(4, 4, 0, 4),
                        child : Card(
                        child: Container(
                        height: 150,
                        decoration:
                              BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                              color: Colors.grey[300],
                              offset: Offset(-2, -1),
                              blurRadius: 5),
                              ]),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                color: user.userList[index].admin ? Colors.red[200] : Colors.lightBlueAccent,
                                child: Center(
                                  child: Text(
                                    user.userList[index].admin ? 'ADMIN' : 'CUSTOMER',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)
                                  ),
                                ),
                              ),
                              //TODO: id
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: <Widget>[
                                    Text('Display name : ', style: TextStyle(color : Colors.black, fontSize: 18,fontWeight: FontWeight.w500)),
                                    Text(user.userList[index].name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              //TODO : email
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: <Widget>[
                                    Text('Email : ', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
                                    Text(user.userList[index].email, style: TextStyle(fontSize: 16,)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                    secondaryActions: <Widget>[
                      Container(
                        height: 150,
                        child: IconSlideAction(
                          caption: 'Edit',
                          color: Colors.blueAccent,
                          icon: Icons.edit,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(15.0)),
                                        child: Container(
                                          height: 300,
                                          width: 420,
                                          child: Column(children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                controller: usernameController,
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return 'Name cannot be empty';
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                    labelText: 'Name',
                                                    hintText: "edit user name"),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                controller: emailController,
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return 'Name cannot be empty';
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                    labelText: 'Email',
                                                    hintText: "edit user email"),
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
                                                        bool value = await user.updateUser(
                                                            uid: user.userList[index].id,
                                                            name: usernameController.value.text,
                                                             email:  emailController.value.text
                                                        );
                                                        if (value) {
                                                          user.loadUser();
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
                                        ),
                                      );
                                });
                          },
                        ),
                      ),
                      Container(
                        height: 150,
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
                                                  'Bạn có muốn xóa user không ?',
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
                                                      bool value = await user
                                                          .deleteUser(
                                                          uid:
                                                          user.userList[index].id);
                                                      if (value) {
                                                        user.loadUser();
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
              })
      ),
    );
  }



}
