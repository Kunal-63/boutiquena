import 'package:boutiquena_vendor/config/theme.dart';
import 'package:boutiquena_vendor/screens/home_screen.dart';
import 'package:boutiquena_vendor/screens/orders/order_list.dart';
import 'package:boutiquena_vendor/screens/products/product_screen.dart';
import 'package:boutiquena_vendor/screens/profile/profile_screen.dart';
import 'package:boutiquena_vendor/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:boutiquena_vendor/widgets/navigation/bottom_navigation_item.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    const ProductScreen(),
    const OrderListScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(70.0),
      //   child: CustomAppBar(
      //     title: "Dashboard",
      //     imageUrl:
      //         "https://st3.depositphotos.com/1007566/13310/v/450/depositphotos_133109560-stock-illustration-male-profile-avatar-with-brown.jpg",
      //     errorImage: "assets/icons/avatar.jpg",
      //     onBellPressed: () {},
      //     onSettingsPressed: () {},
      //   ),
      // ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 80,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            horizontal: 0.0 * SizeConfig.widthScale, vertical: 10),
        decoration: const BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50),
            topLeft: Radius.circular(50),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: BottomNavigationItem(
                iconPath: 'assets/icons/white-home-icon.svg',
                selectedPath: 'assets/icons/home-icon.svg',
                isSelected: _selectedIndex == 0,
                onTap: () => _onItemTapped(0),
              ),
            ),
            Expanded(
              child: BottomNavigationItem(
                iconPath: 'assets/icons/white-bag-icon.svg',
                selectedPath: 'assets/icons/bag-icon.svg',
                isSelected: _selectedIndex == 1,
                onTap: () => _onItemTapped(1),
              ),
            ),
            Expanded(
              child: BottomNavigationItem(
                iconPath: 'assets/icons/white-product-list-icon.svg',
                selectedPath: 'assets/icons/product-list-icon.svg',
                isSelected: _selectedIndex == 2,
                onTap: () => _onItemTapped(2),
              ),
            ),
            Expanded(
              child: BottomNavigationItem(
                iconPath: 'assets/icons/white-profile-icon.svg',
                selectedPath: 'assets/icons/profile-icon.svg',
                isSelected: _selectedIndex == 3,
                onTap: () => _onItemTapped(3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
