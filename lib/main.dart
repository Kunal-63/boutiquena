import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/providers/login_provider.dart';
import 'package:vendor_app/providers/orders_provider.dart';
import 'package:vendor_app/providers/product_provider.dart';
import 'package:vendor_app/providers/region_provider.dart';
import 'package:vendor_app/providers/store_category.dart';
import 'package:vendor_app/providers/subscription_provider.dart';
import 'package:vendor_app/providers/vendor_delivery_price.dart';
import 'package:vendor_app/providers/vendor_profile_provider.dart';
import 'package:vendor_app/screens/products/add_product.dart';
import 'package:vendor_app/screens/profile/edit_profile.dart';
import 'package:vendor_app/screens/main_screen.dart';
import 'package:vendor_app/screens/orders/order_details.dart';
import 'package:vendor_app/screens/orders/order_list.dart';
import 'package:vendor_app/screens/products/product_details.dart';
import 'package:vendor_app/screens/products/product_list.dart';
import 'package:vendor_app/screens/profile/profile_screen.dart';
import 'package:vendor_app/screens/sign_up.dart';
import 'package:vendor_app/screens/store_setup.dart';
import 'package:vendor_app/screens/subscription_plan.dart';
import 'package:vendor_app/screens/splash_screen.dart';
import 'package:vendor_app/screens/login_screen.dart';
import 'package:vendor_app/screens/vendor%20delivery/vendor_delivery_screen.dart';
import 'package:vendor_app/services/mavigation_service.dart';
import 'utils/size_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => VendorProfileProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => RegionProvider()),
        ChangeNotifierProvider(create: (_) => VendorDeliveryProvider()),
        ChangeNotifierProvider(create: (_) => StoreCategoryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.white,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black87),
          bodySmall: TextStyle(color: Colors.black54),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        dialogTheme: DialogTheme(backgroundColor: Colors.white),
      ),
      initialRoute: '/',
      navigatorKey: NavigationService.navigatorKey,
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/subscription': (context) => const SubscriptionScreen(),
        '/store_setup': (context) => const StoreSetupScreen(),
        '/main_screen': (context) => const MainScreen(),
        '/add_product': (context) => const AddProductScreen(),
        '/profile': (context) => ProfileScreen(),
        '/product_details': (context) => const ProductDetailsScreen(),
        '/product_list': (context) => const ProductListScreen(),
        '/order_list': (context) => const OrderListScreen(),
        '/order_details': (context) => const OrderDetailsScreen(),
        '/edit_profile': (context) => EditProfileScreen(),
        '/vendor_delivery_price': (context) => VendorDeliveryScreen(),
      },
      builder: (context, child) {
        SizeConfig.init(context);
        return child!;
      },
    );
  }
}
