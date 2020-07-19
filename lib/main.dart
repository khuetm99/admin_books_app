import 'package:admin_books_app/provider/app.dart';
import 'package:admin_books_app/provider/category.dart';
import 'package:admin_books_app/provider/nxb.dart';
import 'package:admin_books_app/provider/product.dart';
import 'package:flutter/material.dart';
import 'file:///D:/flutter_admin_app/admin_books_app/lib/screen/admin.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AppProvider()),
//            ChangeNotifierProvider.value(value: UserProvider.initialize()),
        ChangeNotifierProvider.value(value: CategoryProvider.initialize()),
        ChangeNotifierProvider.value(value: NXBProvider.initialize()),
        ChangeNotifierProvider.value(value: ProductProvider.initialize()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Admin(),
      )));
}
