import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_app/providers/order_manager.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class OrderHistoryScreen extends StatefulWidget {
  static const String routeName = 'order_history_screen';

  const OrderHistoryScreen({
    Key key,
  }) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> rebuild() async {
    await Provider.of<OrderManager>(context, listen: false).getUserData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<OrderManager>(context, listen: false).getUserData(),
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return const Center(child: Icon(Icons.error));
              } else {
                return Consumer<OrderManager>(builder: (ctx, userData, child) {
                  User user = userData.user;
                  return RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: rebuild,
                    child: Scaffold(
                      backgroundColor: Colors.grey[350],
                      appBar: AppBar(
                        title: const Text('Order History'),
                      ),
                      body: SingleChildScrollView(
                        child: user != null
                            ? Container(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      child: const Text(
                                        "All orders would be delivered to the registered address",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    Table(
                                      // defaultColumnWidth:
                                      //     const IntrinsicColumnWidth(),
                                      columnWidths: const {
                                        0: FixedColumnWidth(100.0), //
                                        //fixed to 100 width
                                      },
                                      children: [
                                        TableRow(children: [
                                          const Text(
                                            "Name",
                                            textScaleFactor: 1.5,
                                          ),
                                          Text(user.name, textScaleFactor: 1.5),
                                        ]),
                                        TableRow(children: [
                                          const Text(
                                            "Email",
                                            textScaleFactor: 1.5,
                                          ),
                                          Text(user.email,
                                              textScaleFactor: 1.5),
                                        ]),
                                        TableRow(children: [
                                          const Text(
                                            "Contact",
                                            textScaleFactor: 1.5,
                                          ),
                                          Text(user.contact,
                                              textScaleFactor: 1.5),
                                        ]),
                                        TableRow(children: [
                                          const Text(
                                            "Address",
                                            textScaleFactor: 1.5,
                                          ),
                                          Text(user.address,
                                              textScaleFactor: 1.2),
                                        ]),
                                        TableRow(children: [
                                          const Text(
                                            "Area",
                                            textScaleFactor: 1.5,
                                          ),
                                          Text(user.area, textScaleFactor: 1.2),
                                        ]),
                                        TableRow(children: [
                                          const Text(
                                            "City",
                                            textScaleFactor: 1.5,
                                          ),
                                          Text(user.city, textScaleFactor: 1.2),
                                        ]),
                                        TableRow(children: [
                                          const Text(
                                            "Area Pin",
                                            textScaleFactor: 1.5,
                                          ),
                                          Text(user.areaPin,
                                              textScaleFactor: 1.2),
                                        ]),
                                      ],
                                    ),
                                    user.orders == null
                                        ? Container(
                                            margin:
                                                const EdgeInsets.only(top: 20),
                                            child: const Text(
                                              'No past orders',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: user.orders
                                                .map((order) => PhysicalModel(
                                                      elevation: 10,
                                                      color: Colors.white,
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .all(20),
                                                        child: Column(
                                                          children: [
                                                            Table(
                                                              children: [
                                                                TableRow(
                                                                    children: [
                                                                      const Text(
                                                                        "Order Id:",
                                                                        textScaleFactor:
                                                                            1,
                                                                      ),
                                                                      Text(
                                                                          order
                                                                              .orderId,
                                                                          textScaleFactor:
                                                                              1),
                                                                    ]),
                                                                TableRow(
                                                                    children: [
                                                                      const Text(
                                                                        "Order Date:",
                                                                        textScaleFactor:
                                                                            1,
                                                                      ),
                                                                      // Text(
                                                                      //     order.orderDate
                                                                      //         .toString(),
                                                                      //     textScaleFactor: 1),
                                                                      Text(
                                                                          order.orderDate != null
                                                                              ? DateFormat.yMMMMd().format(DateTime.parse(order
                                                                                  .orderDate))
                                                                              : "",
                                                                          textScaleFactor:
                                                                              1),
                                                                    ]),
                                                              ],
                                                            ),
                                                            Table(
                                                              border: TableBorder.all(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1,
                                                                  style:
                                                                      BorderStyle
                                                                          .solid),
                                                              children: const [
                                                                TableRow(
                                                                    children: [
                                                                      Text(
                                                                        'Item',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      Text(
                                                                        'Quantity',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      Text(
                                                                        'MRP',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      Text(
                                                                        'Price',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ]),
                                                              ],
                                                            ),
                                                            Table(
                                                              border: TableBorder.all(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1,
                                                                  style:
                                                                      BorderStyle
                                                                          .solid),
                                                              children: order
                                                                  .orderItems
                                                                  .map((item) =>
                                                                      TableRow(
                                                                          children: [
                                                                            Text(item.medName),
                                                                            Text(item.quantity.toString()),
                                                                            Text(item.singleItemPrice.toString()),
                                                                            Text(item.totalItemPrice.toString()),
                                                                          ]))
                                                                  .toList(),
                                                            ),
                                                            Text(
                                                                'Total: Rs. ${order.totalPrice}')
                                                          ],
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                          )
                                  ],
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                      ),
                    ),
                  );
                });
              }
          }
        });
  }
}
