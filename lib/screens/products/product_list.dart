import 'package:provider/provider.dart';
import 'package:vendor_app/config/text_styles.dart';
import 'package:vendor_app/config/theme.dart';
import 'package:vendor_app/screens/products/edit_product.dart';
import 'package:vendor_app/screens/products/product_details.dart';
import 'package:vendor_app/utils/custom_network_image.dart';
import 'package:vendor_app/utils/size_config.dart';
import 'package:vendor_app/widgets/headers/common_appbar.dart';
import 'package:vendor_app/widgets/inputs/input_widgets.dart';
import 'package:vendor_app/widgets/popup_menu_item.dart';
import 'package:vendor_app/widgets/popups/delete_product_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../providers/product_provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProductProvider>().fetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: CommonAppBar(
          title: "Product List",
          menuPressed: () {},
          backPressed: () {},
          menuItems: [
            PopupMenuHelper.buildPopupMenuItem(
              0,
              'assets/icons/edit-popup-icon.svg',
              'Edit',
            ),
          ],
        ),
      ),
      body:
          productProvider.isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              )
              : productProvider.products.isEmpty
              ? Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 30 * SizeConfig.widthScale,
                ),
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
              )
              : Column(
                children: [
                  // Search and Filter Section
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20 * SizeConfig.widthScale,
                      vertical: 10 * SizeConfig.heightScale,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Filter Button
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromRGBO(219, 233, 233, 1),
                                  width: 0.94,
                                ),
                                borderRadius: BorderRadius.circular(
                                  22 * SizeConfig.heightScale,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 15 * SizeConfig.widthScale,
                                vertical: 10 * SizeConfig.heightScale,
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/filter-icon.svg',
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Filter',
                                    style: AppTextStyles.blackSubHeadingStyle()
                                        .copyWith(
                                          fontSize: 14 * SizeConfig.widthScale,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            // Add Product Button
                            GestureDetector(
                              onTap: () {
                                // Navigate to Add Product Screen
                                Navigator.pushNamed(context, '/add_product');
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(243, 120, 102, 1),
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(5),
                                child: const Icon(
                                  Icons.add_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5 * SizeConfig.heightScale),
                        InputWidget(
                          hint: 'Search your any product',
                          controller: _controller,
                          svgPath: 'assets/icons/search-icon.svg',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20 * SizeConfig.widthScale,
                        vertical: 5 * SizeConfig.heightScale,
                      ),
                      itemCount: productProvider.products.length,
                      itemBuilder: (context, index) {
                        var product = productProvider.products[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        ProductDetailsScreen(product: product),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.37),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product Image
                                  CustomNetworkImage(
                                    imageUrl:
                                        '${productProvider.productImageURL}/${product.productImage}',
                                    // imageUrl:
                                    //     product.productImage ??
                                    //     'http://69.62.72.21/dev/public/front/images/product_images/small/64835.jpg',
                                    errorImage: 'assets/icons/no-image.png',
                                    width: 110 * SizeConfig.widthScale,
                                    height: 130 * SizeConfig.heightScale,
                                    radius: 5,
                                  ),
                                  SizedBox(width: 10 * SizeConfig.widthScale),

                                  // Product Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.productName ?? "Unknown",
                                          style:
                                              AppTextStyles.blackSubHeadingStyle()
                                                  .copyWith(
                                                    fontSize:
                                                        14 *
                                                        SizeConfig.widthScale,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                        ),
                                        SizedBox(
                                          height: 5 * SizeConfig.heightScale,
                                        ),
                                        Text(
                                          product.totalPrice ?? "N/A",
                                          style: AppTextStyles.redw400Outfit()
                                              .copyWith(
                                                fontSize:
                                                    14 * SizeConfig.widthScale,
                                                fontWeight: FontWeight.w400,
                                              ),
                                        ),
                                        SizedBox(
                                          height: 5 * SizeConfig.heightScale,
                                        ),

                                        // Edit and Delete Buttons
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            EditProductScreen(
                                                              product: product,
                                                            ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      10 *
                                                      SizeConfig.widthScale,
                                                  vertical:
                                                      5 *
                                                      SizeConfig.heightScale,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: const Color.fromRGBO(
                                                      219,
                                                      233,
                                                      233,
                                                      1,
                                                    ),
                                                    width: 0.94,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        22 *
                                                            SizeConfig
                                                                .heightScale,
                                                      ),
                                                ),
                                                child: Text(
                                                  'Edit',
                                                  style:
                                                      AppTextStyles.blackSubHeadingStyle()
                                                          .copyWith(
                                                            fontSize:
                                                                14 *
                                                                SizeConfig
                                                                    .widthScale,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5 * SizeConfig.widthScale,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (context) => DeletePopUp(
                                                        message:
                                                            'Are you sure you want to delete this product?',
                                                        onPressed: () {
                                                          productProvider
                                                              .deleteProduct(
                                                                product.id ?? 0,
                                                              );
                                                          productProvider
                                                              .fetchProducts();
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                      ),
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      10 *
                                                      SizeConfig.widthScale,
                                                  vertical:
                                                      5 *
                                                      SizeConfig.heightScale,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: const Color.fromRGBO(
                                                      219,
                                                      233,
                                                      233,
                                                      1,
                                                    ),
                                                    width: 0.94,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        22 *
                                                            SizeConfig
                                                                .heightScale,
                                                      ),
                                                ),
                                                child: Text(
                                                  'Delete',
                                                  style:
                                                      AppTextStyles.blackSubHeadingStyle()
                                                          .copyWith(
                                                            fontSize:
                                                                14 *
                                                                SizeConfig
                                                                    .widthScale,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
