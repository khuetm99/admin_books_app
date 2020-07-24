import 'package:admin_books_app/helpers/style.dart';
import 'package:admin_books_app/models/products.dart';
import 'package:admin_books_app/provider/app.dart';
import 'package:admin_books_app/provider/category.dart';
import 'package:admin_books_app/provider/nxb.dart';
import 'package:admin_books_app/provider/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class EditProductPage extends StatefulWidget {
  final Product product;
  EditProductPage({this.product});
  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<DropdownMenuItem<String>> categoriesDropDown =<DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> nxbDropDown = <DropdownMenuItem<String>>[];
  String _currentCategory;
  String _currentNXB;

  TextEditingController productNameController ;
  TextEditingController productImageController;
  TextEditingController productAuthorController;
  TextEditingController productPriceController;
  TextEditingController productOldPriceController;
  TextEditingController productRatingController;
  TextEditingController productDescriptionController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentCategory= widget.product.category;
    _currentNXB = widget.product.nxb;

    productNameController = TextEditingController( text:  widget.product.name);
    productImageController =TextEditingController( text:  widget.product.image);
    productAuthorController= TextEditingController( text:  widget.product.author);
    productPriceController =  TextEditingController(text:  widget.product.price.toString());
    productOldPriceController=   TextEditingController(text:  widget.product.old_price);
    productRatingController = TextEditingController( text:  widget.product.rating);
    productDescriptionController= TextEditingController( text:  widget.product.description);
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final nxbProvider = Provider.of<NXBProvider>(context);
    final app = Provider.of<AppProvider>(context);


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
        appBar: AppBar(
          elevation: 0.1,
          backgroundColor: white,
          title: Text(
            "Edit product",
            style: TextStyle(color: black),
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
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(

                child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: productImageController,
                      decoration: InputDecoration(hintText: 'Product asset image', labelText: 'Image'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'You must enter the product image';
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: productNameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'category cannot be empty';
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'Name',
                          hintText: "add name category"),
                    ),
                  ),
//===========================================  CATEGORY AND NXB ================================================
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Category: ',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      DropdownButton(
                          items: categoriesDropDown = getCategoriesDropdown(),
                          onChanged: changeSelectedCategory,
                          value: _currentCategory  ),
                    ],
                  ),

                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'NXB: ',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      DropdownButton(
                        items: nxbDropDown= getNXBDropdown(),
                        onChanged: changeSelectedNXB,
                        value: _currentNXB,
                      ),
                    ],
                  ),


                  //===========================================  AUTHOR ================================================

                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: productAuthorController,
                      decoration: InputDecoration(hintText: 'Product author', labelText: 'Author'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'You must enter the product author';
                        }
                      },
                    ),

                    //===========================================  DESCRIPTION ================================================
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: productDescriptionController,
                      maxLines: null,
                      textAlign: TextAlign.justify,
                      decoration: InputDecoration(hintText: 'Product description', labelText: 'Description'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'You must enter the product author';
                        }
                      },
                    ),
                  ),

//===========================================  RATING ================================================
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: productRatingController,
                      decoration: InputDecoration(hintText: 'Product rating', labelText: 'Rating'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'You must enter the product rating';
                        }
                      },
                    ),
                  ),

//===========================================  OLD PRICE ================================================
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: productOldPriceController,
                      decoration: InputDecoration(hintText: 'Product old price', labelText: 'Old price'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'You must enter the product old price';
                        }
                      },
                    ),
                  ),

//===========================================  PRICE ================================================
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: productPriceController,
                      decoration: InputDecoration(hintText: 'Product price', labelText: 'Price'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'You must enter the product price';
                        }
                      },
                    ),
                  ),

                  SizedBox(
                    height: 30,
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
                              bool value = await productProvider.updateProduct(
                                  productId: widget.product.id,
                                  name : productNameController.text,
                                  image : productImageController.text,
                                  category : _currentCategory,
                                  author : productAuthorController.text,
                                  nxb : _currentNXB,
                                  description :   productDescriptionController.text,
                                  rating :  productRatingController.text,
                                  old_price :  productOldPriceController.text,
                                  price : int.parse(productPriceController.text));
                              if (value) {
                                productProvider.loadProducts();
                                Fluttertoast.showToast(msg: 'Product edited');
                                app.changeLoading();
                                Navigator.pop(context);
                                return;
                              } else {
                                print(
                                    "ITEM WAS NOT Added");
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
            )
            ));
  }
  changeSelectedCategory(String selectedCategory) {
    setState(() => _currentCategory = selectedCategory);
  }

  changeSelectedNXB(String selectedNXB) {
    setState(() => _currentNXB = selectedNXB);
  }
}
