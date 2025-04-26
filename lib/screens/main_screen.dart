import 'package:customer_app/screens/orders/checkout_screen.dart';
import 'package:customer_app/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/screens/home_screen.dart';

import 'package:customer_app/screens/profile/profile_screen.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:customer_app/widgets/navigation/bottom_navigation_item.dart';

class MainScreen extends StatefulWidget {
  static final ValueNotifier<int> selectedIndexNotifier = ValueNotifier<int>(0);

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    CheckOutScreen(),
    ProfileScreen(),
  ];

  void onItemTapped(int index) {
    MainScreen.selectedIndexNotifier.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: MainScreen.selectedIndexNotifier,
        builder: (context, selectedIndex, _) {
          return _screens[selectedIndex];
        },
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: MainScreen.selectedIndexNotifier,
        builder: (context, selectedIndex, _) {
          return Container(
            height: 70,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 0.0 * SizeConfig.widthScale,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Color.fromRGBO(31, 88, 84, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35.0 * SizeConfig.widthScale),
                topRight: Radius.circular(35.0 * SizeConfig.widthScale),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: BottomNavigationItem(
                    iconPath: 'assets/icons/white-home-icon.svg',
                    selectedPath: 'assets/icons/home-icon.svg',
                    isSelected: selectedIndex == 0,
                    onTap: () => onItemTapped(0),
                  ),
                ),
                Expanded(
                  child: BottomNavigationItem(
                    iconPath: 'assets/icons/search-icon.svg',
                    selectedPath: 'assets/icons/search-icon.svg',
                    isSelected: selectedIndex == 1,
                    onTap: () => onItemTapped(1),
                  ),
                ),
                Expanded(
                  child: BottomNavigationItem(
                    iconPath: 'assets/icons/cart-icon.svg',
                    selectedPath: 'assets/icons/cart-icon.svg',
                    isSelected: selectedIndex == 2,
                    onTap: () => onItemTapped(2),
                  ),
                ),
                Expanded(
                  child: BottomNavigationItem(
                    iconPath: 'assets/icons/white-profile-icon.svg',
                    selectedPath: 'assets/icons/profile-icon.svg',
                    isSelected: selectedIndex == 3,
                    onTap: () => onItemTapped(3),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
