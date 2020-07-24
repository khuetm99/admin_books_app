import 'package:admin_books_app/helpers/style.dart';
import 'package:admin_books_app/models/order.dart';
import 'package:admin_books_app/widget/custom_text.dart';
import 'package:flutter/material.dart';

class OderDetailPage extends StatefulWidget {
  final OrderModel order;

  OderDetailPage({@required this.order});

  @override
  _OderDetailPageState createState() => _OderDetailPageState();
}

class _OderDetailPageState extends State<OderDetailPage> {
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        elevation: 0.0,
        title: CustomText(
          text: "Order Details",
          color: Colors.black,
        ),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Row(
              children: <Widget>[
                CustomText(
                  text: 'Mã đơn hàng : ',
                  weight: FontWeight.w300,
                  size: 14,
                ),
                CustomText(
                  text: widget.order.id,
                  size: 14,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(4, 4, 0, 4),
            child: Card(
              child: Container(
                height: 180,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.grey[300],
                      offset: Offset(-2, -1),
                      blurRadius: 5),
                ]),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            widget.order.description,
                            style: TextStyle(fontSize: 19, color: Colors.deepOrange),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          CustomText(text: 'Ngày xác nhận : '),
                          Text(DateTime.fromMillisecondsSinceEpoch(
                                  widget.order.createdAt)
                              .toString()),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          CustomText(
                            text: 'Tổng tiền thanh toán : ',
                            size: 16,
                          ),
                          CustomText(
                            text:
                                "${widget.order.total.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ",
                            weight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          CustomText(
                            text: 'Trạng thái đơn hàng : ',
                            size: 16,
                          ),
                          CustomText(
                            text: widget.order.status,
                            color: green,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Row(
              children: <Widget>[
                CustomText(
                  text: 'Sản phẩm đã đặt : ',
                  weight: FontWeight.w300,
                  size: 14,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: widget.order.cart.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: white,
                          boxShadow: [
                            BoxShadow(
                                color: red.withOpacity(0.2),
                                offset: Offset(3, 2),
                                blurRadius: 30)
                          ]),
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
                            child: Image.network(
                              widget.order.cart[index]["image"],
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: widget.order.cart[index]
                                                  ["name"] +
                                              "\n",
                                          style: TextStyle(
                                              color: black,
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text:
                                              "${widget.order.cart[index]["price"].toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ\n\n",
                                          style: TextStyle(
                                              color: black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300)),
                                      TextSpan(
                                          text: "Quantity: ",
                                          style: TextStyle(
                                              color: grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400)),
                                      TextSpan(
                                          text: widget
                                              .order.cart[index]["quantity"]
                                              .toString(),
                                          style: TextStyle(
                                              color: primary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400)),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
