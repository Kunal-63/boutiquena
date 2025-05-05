import 'package:customer_app/providers/best_seller_provider.dart';
import 'package:customer_app/providers/cart_provider.dart';
import 'package:customer_app/providers/category_products_provider.dart';
import 'package:customer_app/providers/chat_message_provider.dart';
import 'package:customer_app/providers/city_provider.dart';
import 'package:customer_app/providers/home_screen_provider.dart';
import 'package:customer_app/providers/product_provider.dart';
import 'package:customer_app/providers/search_provider.dart';
import 'package:customer_app/providers/shipping_address_provider.dart';
import 'package:customer_app/providers/store_provider.dart';
import 'package:customer_app/providers/suggested_product_provider.dart';
import 'package:customer_app/providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:customer_app/providers/login_provider.dart';
import 'package:customer_app/providers/orders_provider.dart';
import 'package:customer_app/providers/region_provider.dart';
import 'package:customer_app/providers/vendor_delivery_price.dart';
import 'package:customer_app/providers/customer_profile_provider.dart';
import 'package:customer_app/screens/profile/edit_profile.dart';
import 'package:customer_app/screens/main_screen.dart';
import 'package:customer_app/screens/orders/order_details.dart';
import 'package:customer_app/screens/orders/order_list.dart';
import 'package:customer_app/screens/products/product_details.dart';
import 'package:customer_app/screens/profile/profile_screen.dart';
import 'package:customer_app/screens/sign_up.dart';
import 'package:customer_app/screens/splash_screen.dart';
import 'package:customer_app/screens/login_screen.dart';
import 'utils/size_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CustomerProfileProvider()),
        ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => RegionProvider()),
        ChangeNotifierProvider(create: (_) => VendorDeliveryProvider()),
        ChangeNotifierProvider(create: (_) => SearchScreenProvider()),
        ChangeNotifierProvider(create: (_) => ChatMessageProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => ShippingAddressProvider()),
        ChangeNotifierProvider(create: (_) => SuggestedProductsProvider()),
        ChangeNotifierProvider(create: (_) => BestSellerProductsProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProductsProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CityProvider()),
        ChangeNotifierProvider(create: (_) => StoreProvider()),
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
        dialogTheme: DialogThemeData(backgroundColor: Colors.white),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/main_screen': (context) => const MainScreen(),
        '/profile': (context) => ProfileScreen(),
        '/product_details': (context) => const ProductDetailsScreen(),
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
