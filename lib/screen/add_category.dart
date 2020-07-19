import 'dart:io';

import 'package:admin_books_app/helpers/category.dart';
import 'package:admin_books_app/helpers/style.dart';
import 'package:admin_books_app/provider/app.dart';
import 'package:admin_books_app/provider/category.dart';
import 'package:admin_books_app/widget/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File _imageFile;
  CategoryServices _categoryServices = CategoryServices();
  TextEditingController categoryController = TextEditingController();
  String _imageUrl;

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final app = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        title: Text(
          "Add category",
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
          child:app.isLoading
              ? Loading()
              : Column(children: <Widget>[
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

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: categoryController,
                decoration: InputDecoration(hintText: 'Category name', labelText: 'Name'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'You must enter the category name';
                  }
                },
              ),
            ),
            FlatButton(
              color: red,
              textColor: white,
              child: Text('add category'),
              onPressed: () async{
                if (_formKey.currentState.validate()) {
                  if (_imageFile != null) {
                    setState(() {
                      app.isLoading = true;
                    });
                  String imageUrl;
                  final FirebaseStorage storage = FirebaseStorage.instance;
                  final String picture = "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
                  StorageUploadTask task = await storage.ref().child(picture).putFile(_imageFile);
                  StorageTaskSnapshot snapshot = await task.onComplete.then((snapshot) => snapshot);
                  imageUrl = await snapshot.ref.getDownloadURL();
                  _categoryServices.createCategory(name : categoryController.text, image: imageUrl);
                  _formKey.currentState.reset();
                    setState(() {
                      app.isLoading = false;
                    });

                  Fluttertoast.showToast(msg: 'Category added');
                  } else {
                    setState(() {
                      app.isLoading = false;
                    });
                    Fluttertoast.showToast(msg: 'the images must be provided');
                  }
                }
              },
            )
          ]),
        ),
      ),
    );
  }

  void _selectImage(Future<File> pickImage, int imageNumber) async {
    File tempImg = await pickImage;
    switch (imageNumber) {
      case 1:
        setState(() => _imageFile = tempImg);
        break;
    }
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

  void validateAndUpload() async{
    if (_formKey.currentState.validate()) {

      if (_imageFile != null) {
        String imageUrl;
        final FirebaseStorage storage = FirebaseStorage.instance;
        final String picture = "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
        StorageUploadTask task = await storage.ref().child(picture).putFile(_imageFile);
        StorageTaskSnapshot snapshot = await task.onComplete.then((snapshot) => snapshot);
        imageUrl = await snapshot.ref.getDownloadURL();

        _categoryServices.createCategory(name : categoryController.text, image: imageUrl);
        _formKey.currentState.reset();

        Fluttertoast.showToast(msg: 'Category added');
      } else {
        Fluttertoast.showToast(msg: 'the images must be provided');
      }
    }
  }

}
