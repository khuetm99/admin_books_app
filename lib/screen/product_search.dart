import 'package:admin_books_app/provider/app.dart';
import 'package:admin_books_app/provider/category.dart';
import 'package:admin_books_app/provider/nxb.dart';
import 'package:admin_books_app/provider/product.dart';
import 'package:admin_books_app/screen/edit_product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ProductSearchScreen extends StatefulWidget {
  @override
  _ProductSearchScreenState createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final app = Provider.of<AppProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final nxbProvider = Provider.of<NXBProvider>(context);
    productProvider.loadProducts();

    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.close), onPressed: (){
          Navigator.pop(context);
        }),
        title: Text ("Products", style: TextStyle(fontSize: 20),),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: productProvider.productsSearched.length < 1? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.search, color: Colors.grey, size: 30,),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text( "No products Found", style : TextStyle (color: Colors.grey, fontWeight: FontWeight.w300, fontSize: 22,)),
            ],
          )
        ],
      ) : ListView.builder(
          itemCount: productProvider.productsSearched.length,
          itemBuilder: (BuildContext context, int index) {
            TextEditingController productImageController  =TextEditingController( text:  productProvider.productsSearched[index].image);

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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 150,
                                height: 150,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                  ),
                                  child: Image.network(
                                    productProvider.productsSearched[index].image,
                                    fit: BoxFit.cover,
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
                                            Expanded(child: Text(productProvider.productsSearched[index].name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
                                          ],
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: <Widget>[
                                              Text(productProvider.productsSearched[index].author, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text('Rating :', style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500)),
                                            Text(productProvider.productsSearched[index].rating, style: TextStyle(fontSize: 16,)),
                                          ],
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text('Danh mục : ', style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500 )),
                                              Text(productProvider.productsSearched[index].category, style: TextStyle(fontSize: 15 )),

                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text('Nhà xuất bản : ', style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500)),
                                            Expanded(child: Text(productProvider.productsSearched[index].nxb, style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400 ))),
                                          ],
                                        ),
                                        Expanded(
                                          child :Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text('Giá : ' + productProvider.productsSearched[index].price.toString() + 'vnđ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                                              Text(productProvider.productsSearched[index].old_price + 'vnđ', style: TextStyle(fontSize: 14 , decoration: TextDecoration.lineThrough)),
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
                                                productProvider.productsSearched[index].description.length > 200 ? productProvider.productsSearched[index].description.substring(0,170) + "..."
                                                    : productProvider.productsSearched[index].description
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditProductPage(product: productProvider.productsSearched[index],)));
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
                                                bool value = await productProvider.deleteProduct( productId: productProvider.productsSearched[index].id,
                                                    imageUrl: productImageController.value.text);
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
    );
  }
}
