import 'package:flutter/cupertino.dart';

import 'order_item.dart';

class Order {
  String orderId, orderDate;
  int totalPrice;
  List<OrderItem> orderItems;

  Order({
    @required this.orderId,
    @required this.orderDate,
    @required this.totalPrice,
    @required this.orderItems,
  });

  factory Order.fromJson(Map<dynamic, dynamic> jsonData) {
    // debugPrint("\n\n-------" + jsonData.toString());
    List extractedData = jsonData['orderItems'] as List;
    return Order(
      orderId: jsonData['orderId'],
      orderDate: jsonData['orderDate'],
      totalPrice: jsonData['totalPrice'],
      orderItems: extractedData
          .map((orderItem) => OrderItem.fromJson(orderItem))
          .toList(),
    );
  }
}
