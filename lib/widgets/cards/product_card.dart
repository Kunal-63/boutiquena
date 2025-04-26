import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/models/product.dart';
import 'package:customer_app/providers/wishlist_provider.dart';
import 'package:customer_app/screens/products/product_details.dart';
import 'package:customer_app/utils/custom_network_image.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCardWidget extends StatefulWidget {
  final Product data;
  final String? imageURL;

  const ProductCardWidget({
    super.key,
    required this.data,
    required this.imageURL,
  });

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  bool isFavorite = false;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void _navigateToProductDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ProductDetailsScreen(productID: widget.data.id ?? 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = '${widget.imageURL}/${widget.data.productImage}';
    final productName = widget.data.productName ?? '';
    final productType = widget.data.description ?? '';
    final productPrice = widget.data.totalPrice.toString();

    return Container(
      width: 160 * SizeConfig.widthScale,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        // Make the content scrollable
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: CustomNetworkImage(
                imageUrl: imageUrl,
                errorImage: 'assets/icons/no-image.png',
                height: 100 * SizeConfig.heightScale,
                width: double.infinity,
                radius: 0,
              ),
            ),
            SizedBox(height: 10 * SizeConfig.heightScale),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                productType,
                style: AppTextStyles.greySubHeadingStyle().copyWith(
                  fontSize: 9 * SizeConfig.widthScale,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                productName,
                style: AppTextStyles.blackSubHeadingStyle().copyWith(
                  fontSize: 10 * SizeConfig.widthScale,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "$productPrice ₪",
                      style: AppTextStyles.redw400Outfit().copyWith(
                        fontSize: 12 * SizeConfig.widthScale,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _navigateToProductDetails(context),
                      icon: const Icon(Icons.shopping_cart_outlined, size: 14),
                      label: Text(
                        "Add to cart",
                        style: TextStyle(fontSize: 10 * SizeConfig.widthScale),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(30),
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
                      Future.microtask(
                        () => Provider.of<WishlistProvider>(
                          context,
                          listen: false,
                        ).toggleWishlist((widget.data.id.toString())),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                            blurRadius: 3,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border_rounded,
                        color:
                            isFavorite
                                ? const Color.fromRGBO(243, 120, 102, 1)
                                : const Color.fromRGBO(0, 0, 0, 0.5),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
