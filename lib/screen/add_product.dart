import 'dart:io';
import 'package:admin_books_app/helpers/product.dart';
import 'package:admin_books_app/helpers/style.dart';
import 'package:admin_books_app/provider/app.dart';
import 'package:admin_books_app/provider/category.dart';
import 'package:admin_books_app/provider/nxb.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File _imageFile;
  TextEditingController productNameController = TextEditingController();
  TextEditingController productAuthorController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productOldPriceController = TextEditingController();
  TextEditingController productRatingController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController productImageController = TextEditingController();

  ProductServices _productServices = ProductServices();

  List<DropdownMenuItem<String>> categoriesDropDown =<DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> nxbDropDown = <DropdownMenuItem<String>>[];
  String _currentCategory;
  String _currentNXB;

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
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
          "Add product",
          style: TextStyle(color: black),
        ),
        centerTitle: true,
        leading:  IconButton(
          icon: Icon(Icons.close, color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          }),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
//===========================================IMAGE================================================
              Row(children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                        borderSide:
                        BorderSide(color: grey.withOpacity(0.5), width: 2.5),
                        onPressed: () {
                          _selectImage(
                              ImagePicker.pickImage(source: ImageSource.gallery),
                              1);
                        },
                        child: _displayChild()),
                  ),
                ),
              ]),

//===========================================  NAME ================================================

              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Enter a product name with 100 characters at maximum',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: red, fontSize: 12),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: productNameController,
                  decoration: InputDecoration(hintText: 'Product name'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'You must enter the product name';
                    } else if (value.length > 100) {
                      return 'Product name cant have more than 10 letters';
                    }
                  },
                ),
              ),

//===========================================  CATEGORY AND NXB ================================================
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Category: ',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                  DropdownButton(
                      items: categoriesDropDown = getCategoriesDropdown(),
                      onChanged: changeSelectedCategory,
                      value: _currentCategory),
                ],
              ),

              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12.0),
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
                  decoration: InputDecoration(hintText: 'Product author'),
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
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
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

              SizedBox(height: 10,),

              Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xffff5f6d),
                      Color(0xffff5f6d),
                      Color(0xffffc371),
                    ],
                  ),
                ),
                child: FlatButton(
                  textColor: white,
                  child: Text('Add product'),
                  onPressed: () async{
                    if (_formKey.currentState.validate())
                    {
                     if(_imageFile  != null ){
                       setState(() {
                         app.isLoading = true;
                       });
                       String imageUrl;
                       final FirebaseStorage storage = FirebaseStorage.instance;
                       final String picture = "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
                       StorageUploadTask task = await storage.ref().child(picture).putFile(_imageFile);
                       StorageTaskSnapshot snapshot = await task.onComplete.then((snapshot) => snapshot);
                       imageUrl = await snapshot.ref.getDownloadURL();

                       _productServices.createProduct(
                        name :productNameController.text,
                        image :   imageUrl,
                        category : _currentCategory,
                        author : productAuthorController.text,
                        nxb : _currentNXB,
                        description : productDescriptionController.text,
                        rating : productRatingController.text,
                        old_price : productOldPriceController.text,
                        price : int.parse(productPriceController.text));

                       _formKey.currentState.reset();
                       setState(() {
                         app.isLoading = false;
                       });
                    Fluttertoast.showToast(msg: 'product created');
                    }else {
                       setState(() {
                         app.isLoading = false;
                       });
                      Fluttertoast.showToast(msg: 'Added fail');
                    }}
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _displayChild() {
    if (_imageFile == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 70, 14, 50),
        child: new Icon(
          Icons.add,
          color: Colors.grey,
        ),
      );
    } else {
      return Image.file(
        _imageFile,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  void _selectImage(Future<File> pickImage, int imageNumber) async {
    File tempImg = await pickImage;
    switch (imageNumber) {
      case 1:
        setState(() => _imageFile = tempImg);
        break;
    }
  }
  changeSelectedCategory(String selectedCategory) {
    setState(() => _currentCategory = selectedCategory);
  }

  changeSelectedNXB(String selectedNXB) {
    setState(() => _currentNXB = selectedNXB);
  }


}
