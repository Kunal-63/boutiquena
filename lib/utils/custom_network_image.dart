import 'package:customer_app/config/theme.dart';
import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final String errorImage;
  final double radius;
  final BoxFit fit;
  final double? height;
  final double? width;

  const CustomNetworkImage({
    required this.imageUrl,
    required this.errorImage,
    this.radius = 0.0,
    this.fit = BoxFit.cover,
    this.height,
    this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(
        imageUrl,
        fit: fit,
        height: height,
        width: width,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset(errorImage, fit: fit, height: height, width: width),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        },
      ),
    );
  }
}
