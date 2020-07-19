import 'package:admin_books_app/helpers/nxb.dart';
import 'package:admin_books_app/helpers/category.dart';
import 'package:admin_books_app/provider/category.dart';
import 'package:admin_books_app/provider/nxb.dart';
import 'package:admin_books_app/provider/product.dart';
import 'package:admin_books_app/screen/add_category.dart';
import 'package:admin_books_app/screen/category_page.dart';
import 'package:admin_books_app/screen/nxb_page.dart';
import 'package:admin_books_app/screen/product_page.dart';
import 'file:///D:/flutter_admin_app/admin_books_app/lib/screen/add_product.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

enum Page { dashboard, manage }

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  Page _selectedPage = Page.dashboard;
  MaterialColor active = Colors.red;
  MaterialColor notActive = Colors.grey;

//  =================================TEXT EDITING===============================
  TextEditingController categoryController = TextEditingController();
  TextEditingController categoryImageController = TextEditingController();
  TextEditingController NXBController = TextEditingController();

//  ====================================GLOBAL KEY=================================
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  GlobalKey<FormState> _nxbFormKey = GlobalKey();

//  ====================================SERVICE================================
  CategoryServices _categoryService = CategoryServices();
  NXBServices _nxbService = NXBServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.dashboard);
                      },
                      icon: Icon(
                        Icons.dashboard,
                        color: _selectedPage == Page.dashboard
                            ? active
                            : notActive,
                      ),
                      label: Text('Dashboard'))),
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.manage);
                      },
                      icon: Icon(
                        Icons.sort,
                        color:
                            _selectedPage == Page.manage ? active : notActive,
                      ),
                      label: Text('Manage'))),
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: _loadScreen()
    );
  }

  Widget _loadScreen() {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    categoryProvider.loadCategories();
    productProvider.loadProducts();
    switch (_selectedPage) {
      case Page.dashboard:
        return Column(
          children: <Widget>[
            ListTile(
              subtitle: FlatButton.icon(
                onPressed: null,
                icon: Icon(
                  Icons.attach_money,
                  size: 30.0,
                  color: Colors.green,
                ),
                label: Text('12,000',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.0, color: Colors.green)),
              ),
              title: Text(
                'Revenue',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, color: Colors.grey),
              ),
            ),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.people_outline),
                              label: Text("Users")),
                          subtitle: Text(
                            '7',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.category),
                              label: Text("Categories")),
                          subtitle: Text(
                            categoryProvider.categories.length.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.track_changes),
                              label: Text("Products")),
                          subtitle: Text(
                            productProvider.products.length.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.tag_faces),
                              label: Text("Sold")),
                          subtitle: Text(
                            '13',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.shopping_cart),
                              label: Text("Orders")),
                          subtitle: Text(
                            '5',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.close),
                              label: Text("Return")),
                          subtitle: Text(
                            '0',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        break;
      case Page.manage:
        return ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add product"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => AddProduct()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.change_history),
              title: Text("Products list"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => ProductPage()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text("Add category"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => AddCategory()));
//                  _categoryAlert();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.category),
              title: Text("Category list"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => CategoryPage()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text("Add NXB"),
              onTap: () {
               _NXBAlert();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text("NXB list"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => NXBPage()));
              },
            ),
            Divider(),
          ],
        );
        break;
      default:
        return Container();
    }
  }

  Widget _categoryAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _categoryFormKey,
        child: Container(
          height: 250,
          width: 300,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: categoryController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'category cannot be empty';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'name',
                  hintText: "add name category",
                ),
              ),
              TextFormField(
                controller: categoryImageController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'category image cannot be empty';
                  }
                },
                decoration: InputDecoration(
                    labelText: 'image', hintText: "add image category"),
              ),
              SizedBox(
                height: 45,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                      width: 100.0,
                      child: RaisedButton(
                        onPressed: () {
                          if (categoryController.text != null) {
                            print(categoryController.text);
                            _categoryService.createCategory(
                                name : categoryController.text,
                               image : categoryImageController.text);
                            Fluttertoast.showToast(msg: 'category created');
                          }
                        },
                        child: Text(
                          "Add",
                          style: TextStyle(color: Colors.white),
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
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.red,
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
    showDialog(context: context, builder: (_) => alert);
  }

  void _NXBAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _nxbFormKey,
        child: Container(
          height: 200,
          width: 300,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: NXBController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'NXB name cannot be empty';
                  }
                },
                decoration: InputDecoration(hintText: "add name NXB"),
              ),
              SizedBox(
                height: 45,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                      width: 100.0,
                      child: RaisedButton(
                        onPressed: () {
                          if (NXBController.text != null) {
                            _nxbService.createNXB(NXBController.text);
                          }
                          Fluttertoast.showToast(msg: 'NXB created');
                          NXBController.clear();
                        },
                        child: Text(
                          "Add",
                          style: TextStyle(color: Colors.white),
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
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.red,
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
    showDialog(context: context, builder: (_) => alert);
  }
}



