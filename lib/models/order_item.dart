import 'package:flutter/cupertino.dart';

class OrderItem extends ChangeNotifier {
  String medName, medId, pharmaName;
  int quantity, singleItemPrice, totalItemPrice;

  OrderItem({
    this.medName,
    this.medId,
    this.pharmaName,
    this.quantity,
    this.singleItemPrice,
    this.totalItemPrice,
  });

  factory OrderItem.fromJson(var jsonData) {
    return OrderItem(
      medName: jsonData['medName'],
      medId: jsonData['medId'],
      pharmaName: jsonData['pharmaName'],
      quantity: jsonData['quantity'],
      singleItemPrice: jsonData['singleItemPrice'],
      totalItemPrice: jsonData['totalItemPrice'],
    );
  }

  Map toJson() {
    return {
      'medName': medName,
      'medId': medId,
      'pharmaName': pharmaName,
      'quantity': quantity,
      'singleItemPrice': singleItemPrice,
      'totalItemPrice': totalItemPrice,
    };
  }

  void incrementCount() {
    quantity++;
    totalItemPrice = quantity * singleItemPrice;
    notifyListeners();
  }

  void decrementCount() {
    quantity--;
    totalItemPrice = quantity * singleItemPrice;
    notifyListeners();
  }
}
