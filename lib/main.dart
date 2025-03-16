import 'package:boutiquena_vendor/screens/products/add_product.dart';
import 'package:boutiquena_vendor/screens/profile/edit_profile.dart';
import 'package:boutiquena_vendor/screens/main_screen.dart';
import 'package:boutiquena_vendor/screens/orders/order_details.dart';
import 'package:boutiquena_vendor/screens/orders/order_list.dart';
import 'package:boutiquena_vendor/screens/products/product_details.dart';
import 'package:boutiquena_vendor/screens/products/product_list.dart';
import 'package:boutiquena_vendor/screens/sign_up.dart';
import 'package:boutiquena_vendor/screens/store_setup.dart';
import 'package:boutiquena_vendor/screens/subscription_plan.dart';
import 'package:flutter/material.dart';
import 'utils/size_config.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(MyApp());

  Future.delayed(Duration(seconds: 3), () {
    FlutterNativeSplash.remove();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
