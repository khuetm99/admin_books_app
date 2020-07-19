import 'package:admin_books_app/helpers/screen_navigation.dart';
import 'package:admin_books_app/helpers/style.dart';
import 'package:admin_books_app/provider/app.dart';
import 'package:admin_books_app/provider/category.dart';
import 'package:admin_books_app/widget/CustomShapeClipper.dart';
import 'package:admin_books_app/widget/loading.dart';
import 'package:admin_books_app/widget/shimmer_category_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import 'category_search.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _key = GlobalKey<ScaffoldState>();
  Color firstColor = Color(0xFFF47D15);
  Color secondColor = Color(0xFFEF772C);

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final app = Provider.of<AppProvider>(context);
    categoryProvider.loadCategories();
    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor:Color(0xFFEF772C),
        elevation: 0.0,
        title: Text(
          "Category List",
          style: TextStyle(color: Colors.white),
        ),

        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.close, color: Colors.white,),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: Colors.white,
      body: app.isLoading
          ? ShimmerCategoryList()
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
                                await categoryProvider.search(name: pattern);
                                changeScreen(context, CategoriesSearchScreen());
                              },
                              decoration: InputDecoration(
                                hintText: "Tìm kiếm danh mục",
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
                            itemCount: categoryProvider.categories.length,
                            itemBuilder: (BuildContext context, int index) {
                              TextEditingController categoryController =TextEditingController(text: categoryProvider.categories[index].name);
                              TextEditingController categoryImageController =TextEditingController(text: categoryProvider.categories[index].image);
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
                                                categoryProvider.categories[index].image,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  categoryProvider.categories[index].name,
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
                                                                  categoryId: categoryProvider.categories[index].id,
                                                                  name: categoryController.value.text,
                                                                  image: categoryImageController.value.text);
                                                              if (value) {
                                                                categoryProvider.loadCategories();
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
                                                                          categoryId:
                                                                              categoryProvider
                                                                                  .categories[
                                                                                      index]
                                                                                  .id, imageUrl: categoryImageController.value.text);
                                                                  if (value) {
                                                                    categoryProvider
                                                                        .loadCategories();
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
                  ),
                ],
              ),
          ),
          );
  }
}
