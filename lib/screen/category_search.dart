import 'package:admin_books_app/helpers/style.dart';
import 'package:admin_books_app/provider/app.dart';
import 'package:admin_books_app/provider/category.dart';
import 'package:admin_books_app/provider/product.dart';
import 'package:admin_books_app/widget/custom_text.dart';
import 'package:admin_books_app/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';


class CategoriesSearchScreen extends StatefulWidget {
  @override
  _CategoriesSearchScreenState createState() => _CategoriesSearchScreenState();
}

class _CategoriesSearchScreenState extends State<CategoriesSearchScreen> {
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final app = Provider.of<AppProvider>(context);
    categoryProvider.loadCategories();
    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "Danh mục",
          style: TextStyle(fontSize: 20),
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: app.isLoading
          ? Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Loading()],
        ),
      )
          : categoryProvider.searchedCategories.length < 1
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.search,
                color: grey,
                size: 30,
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomText(
                text: "No Categories Found",
                color: grey,
                weight: FontWeight.w300,
                size: 22,
              ),
            ],
          )
        ],
      )
          : ListView.builder(
          itemCount: categoryProvider.searchedCategories.length,
          itemBuilder: (BuildContext context, int index) {
            TextEditingController categoryController =TextEditingController(text: categoryProvider.searchedCategories[index].name);
            TextEditingController categoryImageController =TextEditingController(text: categoryProvider.searchedCategories[index].image);

            return Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: Padding(
                padding: EdgeInsets.fromLTRB(4, 4, 0, 4),
                child: Card(
                  child: Container(
                    height: 130,
                    decoration:
                    BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Colors.grey[300],
                          offset: Offset(-2, -1),
                          blurRadius: 5),
                    ]),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 130,
                          height: 130,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
                            child: Image.network(
                              categoryProvider.searchedCategories[index].image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                categoryProvider.searchedCategories[index].name,
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              secondaryActions: <Widget>[
                Container(
                  height: 130,
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
                                  height: 300,
                                  width: 400,
                                  child: Column(children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: categoryController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'category cannot be empty';
                                          }
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'name',
                                            hintText: "add name category"),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: categoryImageController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'category image cannot be empty';
                                          }
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'image',
                                            hintText: "add image category"),
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
                                                bool value = await categoryProvider.updateCategory(
                                                    categoryId: categoryProvider.searchedCategories[index].id,
                                                    name: categoryController.value.text,
                                                    image: categoryImageController.value.text);
                                                if (value) {
                                                  categoryProvider.loadCategories();
                                                  categoryProvider.search(name :categoryController.value.text.substring(0,1));
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
                  height: 130,
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
                                            'Bạn có muốn xóa danh mục không ?',
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
                                                bool value = await categoryProvider
                                                    .deleteCategory(
                                                    categoryId:categoryProvider.searchedCategories[index].id,
                                                    imageUrl: categoryImageController.value.text);
                                                if (value) {
                                                  categoryProvider.loadCategories();
                                                  categoryProvider.search(name :categoryController.value.text.substring(0,1));
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
                                                  print(
                                                      "ITEM WAS NOT REMOVED");
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
    );
  }
}

