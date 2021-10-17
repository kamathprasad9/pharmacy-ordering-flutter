import 'package:flutter/material.dart';
import 'package:pharmacy_app/providers/order_manager.dart';
import 'package:provider/provider.dart';

import '../models/inventory_item.dart';
import '../providers/inventory_manager.dart';
//widgets
import '../widgets/cart_item_container.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = 'cart_screen';
  final List<InventoryItem> inventoryItems;

  const CartScreen({
    Key key,
    this.inventoryItems,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<OrderManager>(context, listen: false).getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: SingleChildScrollView(
        child: Consumer<OrderManager>(
          builder: (context, orderData, child) {
            return Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: orderData != null
                      ? orderData.orderItems != null
                          ? orderData.orderedItems.length
                          : 0
                      : 0,
                  itemBuilder: (ctx, index) {
                    final orderItem = orderData.orderedItems[index];
                    return CartItemContainer(
                      item: orderItem,
                      inventoryItems: widget.inventoryItems,
                    );
                  },
                ),
                const SizedBox(
                  height: 100,
                ),
                if (orderData.orderedItems != null)
                  // ignore: prefer_is_empty
                  if (orderData.orderedItems.length > 0)
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () {
                        Provider.of<OrderManager>(context, listen: false)
                            .placeOrder();
                        for (InventoryItem inventoryItem
                            in widget.inventoryItems) {
                          debugPrint('forloop');
                          Provider.of<InventoryManager>(context, listen: false)
                              .toggleIsInCart(inventoryItem, false);
                        }
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: const Text('Place Order'),
                      ),
                    ),
                // ignore: prefer_is_empty
                if (orderData.orderedItems == null
                    ? true
                    // ignore: prefer_is_empty
                    : orderData.orderedItems.length == 0)
                  const Text('Cart Empty'),
              ],
            );
          },
        ),
      ),
    );
  }
}
