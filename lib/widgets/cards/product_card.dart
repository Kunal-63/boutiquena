import 'package:vendor_app/config/text_styles.dart';
import 'package:vendor_app/models/product.dart';
import 'package:vendor_app/utils/custom_network_image.dart';
import 'package:vendor_app/utils/size_config.dart';
import 'package:flutter/material.dart';

class ProductCardWidget extends StatefulWidget {
  final Product product;

  const ProductCardWidget({super.key, required this.product});

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
    return Container(
      margin: const EdgeInsets.all(8.0),
      width: 150 * SizeConfig.widthScale,
      height: 200 * SizeConfig.heightScale,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CustomNetworkImage(
                imageUrl: widget.product.imageUrl,
                errorImage: 'assets/icons/no-image.png',
                height: 120 * SizeConfig.heightScale,
                width: double.infinity,
                radius: 5,
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(243, 120, 102, 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    widget.product.discount,
                    style: AppTextStyles.whitew400Outfit().copyWith(
                      fontSize: 10 * SizeConfig.widthScale,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -10,
                right: 0,
                child: GestureDetector(
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
                    child: Center(
                      child: Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border_rounded,
                        color:
                            isFavorite
                                ? const Color.fromRGBO(243, 120, 102, 1)
                                : const Color.fromRGBO(0, 0, 0, 0.5),
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ...List.generate(
                4,
                (index) => const Icon(
                  Icons.star,
                  color: Color.fromRGBO(255, 186, 73, 1),
                  size: 10,
                ),
              ),
              const Icon(
                Icons.star_half,
                color: Color.fromRGBO(255, 186, 73, 1),
                size: 10,
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
          const SizedBox(height: 4),
          Text(
            widget.product.productType,
            style: AppTextStyles.greySubHeadingStyle().copyWith(
              fontSize: 8 * SizeConfig.widthScale,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.product.name,
            style: AppTextStyles.blackSubHeadingStyle().copyWith(
              fontSize: 10 * SizeConfig.widthScale,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${widget.product.price} ₪",
            style: AppTextStyles.redw400Outfit().copyWith(
              fontSize: 12 * SizeConfig.widthScale,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
