import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:customer_app/widgets/headers/common_appbar.dart';
import 'package:customer_app/widgets/popup_menu_item.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: CommonAppBar(
          title: "Product",
          menuPressed: () {},
          menuItems: [
            PopupMenuHelper.buildPopupMenuItem(
              0,
              'assets/icons/edit-popup-icon.svg',
              'Edit',
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30 * SizeConfig.widthScale),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'opps!!',
              style: AppTextStyles.blackSubHeadingStyle().copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20 * SizeConfig.widthScale,
              ),
            ),
            SizedBox(
              height: 10 * SizeConfig.heightScale,
              width: 10 * SizeConfig.widthScale,
            ),
            Text(
              'There is no products added, add your products now.',
              textAlign: TextAlign.center,
              style: AppTextStyles.blackSubHeadingStyle().copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 16 * SizeConfig.widthScale,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/add_product');
                // Add your product addition logic here
                print("Add product tapped");
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(243, 120, 102, 1),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
