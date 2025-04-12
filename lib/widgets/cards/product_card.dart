import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/utils/custom_network_image.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:flutter/material.dart';

class ProductCardWidget extends StatefulWidget {
  final Map<String, dynamic> data;

  const ProductCardWidget({super.key, required this.data});

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

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.data["imageUrl"] ?? '';
    final discount = widget.data["discount"] ?? '';
    final productName = widget.data["name"] ?? '';
    final productType = widget.data["productType"] ?? '';
    final productPrice = widget.data["price"].toString();

    return Container(
      width: 160 * SizeConfig.widthScale,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                child: CustomNetworkImage(
                  imageUrl: imageUrl,
                  errorImage: 'assets/icons/no-image.png',
                  height: 120 * SizeConfig.heightScale,
                  width: double.infinity,
                  radius: 0,
                ),
              ),
              if (discount.isNotEmpty)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(243, 120, 102, 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      discount,
                      style: AppTextStyles.whitew400Outfit().copyWith(
                        fontSize: 10 * SizeConfig.widthScale,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 10 * SizeConfig.heightScale),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                ...List.generate(
                  4,
                  (index) => const Icon(
                    Icons.star,
                    size: 12,
                    color: Color.fromRGBO(255, 186, 73, 1),
                  ),
                ),
                const Icon(
                  Icons.star_half,
                  size: 12,
                  color: Color.fromRGBO(255, 186, 73, 1),
                ),
                Text(
                  " (10)",
                  style: AppTextStyles.greySubHeadingStyle().copyWith(
                    fontSize: 8 * SizeConfig.widthScale,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4 * SizeConfig.heightScale),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      productType,
                      style: AppTextStyles.greySubHeadingStyle().copyWith(
                        fontSize: 9 * SizeConfig.widthScale,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.blackSubHeadingStyle().copyWith(
                        fontSize: 10 * SizeConfig.widthScale,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Add to cart logic
                    },
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
                  onTap: toggleFavorite,
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
    );
  }
}
