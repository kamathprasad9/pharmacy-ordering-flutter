import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:pharmacy_app/models/inventory_item.dart';
import 'package:pharmacy_app/providers/order_manager.dart';

import '../models/inventory.dart';

class InventoryManager with ChangeNotifier {
  OrderManager _orderManager;

  set orderManager(OrderManager orderManager) {
    _orderManager = orderManager;
  }

  Inventory _inventory = Inventory();

  List<InventoryItem> get inventoryItems => _inventory.inventoryItems;

  final databaseReference = FirebaseDatabase.instance.reference();

  Future<void> getInventoryData() async {
    try {
      final inventoryRef = databaseReference.child('inventory');
      // debugPrint("fetch data: $inventoryRef");
      inventoryRef.once().then((DataSnapshot snapshot) {
        // debugPrint('Data : ${snapshot.value}');
        if (snapshot.value != null) {
          final extractedData = snapshot.value as List;
          // debugPrint("extracted $extractedData");
          // debugPrint("---");
          if (extractedData != null) {
            // debugPrint(extractedData[0]);
            for (var element in extractedData) {
              debugPrint(element.toString());
            }
            _inventory.inventoryItems = extractedData
                .map((item) => InventoryItem.fromJson(item))
                .toList();
            for (var inventoryItem in _inventory.inventoryItems) {
              inventoryItem.isInCart =
                  _orderManager.isInCart(inventoryItem) ? true : false;
            }
            debugPrint(_inventory.inventoryItems.first.medName);
          }
        } else {
          _inventory = null;
        }
        notifyListeners();
        return _inventory;
      });
    } catch (error) {
      throw "no content";
    }
  }

  void toggleIsInCart(InventoryItem inventoryItem, bool value) {
    inventoryItem.isInCart = value;
    notifyListeners();
  }
}
