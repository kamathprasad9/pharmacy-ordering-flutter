import 'package:flutter/cupertino.dart';
import 'package:pharmacy_app/models/order_item.dart';

class Cart with ChangeNotifier {
  List<OrderItem> orderItems;

  Map toJson(int orderId) {
    return {
      'orderDate': DateTime.now().toString(),
      'orderId': orderId.toString(),
      'orderItems': orderItems.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice(),
    };
  }

  int totalPrice() {
    int totalPrice = 0;
    for (OrderItem orderItem in orderItems) {
      totalPrice = totalPrice + orderItem.totalItemPrice;
    }
    return totalPrice;
  }
}
