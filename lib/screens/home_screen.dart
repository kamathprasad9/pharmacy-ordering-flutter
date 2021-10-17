import 'package:flutter/material.dart';
import 'package:pharmacy_app/providers/auth_manager.dart';
import 'package:pharmacy_app/screens/order_history_screen.dart';
import 'package:pharmacy_app/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

import '../providers/inventory_manager.dart';
import '../screens/cart_screen.dart';
//widgets
import '../widgets/inventory_list_view.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home_screen';

  const HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> rebuild() async {
    await Provider.of<InventoryManager>(context, listen: false)
        .getInventoryData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<InventoryManager>(context, listen: false)
            .getInventoryData(),
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return const Center(child: Icon(Icons.error));
              } else {
                return Consumer<InventoryManager>(
                    builder: (ctx, inventoryData, child) {
                  return RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: rebuild,
                    child: Scaffold(
                      backgroundColor: Colors.grey[350],
                      appBar: AppBar(
                          title: const Text('Order Medicines'),
                          actions: [
                            IconButton(
                              onPressed: () {
                                Provider.of<AuthManager>(context, listen: false)
                                    .loggedInFalse();
                                Navigator.pushReplacementNamed(
                                    context, WelcomeScreen.routeName);
                              },
                              icon: const Icon(Icons.logout),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, OrderHistoryScreen.routeName);
                              },
                              icon: const Icon(Icons.history),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CartScreen(
                                      inventoryItems:
                                          inventoryData.inventoryItems,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.shopping_cart),
                            ),
                          ]),
                      body: const InventoryListView(),
                    ),
                  );
                });
              }
          }
        });
  }
}
