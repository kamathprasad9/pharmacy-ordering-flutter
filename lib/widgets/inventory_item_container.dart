import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/inventory_item.dart';
import '../providers/inventory_manager.dart';
import '../providers/order_manager.dart';

class InventoryItemContainer extends StatelessWidget {
  final InventoryItem inventoryItem;

  const InventoryItemContainer({Key key, this.inventoryItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          child: PhysicalModel(
            color: Colors.white,
            elevation: 8,
            shadowColor: Colors.blue,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // Image(
                  //   image: NetworkImage(item.productImage),
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        inventoryItem.medName,
                        style: const TextStyle(fontSize: 22),
                      ),
                      Text(
                        inventoryItem.pharmaName,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            String.fromCharCode(8377),
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(
                            inventoryItem.price.toString(),
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                      if (inventoryItem.quantityAvailable <= 10)
                        Text(
                          'Only ${inventoryItem.quantityAvailable} stocks left!',
                          style: const TextStyle(color: Colors.grey),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
            right: 30,
            bottom: 25,
            child: TextButton(
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  child: Row(
                    children: inventoryItem.isInCart
                        ? const [
                            Text('Remove from Cart'),
                            SizedBox(width: 5),
                            Icon(Icons.remove_shopping_cart)
                          ]
                        : const [
                            Text('Add to Cart'),
                            SizedBox(width: 5),
                            Icon(Icons.add_shopping_cart)
                          ],
                  )),
              onPressed: inventoryItem.isInCart
                  ? () {
                      Provider.of<InventoryManager>(context, listen: false)
                          .toggleIsInCart(inventoryItem, false);
                      Provider.of<OrderManager>(context, listen: false)
                          .removeInventoryItemFromCart(inventoryItem);
                    }
                  : () {
                      Provider.of<InventoryManager>(context, listen: false)
                          .toggleIsInCart(inventoryItem, true);
                      Provider.of<OrderManager>(context, listen: false)
                          .addInventoryQuantity(inventoryItem);
                      debugPrint('add');
                    },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      side: const BorderSide(color: Colors.black),
                    ),
                  )),
            )),
      ],
    );
  }
}
