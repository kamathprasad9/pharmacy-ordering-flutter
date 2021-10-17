import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:pharmacy_app/providers/auth_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

//models
import '../models/cart.dart';
import '../models/inventory_item.dart';
import '../models/notification.dart';
import '../models/order_item.dart';
import '../models/user.dart';

class OrderManager extends ChangeNotifier {
  AuthManager _authManager;
  User _user;

  final _cart = Cart();

  final databaseReference = FirebaseDatabase.instance.reference();

  get orderItems => _cart.orderItems;

  get user => _user;

  set authManager(AuthManager authManager) {
    _authManager = authManager;
  }

  List<OrderItem> get orderedItems => _cart.orderItems;

  bool isInCart(InventoryItem inventoryItem) {
    if (orderItems != null) {
      var contain = orderItems
          .where((orderItem) => orderItem.medId == inventoryItem.medId);
      if (contain.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  void addInventoryQuantity(InventoryItem inventoryItem) {
    List<OrderItem> orderItems = _cart.orderItems;
    if (orderItems != null ? orderItems.isNotEmpty : false) {
      var contain = orderItems
          .where((orderItem) => orderItem.medId == inventoryItem.medId);
      if (contain.isNotEmpty) {
        //exists
        debugPrint(contain.toString());
      } else {
        //not exists
        addFirstItemFromInventory(inventoryItem);
      }
    } else {
      //empty list
      addFirstItemFromInventory(inventoryItem);
    }
    inventoryItem.isInCart = true;
    notifyListeners();
  }

  void addFirstItemFromInventory(InventoryItem inventoryItem) {
    debugPrint('addNewItem');
    _cart.orderItems ??= [];
    debugPrint(_cart.orderItems.length.toString());
    _cart.orderItems.add(OrderItem(
        medName: inventoryItem.medName,
        medId: inventoryItem.medId,
        quantity: 1,
        pharmaName: inventoryItem.pharmaName,
        singleItemPrice: inventoryItem.price,
        totalItemPrice: inventoryItem.price));

    debugPrint(_cart.orderItems.length.toString());
    notifyListeners();
  }

  void removeInventoryItemFromCart(InventoryItem inventoryItem) {
    debugPrint('remove');
    int index = _cart.orderItems
        .indexWhere((orderItem) => orderItem.medId == inventoryItem.medId);
    _cart.orderItems.removeAt(index);
    debugPrint(_cart.orderItems.length.toString());
    notifyListeners();
  }

  void incrementCount(OrderItem orderItem) {
    debugPrint('incrementCount');
    int index = _cart.orderItems
        .indexWhere((cartItem) => cartItem.medId == orderItem.medId);
    _cart.orderItems[index].incrementCount();
    notifyListeners();
  }

  void decrementCount(OrderItem orderItem) {
    debugPrint('decrementCount');
    int index = _cart.orderItems
        .indexWhere((cartItem) => cartItem.medId == orderItem.medId);
    _cart.orderItems[index].decrementCount();
    notifyListeners();
  }

  int removeFromCart(OrderItem orderItem, List<InventoryItem> inventoryItems) {
    _cart.orderItems.remove(orderItem);
    int index = inventoryItems
        .indexWhere((inventoryItem) => inventoryItem.medId == orderItem.medId);
    notifyListeners();
    return index;
  }

  // String orderId, orderDate;
  // int totalPrice;
  // List<OrderItem> orderItems;
  void placeOrder() async {
    // await getUserData().then((value) async {
    var preferences = await SharedPreferences.getInstance();
    int orderId = _user.orders != null ? _user.orders.length : 0;
    debugPrint(_authManager.emailFormatted);
    await databaseReference
        .child('users')
        .child(_authManager.emailFormatted ??
            preferences.getString('emailFormatted'))
        .child('orders')
        .child(orderId.toString())
        .set(_cart.toJson(orderId + 1))
        .then((value) {
      NotificationModel.showNotification(
        title: 'Order Placed',
        body: "Your order of Rs. ${_cart.totalPrice()} was placed successfully",
      );
      _cart.orderItems = [];
    });
    // });
    // print(_user.name);
  }

  Future<void> getUserData() async {
    try {
      debugPrint("email");
      // debugPrint(_authManager.emailFormatted);
      var preferences = await SharedPreferences.getInstance();

      debugPrint(preferences.getString('emailFormatted'));
      final userRef = databaseReference.child('users').child(
          _authManager.emailFormatted ??
              preferences.getString('emailFormatted'));
      // debugPrint("fetch data: $userRef");
      userRef.once().then((DataSnapshot snapshot) {
        // debugPrint('Data : ${snapshot.value}');
        if (snapshot.value != null) {
          final extractedData = snapshot.value;
          // debugPrint("extracted $extractedData");
          debugPrint("---");
          if (extractedData != null) {
            // debugPrint(extractedData[0]);
            _user = User.fromJson(extractedData);
            debugPrint(_user.name);
          }
        } else {
          _user = null;
        }
        notifyListeners();
        // return _user;
      });
    } catch (error) {
      throw error.toString();
    }
  }
}
