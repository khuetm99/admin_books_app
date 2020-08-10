import 'package:admin_books_app/helpers/nxb.dart';
import 'package:admin_books_app/helpers/category.dart';
import 'package:admin_books_app/helpers/order.dart';
import 'package:admin_books_app/helpers/screen_navigation.dart';
import 'package:admin_books_app/provider/category.dart';
import 'package:admin_books_app/provider/nxb.dart';
import 'package:admin_books_app/provider/order.dart';
import 'package:admin_books_app/provider/product.dart';
import 'package:admin_books_app/provider/user.dart';
import 'package:admin_books_app/screen/add_category.dart';
import 'package:admin_books_app/screen/add_product.dart';
import 'package:admin_books_app/screen/category_page.dart';
import 'package:admin_books_app/screen/chart_page.dart';
import 'package:admin_books_app/screen/nxb_page.dart';
import 'package:admin_books_app/screen/order_page.dart';
import 'package:admin_books_app/screen/product_page.dart';
import 'package:admin_books_app/screen/user_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  int total = 0;



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
  OrderServices _orderServices = OrderServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryValues();
  }

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
    final orderProvider = Provider.of<OrderProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final nxbProvider = Provider.of<NXBProvider>(context);
    categoryProvider.loadCategories();
    productProvider.loadProducts();
    orderProvider.loadOrder();
    userProvider.loadUser();
    nxbProvider.loadNXB();
    switch (_selectedPage) {
      case Page.dashboard:
        return Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                changeScreen(context, ChartPage());
              },
              child : ListTile(
                subtitle: Text(
                    total.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},') + ' vnđ',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.0, color: Colors.green, fontWeight: FontWeight.w500)),
                title: Text(
                  'Revenue',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.0, color: Colors.grey),
                ),
              ),
            ),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: <Widget>[
                  GestureDetector(
                    onTap: () {changeScreen(context, UserPage());},
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Card(
                        child: ListTile(
                            title: FlatButton.icon(
                                onPressed: null,
                                icon: Icon(Icons.people_outline),
                                label: Text("Users")),
                            subtitle: Text(
                              userProvider.userList.length.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: active, fontSize: 60.0),
                            )),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {changeScreen(context, CategoryPage());},
                    child: Padding(
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
                  ),
                  GestureDetector(
                    onTap: () {changeScreen(context, ProductPage());},
                    child: Padding(
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
                  ),
                  GestureDetector(
                    onTap: () {changeScreen(context, NXBPage());},
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Card(
                        child: ListTile(
                            title: FlatButton.icon(
                                onPressed: null,
                                icon: Icon(Icons.tag_faces),
                                label: Text("NXB")),
                            subtitle: Text(
                              nxbProvider.nxbList.length.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: active, fontSize: 60.0),
                            )),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {changeScreen(context, OrderPage());},
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Card(
                        child: ListTile(
                            title: FlatButton.icon(
                                onPressed: null,
                                icon: Icon(Icons.shopping_cart),
                                label: Text("Orders")),
                            subtitle: Text(
                              orderProvider.orderList.length.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: active, fontSize: 60.0),
                            )),
                      ),
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



  void queryValues() {
    Firestore.instance
        .collection('orders')
        .snapshots()
        .listen((snapshot) {
      int tempTotal = snapshot.documents.fold(0, (tot, doc) => tot + doc.data['total']);
      setState(() {total = tempTotal;});
//      debugPrint(total.toString());
    });
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



