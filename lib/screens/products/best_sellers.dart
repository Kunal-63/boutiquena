import 'package:customer_app/models/product_details.dart';
import 'package:customer_app/providers/home_screen_provider.dart';
import 'package:customer_app/providers/wishlist_provider.dart';
import 'package:customer_app/screens/products/product_details.dart';
import 'package:customer_app/screens/view_all/best_seller_products_grid.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BestSellersSection extends StatelessWidget {
  final List<ProductDetail> products;
  final String? imageURL;

  const BestSellersSection({
    super.key,
    required this.products,
    required this.imageURL,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Best Sellers",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BestSellerProductsGrid(),
                    ),
                  );
                },
                child: Text(
                  "See all",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (products.isEmpty)
          const Center(
            child: Text(
              "No products available",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ),
        if (products.isNotEmpty) const SizedBox(height: 12),
        if (products.isNotEmpty)
          Container(
            height: 350 * SizeConfig.heightScale,
            padding: EdgeInsets.all(10 * SizeConfig.widthScale),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.06),
                  blurRadius: 3,
                  spreadRadius: 0,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Consumer<HomeScreenProvider>(
              builder: (context, provider, _) {
                final products = provider.bestSellerProducts;

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return BestSellerCard(
                      data: products[index],
                      imageURL: imageURL,
                    );
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

class BestSellerCard extends StatelessWidget {
  final ProductDetail data;
  final String? imageURL;

  const BestSellerCard({super.key, required this.data, required this.imageURL});

  void _navigateToProductDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(productID: data.id ?? 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = '$imageURL/${data.productImage}';
    final title = data.productName;
    final brand = data.description ?? '';
    final price = data.totalPrice?.toString() ?? '10';

    return Container(
      width: 170 * SizeConfig.widthScale,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              height: 200 * SizeConfig.heightScale,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) => Container(
                    height: 90,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported),
                  ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wrap title and brand in Expanded to prevent overflow
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      brand,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Text(
                "$price ₪",
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _iconButton(
                Icons.shopping_cart_outlined,
                () => _navigateToProductDetails(
                  context,
                ), // Wrap the call in a lambda function
              ),
              const SizedBox(width: 8),
              _iconButton(
                data.isInWishlist == true
                    ? Icons.favorite
                    : Icons.favorite_border,
                () async {
                  await Future.microtask(
                    () => Provider.of<WishlistProvider>(
                      context,
                      listen: false,
                    ).toggleWishlist((data.id.toString())),
                  );
                  await Future.microtask(
                    () =>
                        Provider.of<HomeScreenProvider>(
                          context,
                          listen: false,
                        ).fetchBestSellerProducts(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback? onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: 16,
          color: icon == Icons.favorite ? Colors.red : null,
        ),
      ),
    );
  }
}
