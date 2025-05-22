import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/models/store.dart';
import 'package:customer_app/providers/store_provider.dart';
import 'package:customer_app/screens/view_all/store_products_grid.dart';
import 'package:customer_app/utils/custom_network_image.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:customer_app/widgets/cards/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreDetails extends StatefulWidget {
  Store? storeDetails;
  String? storeImageUrl;
  String? storeCoverImageUrl;
  StoreDetails({
    super.key,
    this.storeCoverImageUrl,
    this.storeImageUrl,
    this.storeDetails,
  });

  @override
  State<StoreDetails> createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  bool isFollowLoading = false;
  bool isFollowed = false;
  Store? _storeDetails;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final storeProvider = Provider.of<StoreProvider>(context, listen: false);
      storeProvider.fetchStoreProducts(widget.storeDetails?.id, page: 1);
      storeProvider.fetchStoreDetails(widget.storeDetails?.id ?? 0).then((_) {
        setState(() {
          isFollowed = storeProvider.storeDetails?.isFollowed ?? false;
          _storeDetails = storeProvider.storeDetails;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20 * SizeConfig.widthScale),
          padding: EdgeInsets.all(20 * SizeConfig.widthScale),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.37),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 3,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Cover Image
                  ClipRRect(
                    child: Image.network(
                      '${_storeDetails?.coverImage}/${_storeDetails?.coverImage}',
                      width: double.infinity,
                      height: 200 * SizeConfig.heightScale,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 200 * SizeConfig.heightScale,
                          color: Colors.grey[300],
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: -20 * SizeConfig.heightScale,
                    left: -10 * SizeConfig.heightScale,
                    child: CircleAvatar(
                      radius: 40 * SizeConfig.widthScale,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: CustomNetworkImage(
                          imageUrl:
                              '${_storeDetails?.imagePath}/${_storeDetails?.logo}',
                          width: 40 * SizeConfig.widthScale,
                          height: 40 * SizeConfig.widthScale,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30 * SizeConfig.heightScale),
              Divider(thickness: 1, color: Colors.grey[300]),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10 * SizeConfig.widthScale,
                  vertical: 10 * SizeConfig.heightScale,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.storeDetails?.name ?? 'Store Name',
                          style: AppTextStyles.blackSubHeadingStyle().copyWith(
                            fontSize: 20 * SizeConfig.widthScale,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        isFollowLoading
                            ? const CircularProgressIndicator(strokeWidth: 2)
                            : Container(
                              width: 60 * SizeConfig.widthScale,
                              height: 30 * SizeConfig.heightScale,
                              decoration: BoxDecoration(
                                color: isFollowed ? Colors.grey : Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color:
                                      isFollowed
                                          ? Color.fromRGBO(250, 250, 250, 0.8)
                                          : const Color.fromRGBO(0, 0, 0, 0.8),
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() => isFollowLoading = true);
                                  final storeId = widget.storeDetails?.id;
                                  final storeProvider =
                                      Provider.of<StoreProvider>(
                                        context,
                                        listen: false,
                                      );
                                  bool success;
                                  if (isFollowed) {
                                    success = await storeProvider.unfollowStore(
                                      storeId!,
                                    );
                                    if (success) {
                                      setState(() => isFollowed = false);
                                    }
                                  } else {
                                    success = await storeProvider.followStore(
                                      storeId!,
                                    );
                                    if (success) {
                                      setState(() => isFollowed = true);
                                    }
                                  }
                                  setState(() => isFollowLoading = false);
                                },
                                child:
                                    isFollowLoading
                                        ? const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        )
                                        : Center(
                                          child: Text(
                                            isFollowed ? 'Unfollow' : 'Follow',
                                            style: AppTextStyles.blackSubHeadingStyle()
                                                .copyWith(
                                                  fontSize:
                                                      12 *
                                                      SizeConfig.widthScale,
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      isFollowed
                                                          ? Colors.white
                                                          : const Color.fromRGBO(
                                                            0,
                                                            0,
                                                            0,
                                                            0.8,
                                                          ),
                                                ),
                                          ),
                                        ),
                              ),
                            ),
                      ],
                    ),
                    SizedBox(height: 10 * SizeConfig.heightScale),
                    Text(
                      widget.storeDetails?.description ??
                          'Store description...',
                      style: AppTextStyles.greySubHeadingStyle(
                        color: const Color.fromRGBO(0, 0, 0, 0.8),
                      ).copyWith(
                        fontSize: 12 * SizeConfig.widthScale,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10 * SizeConfig.heightScale),
                    Text(
                      'Store Address',
                      style: AppTextStyles.blackSubHeadingStyle().copyWith(
                        fontSize: 14 * SizeConfig.widthScale,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      widget.storeDetails?.address ?? 'Address not available',
                      style: AppTextStyles.greySubHeadingStyle(
                        color: const Color.fromRGBO(0, 0, 0, 0.8),
                      ).copyWith(
                        fontSize: 12 * SizeConfig.widthScale,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10 * SizeConfig.heightScale),
                    Text(
                      'Pincode',
                      style: AppTextStyles.blackSubHeadingStyle().copyWith(
                        fontSize: 14 * SizeConfig.widthScale,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      widget.storeDetails?.pincode.toString() ??
                          'Pincode not available',
                      style: AppTextStyles.greySubHeadingStyle(
                        color: const Color.fromRGBO(0, 0, 0, 0.8),
                      ).copyWith(
                        fontSize: 12 * SizeConfig.widthScale,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10 * SizeConfig.heightScale),
                    Text(
                      'Business Hours',
                      style: AppTextStyles.blackSubHeadingStyle().copyWith(
                        fontSize: 14 * SizeConfig.widthScale,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      widget.storeDetails?.businessHours ??
                          'hours not available',
                      style: AppTextStyles.greySubHeadingStyle(
                        color: const Color.fromRGBO(0, 0, 0, 0.8),
                      ).copyWith(
                        fontSize: 12 * SizeConfig.widthScale,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (widget.storeDetails?.storeLink != null &&
                        widget.storeDetails!.storeLink!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10 * SizeConfig.heightScale),
                          Text(
                            'Store Link',
                            style: AppTextStyles.blackSubHeadingStyle()
                                .copyWith(
                                  fontSize: 14 * SizeConfig.widthScale,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final Uri url = Uri.parse(
                                widget.storeDetails!.storeLink!,
                              );
                              if (await canLaunchUrl(url)) {
                                await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Could not open the link'),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              widget.storeDetails!.storeLink!,
                              style: AppTextStyles.greySubHeadingStyle(
                                color: Colors.blue,
                              ).copyWith(
                                fontSize: 12 * SizeConfig.widthScale,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Store products",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => StoreProductsGrid(
                                  storeId: _storeDetails?.id,
                                ),
                          ),
                        );
                      },
                      child: const Text(
                        "View all",
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
              Consumer<StoreProvider>(
                builder: (context, provider, _) {
                  final products = provider.storeProducts;

                  if (provider.isLoading) {
                    return const SizedBox(
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (products.isEmpty) {
                    return const SizedBox(
                      height: 100,
                      child: Center(child: Text("No products available")),
                    );
                  }

                  return Container(
                    height: 350 * SizeConfig.heightScale,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1,
                          spreadRadius: 0,
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.37),
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ProductCardWidget(
                          data: products[index],
                          imageURL: provider.productBaseImageUrl,
                          onWishlistTap: () {},
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
