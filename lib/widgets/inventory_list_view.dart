import 'package:flutter/material.dart';
import 'package:pharmacy_app/providers/inventory_manager.dart';
import 'package:provider/provider.dart';

import '../models/inventory_item.dart';
import '../widgets/inventory_item_container.dart';

class InventoryListView extends StatelessWidget {
  // final List<InventoryItem> inventoryItems;

  const InventoryListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryManager>(builder: (context, inventoryData, child) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: inventoryData != null
            ? inventoryData.inventoryItems != null
                ? inventoryData.inventoryItems.length
                : 0
            : 0,
        itemBuilder: (ctx, index) {
          InventoryItem inventoryItem = inventoryData.inventoryItems[index];
          return InventoryItemContainer(
            inventoryItem: inventoryItem,
          );
        },
      );
    });
  }
}
