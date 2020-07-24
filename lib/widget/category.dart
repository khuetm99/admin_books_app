import 'package:admin_books_app/models/category.dart';
import 'package:admin_books_app/provider/app.dart';
import 'package:admin_books_app/provider/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CategoryWidget extends StatefulWidget {
  final Category category;

  CategoryWidget({this.category});

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  final _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final app = Provider.of<AppProvider>(context);
    return  Card(
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
              width: 150,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                child: Image.network(
                  widget.category.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.category.name,
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
    );
  }
}
