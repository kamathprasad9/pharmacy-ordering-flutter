import 'package:flutter/foundation.dart';

class InventoryItem with ChangeNotifier {
  String medName, medId, pharmaName, image;
  int quantityAvailable, price;
  bool isInCart;

  InventoryItem({
    @required this.medName,
    @required this.medId,
    @required this.pharmaName,
    @required this.price,
    @required this.quantityAvailable,
    @required this.image,
    this.isInCart = false,
  });

  factory InventoryItem.fromJson(Map<dynamic, dynamic> jsonData) {
    return InventoryItem(
      medName: jsonData['medName'],
      medId: jsonData['medId'],
      pharmaName: jsonData['pharmaName'],
      price: jsonData['price'],
      quantityAvailable: jsonData['quantityAvailable'],
      image: jsonData['image'],
    );
  }

  // void toggleIsInCart(bool changeTo) {
  //   debugPrint('toggleIsInCart $changeTo $medName');
  //   isInCart = changeTo;
  //   notifyListeners();
  // }
}
