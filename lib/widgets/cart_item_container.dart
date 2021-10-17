import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/inventory_item.dart';
import '../models/order_item.dart';
import '../providers/inventory_manager.dart';
import '../providers/order_manager.dart';

class CartItemContainer extends StatelessWidget {
  final OrderItem item;
  final List<InventoryItem> inventoryItems;

  const CartItemContainer({Key key, this.item, this.inventoryItems})
      : super(key: key);

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
                        item.medName,
                        style: const TextStyle(fontSize: 22),
                      ),
                      Text(
                        item.pharmaName,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            item.singleItemPrice.toString() + " x ",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            item.quantity.toString() + " = ",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            String.fromCharCode(8377),
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(
                            item.totalItemPrice.toString(),
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w700),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 30,
          right: 15,
          child: IconButton(
            icon: const Icon(
              Icons.delete_forever,
              color: Colors.red,
              size: 30,
            ),
            onPressed: () {
              int index = Provider.of<OrderManager>(context, listen: false)
                  .removeFromCart(item, inventoryItems);
              Provider.of<InventoryManager>(context, listen: false)
                  .toggleIsInCart(inventoryItems[index], false);
              debugPrint('remove');
            },
          ),
        ),
        Positioned(
            right: -5,
            bottom: 25,
            child: Row(
              children: <Widget>[
                RawMaterialButton(
                  onPressed: item.quantity <= 1
                      ? null
                      : () {
                          Provider.of<OrderManager>(context, listen: false)
                              .decrementCount(item);
                          debugPrint('remove');
                        },
                  elevation: 0,
                  fillColor:
                      item.quantity <= 1 ? Colors.grey[300] : Colors.white,
                  child: const Icon(
                    Icons.remove,
                    color: Colors.black,
                  ),
                  shape: const CircleBorder(
                      side: BorderSide(color: Colors.black, width: 2)),
                ),
                SizedBox(
                    height: 40,
                    // width: ,
                    child: Center(
                        child: Text(
                      item.quantity.toString(),
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ))),
                RawMaterialButton(
                  onPressed: () {
                    Provider.of<OrderManager>(context, listen: false)
                        .incrementCount(item);
                    debugPrint('add');
                  },
                  elevation: 10.0,
                  fillColor: Colors.black,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 22,
                  ),
                  // padding: const EdgeInsets.all(15.0),
                  shape: const CircleBorder(),
                ),
              ],
            )),
      ],
    );
  }
}
