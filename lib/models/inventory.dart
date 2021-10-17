import 'package:pharmacy_app/models/inventory_item.dart';

class Inventory {
  List<InventoryItem> inventoryItems;

  Inventory({this.inventoryItems});

  factory Inventory.fromJson(var jsonData) {
    List extractedData = jsonData['inventory'] as List;
    return Inventory(
      inventoryItems: extractedData.map(
        (inventoryItem) => InventoryItem.fromJson(inventoryItem),
      ),
    );
  }
}
