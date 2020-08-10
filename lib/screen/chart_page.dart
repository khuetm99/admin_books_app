import 'package:admin_books_app/models/order.dart';
import 'package:admin_books_app/provider/order.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChartPage extends StatefulWidget {
  ChartPage() : super();
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    orderProvider.loadOrder();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          backgroundColor: Colors.white,
          bottom: TabBar(
            indicatorColor: Color(0xff9962D0),
            tabs: [
              Tab(icon: Icon(Icons.multiline_chart, color: Colors.blueGrey,)),
              Tab(
                icon: Icon(Icons.insert_chart, color: Colors.blueGrey,),
              ),
              Tab(icon: Icon(Icons.pie_chart, color: Colors.blueGrey,)),
            ],
          ),
          title: Text('Revenue statistic', style: TextStyle(color: Colors.black),),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.close, color: Colors.black,),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        backgroundColor: Colors.white,
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                  child: LineChart(order: orderProvider.orderList)
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: BarChart(order: orderProvider.orderList)
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                  child: PieChart(order: orderProvider.orderList)
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BarChart  extends StatelessWidget {
  final List<OrderModel> order;

  BarChart({this.order});


  @override
  Widget build(BuildContext context) {

    List<charts.Series<OrderModel, DateTime>> series = [
      charts.Series(
          id :'Order',
          domainFn: (OrderModel order, _) => DateTime.fromMillisecondsSinceEpoch(order.createdAt),
          measureFn: (OrderModel order, _) => order.total,
          colorFn: (_, __) => charts.MaterialPalette.teal.shadeDefault,
          data: order,
      )
    ];

    return
      charts.TimeSeriesChart(
      series,
      animate: false,
      defaultInteractions: false,
        defaultRenderer: new charts.BarRendererConfig<DateTime>(),
      behaviors: [new charts.SelectNearest(), new charts.DomainHighlighter()],
    );
  }
}


class PieChart  extends StatelessWidget {
  final List<OrderModel> order;

  PieChart({this.order});


  @override
  Widget build(BuildContext context) {

    List<charts.Series<OrderModel, DateTime>> series = [
      charts.Series(
        id :'Order',
        domainFn: (OrderModel order, _) => DateTime.fromMillisecondsSinceEpoch(order.createdAt),
        measureFn: (OrderModel order, _) => order.total,
        labelAccessorFn: (OrderModel row, _) => '${DateTime.fromMillisecondsSinceEpoch(row.createdAt).year}: ${row.total.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
        data: order,
      )
    ];

    return
      charts.PieChart(
        series,
        animate: false,
          defaultRenderer: new charts.ArcRendererConfig(
              arcWidth: 100,
              arcRendererDecorators: [new charts.ArcLabelDecorator()]
          ));
  }
}


class LineChart  extends StatelessWidget {
  final List<OrderModel> order;

  LineChart({this.order});


  @override
  Widget build(BuildContext context) {

    List<charts.Series<OrderModel, int>> series = [
      charts.Series(
        id :'Order',
        domainFn: (OrderModel order, _) => int.parse(DateTime.fromMillisecondsSinceEpoch(order.createdAt).day.toString()),
        measureFn: (OrderModel order, _) => order.total,
        colorFn: (_, __) => charts.MaterialPalette.teal.shadeDefault,
        data: order,
      )
    ];

    return
      charts.LineChart(
          series,
          animate: false,
        defaultRenderer:
        new charts.LineRendererConfig(includeArea: true, stacked: true),);
  }
}

