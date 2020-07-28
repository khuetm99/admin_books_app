import 'package:admin_books_app/helpers/screen_navigation.dart';
import 'package:admin_books_app/helpers/style.dart';
import 'package:admin_books_app/provider/app.dart';
import 'package:admin_books_app/provider/category.dart';
import 'package:admin_books_app/provider/nxb.dart';
import 'package:admin_books_app/provider/product.dart';
import 'package:admin_books_app/screen/edit_product_page.dart';
import 'package:admin_books_app/screen/product_search.dart';
import 'package:admin_books_app/widget/CustomShapeClipper.dart';
import 'package:admin_books_app/widget/loading.dart';
import 'package:admin_books_app/widget/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _key = GlobalKey<ScaffoldState>();
  Color firstColor = Color(0xFFF47D15);
  Color secondColor = Color(0xFFEF772C);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final app = Provider.of<AppProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final nxbProvider = Provider.of<NXBProvider>(context);
    productProvider.loadProducts();

    List<DropdownMenuItem<String>> getCategoriesDropdown() {
      List<DropdownMenuItem<String>> items = new List();
      for (int i = 0; i < categoryProvider.categories.length; i++) {
        setState(() {
          items.insert(
              0,
              DropdownMenuItem(
                  child: Text(categoryProvider.categories[i].name),
                  value: categoryProvider.categories[i].name));
        });
      }
      return items;
    }

    List<DropdownMenuItem<String>> getNXBDropdown() {
      List<DropdownMenuItem<String>> items = new List();
      for (int i = 0; i < nxbProvider.nxbList.length; i++) {
        setState(() {
          items.insert(
              0,
              DropdownMenuItem(
                  child: Text(nxbProvider.nxbList[i].name),
                  value: nxbProvider.nxbList[i].name));
        });
      }
      return items;
    }

    return Scaffold(
        key: _key,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor:Color(0xFFEF772C),
          elevation: 0.0,
          title: Text(
            "Product List",
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
                                await productProvider.search(productName: pattern);
                                changeScreen(context, ProductSearchScreen());
                              },
                              decoration: InputDecoration(
                                hintText: "Tìm kiếm sản phẩm",
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
                        itemCount: productProvider.products.length,
                        itemBuilder: (BuildContext context, int index) {
                          TextEditingController productImageController  =TextEditingController( text:  productProvider.products[index].image);

                          return Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(4, 4, 0, 4),
                                  child: Card(
                                      child: Container(
                                    height: 300,
                                    decoration:
                                        BoxDecoration(color: Colors.white, boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[300],
                                          offset: Offset(-2, -1),
                                          blurRadius: 5),
                                    ]),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                          Container(
                                          width: 150,
                                          height: 180,
                                          child: ClipRRect(
//                                            borderRadius: BorderRadius.only(
//                                              bottomLeft: Radius.circular(20),
//                                              topLeft: Radius.circular(20),
//                                            ),
                                            child: Stack(
                                              children: <Widget>[
                                                Positioned.fill(child: Align(
                                                  alignment: Alignment.center,
                                                  child:  Shimmer.fromColors(
                                                    highlightColor: Colors.white,
                                                    baseColor: Colors.grey[300],
                                                    child: ShimmerProductImage(),
                                                    period: Duration(milliseconds: 800),
                                                  ),
                                                )),
                                                Image.network(
                                                  productProvider.products[index].image,
                                                  width: 150,
                                                  height: 180,
                                                  fit: BoxFit.cover,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                            Expanded(
                                                child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(height: 2,),
                                                Row(
                                                  children: <Widget>[
                                                    Expanded(child: Text(productProvider.products[index].name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
                                                  ],
                                                ),
                                                  Expanded(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text(productProvider.products[index].author, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text('Rating :', style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500)),
                                                      Text(productProvider.products[index].rating, style: TextStyle(fontSize: 16,)),
                                                    ],
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: <Widget>[
                                                        Text('Danh mục : ', style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500 )),
                                                        Text(productProvider.products[index].category, style: TextStyle(fontSize: 15 )),

                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text('Nhà xuất bản : ', style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500)),
                                                      Expanded(child: Text(productProvider.products[index].nxb, style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400 ))),
                                                    ],
                                                  ),
                                                  Expanded(
                                                  child :Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Text('Giá : ' + productProvider.products[index].price.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},') + 'vnđ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                                                      Text(productProvider.products[index].old_price.replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},') + 'vnđ', style: TextStyle(fontSize: 14 , decoration: TextDecoration.lineThrough)),
                                                    ],
                                                  ),),
                                                  Row(
                                                    children: <Widget>[
                                                      Text('Mô tả sách :', style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500))
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Text(
                                                           productProvider.products[index].description.length > 200 ? productProvider.products[index].description.substring(0,170) + "..."
                                                                : productProvider.products[index].description
                                                            , style: TextStyle(fontSize: 14,),
                                                          textAlign: TextAlign.justify,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 2,),
                                                ]
                                            ))
                                          ]),
                                  ))),
                            secondaryActions: <Widget>[
                              Container(
                                height: 300,
                                child: IconSlideAction(
                                  caption: 'Edit',
                                  color: Colors.blueAccent,
                                  icon: Icons.edit,
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProductPage(product: productProvider.products[index],)));
                                  },
                                ),
                              ),
                              Container(
                                height: 300,
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
                                                          'Bạn có muốn xóa sản phẩm không ?',
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
                                                              bool value = await productProvider.deleteProduct( productId: productProvider.products[index].id,
                                                                  imageUrl: productImageController.value.text);
                                                              if (value) {
                                                                productProvider.loadProducts();
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
            ));
  }


}
