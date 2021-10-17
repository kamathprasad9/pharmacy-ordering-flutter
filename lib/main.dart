import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pharmacy_app/providers/inventory_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './providers/auth_manager.dart';
import './providers/inventory_manager.dart';
import './providers/order_manager.dart';
import './screens/cart_screen.dart';
import './screens/home_screen.dart';
import './screens/login_screen.dart';
import './screens/order_history_screen.dart';
import './screens/registration_screen.dart';
import './screens/welcome_screen.dart';

final _notifications = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var preference = await SharedPreferences.getInstance();
  var isLoggedIn = preference.getBool("isLoggedIn") ?? false;

  var initSettingAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initSettings = InitializationSettings(
    android: initSettingAndroid,
  );

  await _notifications.initialize(initSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
      // Navigator.pushNamed(context, OrderHistoryScreen.routeName);
    }
  });

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthManager>(
          create: (_) => AuthManager(
            isLoggedIn,
          ),
        ),
        ChangeNotifierProxyProvider<AuthManager, OrderManager>(
          create: (_) => OrderManager(),
          update: (_,
                  // AuthManager authManager,
                  AuthManager authManager,
                  OrderManager orderManager) =>
              orderManager..authManager = authManager,
        ),
        ChangeNotifierProxyProvider<OrderManager, InventoryManager>(
          create: (_) => InventoryManager(),
          update: (_, OrderManager orderManager,
                  InventoryManager inventoryManager) =>
              inventoryManager..orderManager = orderManager,
        ),
      ],
      child: PharmacyApp(
        isLoggedIn: isLoggedIn,
      )));
}

class PharmacyApp extends StatelessWidget {
  final bool isLoggedIn;

  const PharmacyApp({Key key, this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("value " + isLoggedIn.toString());

    return MaterialApp(
      initialRoute: isLoggedIn ? HomeScreen.routeName : WelcomeScreen.routeName,
      routes: {
        WelcomeScreen.routeName: (context) => const WelcomeScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        RegistrationScreen.routeName: (context) => const RegistrationScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        CartScreen.routeName: (context) => const CartScreen(),
        OrderHistoryScreen.routeName: (context) => const OrderHistoryScreen(),
      },
    );
  }
}
