import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/models/product_details.dart';
import 'package:customer_app/providers/wishlist_provider.dart';
import 'package:customer_app/screens/main_screen.dart';
import 'package:customer_app/screens/products/product_details.dart';
import 'package:customer_app/utils/custom_network_image.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCardWidget extends StatefulWidget {
  final ProductDetail data;
  final String? imageURL;
  final VoidCallback? onWishlistTap;

  const ProductCardWidget({
    super.key,
    required this.data,
    required this.imageURL,
    this.onWishlistTap,
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
    if (widget.data.isInCart == true) {
      MainScreen.selectedIndexNotifier.value = 2;
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ProductDetailsScreen(productID: widget.data.id ?? 0),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = '${widget.imageURL}/${widget.data.productImage}';
    final productName = widget.data.productName ?? '';
    final productType = widget.data.description ?? '';
    final productPrice = widget.data.totalPrice.toString();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    ProductDetailsScreen(productID: widget.data.id ?? 0),
          ),
        );
      },
      child: Container(
        width: 160 * SizeConfig.widthScale,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
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
                  height: 200 * SizeConfig.heightScale,
                  width: double.infinity,
                  radius: 0,
                ),
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  productName,
                  style: AppTextStyles.blackSubHeadingStyle().copyWith(
                    fontSize: 12 * SizeConfig.widthScale,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  productType,
                  style: AppTextStyles.greySubHeadingStyle().copyWith(
                    fontSize: 11 * SizeConfig.widthScale,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4,
                ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 3,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _navigateToProductDetails(context),
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                          size: 14,
                        ),
                        label: Text(
                          widget.data.isInCart == true
                              ? "Go to cart"
                              : "Add to cart",
                          style: TextStyle(
                            fontSize: 10 * SizeConfig.widthScale,
                          ),
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
                        await Future.microtask(
                          () => Provider.of<WishlistProvider>(
                            context,
                            listen: false,
                          ).toggleWishlist((widget.data.id.toString())),
                        );
                        widget.onWishlistTap?.call();
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
                          widget.data.isInWishlist == true
                              ? Icons.favorite
                              : Icons.favorite_border_rounded,
                          color:
                              widget.data.isInWishlist == true
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
      ),
    );
  }
}
