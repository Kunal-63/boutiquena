import 'package:vendor_app/screens/products/add_product.dart';
import 'package:vendor_app/screens/profile/edit_profile.dart';
import 'package:vendor_app/screens/main_screen.dart';
import 'package:vendor_app/screens/orders/order_details.dart';
import 'package:vendor_app/screens/orders/order_list.dart';
import 'package:vendor_app/screens/products/product_details.dart';
import 'package:vendor_app/screens/products/product_list.dart';
import 'package:vendor_app/screens/sign_up.dart';
import 'package:vendor_app/screens/store_setup.dart';
import 'package:vendor_app/screens/subscription_plan.dart';
import 'package:flutter/material.dart';
import 'utils/size_config.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue, // Main theme color
        scaffoldBackgroundColor: Colors.white, // Fix pinkish dialogs
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.white, // Fix pinkish bottom sheets
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black87),
          bodySmall: TextStyle(color: Colors.black54),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue, // Change app bar color
          foregroundColor: Colors.white, // Set text/icons to white
          elevation: 0,
        ),
        dialogTheme: DialogThemeData(backgroundColor: Colors.white),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/subscription': (context) => const SubscriptionScreen(),
        '/store_setup': (context) => const StoreSetupScreen(),
        '/main_screen': (context) => const MainScreen(),
        '/add_product': (context) => const AddProductScreen(),
        '/product_details': (context) => const ProductDetailsScreen(),
        '/product_list': (context) => const ProductListScreen(),
        '/order_list': (context) => const OrderListScreen(),
        '/order_details': (context) => const OrderDetailsScreen(),
        '/edit_profile': (context) => EditProfileScreen(),
      },
      builder: (context, child) {
        SizeConfig.init(context);
        return child!;
      },
    );
  }
}
