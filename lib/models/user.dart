import 'package:flutter/cupertino.dart';

import 'order.dart';

class User {
  String email,
      name,
      latitude,
      longitude,
      address,
      area,
      city,
      areaPin,
      contact;
  List<Order> orders;

  User({
    @required this.email,
    @required this.name,
    @required this.longitude,
    @required this.latitude,
    @required this.address,
    @required this.area,
    @required this.city,
    @required this.areaPin,
    @required this.contact,
    @required this.orders,
  });

  factory User.fromJson(var jsonData) {
    List extractedData = jsonData['orders'] as List;
    return User(
      email: jsonData['email'],
      name: jsonData['name'],
      contact: jsonData['contact'],
      latitude: jsonData['latitude'],
      longitude: jsonData['longitude'],
      address: jsonData['address'],
      area: jsonData['area'],
      city: jsonData['city'],
      areaPin: jsonData['areaPin'],
      // ignore: prefer_null_aware_operators
      orders: extractedData != null
          ? extractedData.map((order) => Order.fromJson(order)).toList()
          : null,
    );
  }
}
