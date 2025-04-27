import 'package:customer_app/widgets/buttons/submit_button.dart';
import 'package:customer_app/widgets/inputs/dropdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/models/product.dart';
import 'package:customer_app/models/product_details.dart';
import 'package:customer_app/providers/product_provider.dart';
import 'package:customer_app/utils/custom_network_image.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:customer_app/widgets/headers/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int? productID;

  const ProductDetailsScreen({super.key, this.productID});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int selectedSizeIndex = -1;
  final PageController _pageController = PageController(viewportFraction: 1.0);
  ProductDetail? _productDetail;
  int? selectedAttributeId;

  Future<void> _loadProductDetail(int id) async {
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    await productProvider.fetchProductDetailById(id);

    setState(() {
      _productDetail = productProvider.selectedProductDetail;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.productID != null) {
      _loadProductDetail(widget.productID!);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0 * SizeConfig.widthScale),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.37),
                color: const Color.fromRGBO(255, 255, 255, 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 3,
                    spreadRadius: 0,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Color.fromRGBO(112, 112, 112, 1),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Store: ${_productDetail?.storeName}',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.greySubHeadingStyle().copyWith(
                      fontSize: 12 * SizeConfig.widthScale,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {
                      // Handle favorite toggle here
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10 * SizeConfig.heightScale),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.37),
                color: const Color.fromRGBO(255, 255, 255, 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 3,
                    spreadRadius: 0,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 350,
                    width: double.infinity,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _productDetail?.images?.length ?? 0,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final imageUrl =
                            '${_productDetail?.imagesLargeUrl}/${_productDetail?.images?[index].image}';
                        return Container(
                          width: double.infinity,
                          margin: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CustomNetworkImage(
                              imageUrl:
                                  imageUrl.isNotEmpty
                                      ? imageUrl
                                      : 'assets/icons/no-image.png',
                              fit: BoxFit.cover,
                              errorImage: 'assets/icons/no-image.png',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20 * SizeConfig.heightScale),
                  Align(
                    alignment: Alignment.center,
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: 3,
                      effect: const ExpandingDotsEffect(
                        dotHeight: 4,
                        dotWidth: 4,
                        activeDotColor: Color.fromRGBO(0, 0, 0, 1),
                        dotColor: Color.fromRGBO(0, 0, 0, 1),
                      ),
                    ),
                  ),
                  SizedBox(height: 5 * SizeConfig.heightScale),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _productDetail?.metaTitle ?? "Product Name",
                              style: AppTextStyles.greySubHeadingStyle(
                                color: const Color.fromRGBO(0, 0, 0, 0.8),
                              ).copyWith(
                                fontSize: 12 * SizeConfig.widthScale,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 5 * SizeConfig.heightScale),
                            Text(
                              '${_productDetail?.productName ?? '..'} | ${_productDetail?.productNameArabic ?? '..'} | ${_productDetail?.productNameHebrew ?? '..'}' ??
                                  "Product Name",
                              style: AppTextStyles.blackSubHeadingStyle()
                                  .copyWith(
                                    fontSize: 16 * SizeConfig.widthScale,
                                    fontWeight: FontWeight.w400,
                                  ),

                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "${_productDetail?.totalPrice} ₪",
                        style: AppTextStyles.redw400Outfit().copyWith(
                          fontSize: 24 * SizeConfig.heightScale,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10 * SizeConfig.heightScale),
                  const Divider(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    thickness: 0.5,
                  ),
                  SizedBox(height: 10 * SizeConfig.heightScale),
                  Text(
                    "Description:",
                    style: AppTextStyles.blackSubHeadingStyle().copyWith(
                      fontSize: 16 * SizeConfig.heightScale,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 5 * SizeConfig.heightScale),
                  Text(
                    _productDetail?.description ?? "Product Description",
                    style: AppTextStyles.greySubHeadingStyle(
                      color: const Color.fromRGBO(0, 0, 0, 0.5),
                    ).copyWith(
                      fontSize: 12 * SizeConfig.widthScale,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 20 * SizeConfig.heightScale),

                  Text(
                    "Short Description:",
                    style: AppTextStyles.blackSubHeadingStyle().copyWith(
                      fontSize: 16 * SizeConfig.heightScale,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 5 * SizeConfig.heightScale),
                  Text(
                    _productDetail?.shortDescription ?? "Product Meta Keywords",
                    style: AppTextStyles.greySubHeadingStyle(
                      color: const Color.fromRGBO(0, 0, 0, 0.5),
                    ).copyWith(
                      fontSize: 12 * SizeConfig.widthScale,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 20 * SizeConfig.heightScale),
                  // Text(
                  //   "Meta Keywords:",
                  //   style: AppTextStyles.blackSubHeadingStyle().copyWith(
                  //     fontSize: 16 * SizeConfig.heightScale,
                  //     fontWeight: FontWeight.w400,
                  //   ),
                  // ),
                  // SizedBox(height: 5 * SizeConfig.heightScale),
                  // Text(
                  //   _productDetail?.metaKeywords ?? "Product Meta Keywords",
                  //   style: AppTextStyles.greySubHeadingStyle(
                  //     color: const Color.fromRGBO(0, 0, 0, 0.5),
                  //   ).copyWith(
                  //     fontSize: 12 * SizeConfig.widthScale,
                  //     fontWeight: FontWeight.w300,
                  //   ),
                  // ),
                  // SizedBox(height: 20 * SizeConfig.heightScale),
                  // Text(
                  //   "Meta Description:",
                  //   style: AppTextStyles.blackSubHeadingStyle().copyWith(
                  //     fontSize: 16 * SizeConfig.heightScale,
                  //     fontWeight: FontWeight.w400,
                  //   ),
                  // ),
                  // SizedBox(height: 5 * SizeConfig.heightScale),
                  // Text(
                  //   _productDetail?.metaDescription ?? "Product Meta Description",
                  //   style: AppTextStyles.greySubHeadingStyle(
                  //     color: const Color.fromRGBO(0, 0, 0, 0.5),
                  //   ).copyWith(
                  //     fontSize: 12 * SizeConfig.widthScale,
                  //     fontWeight: FontWeight.w300,
                  //   ),
                  // ),
                  // SizedBox(height: 20 * SizeConfig.heightScale),
                  Text(
                    "Product Attributes:",
                    style: AppTextStyles.blackSubHeadingStyle().copyWith(
                      fontSize: 16 * SizeConfig.heightScale,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 5 * SizeConfig.heightScale),
                  _productDetail?.attributes != null &&
                          _productDetail!.attributes!.isNotEmpty
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            _productDetail!.attributes!.entries.map((entry) {
                              String attributeName = entry.key;
                              List<AttributeValue> attributeList =
                                  List<AttributeValue>.from(entry.value);

                              // Map value -> id
                              Map<String, int> valueIdMap = {
                                for (var item in attributeList)
                                  item.value.toString(): item.id ?? 0,
                              };

                              List<String> attributeValues =
                                  valueIdMap.keys.toList();

                              return CustomDropdown(
                                items: attributeValues,
                                onChanged: (selectedValue) {
                                  int selectedId = valueIdMap[selectedValue]!;
                                  print(
                                    'Selected $attributeName: $selectedValue (ID: $selectedId)',
                                  );
                                  // You can save the selectedId if needed
                                },
                                label: attributeName,
                              );
                            }).toList(),
                      )
                      : Text(
                        "No attributes available.",
                        style: AppTextStyles.greySubHeadingStyle().copyWith(
                          color: const Color.fromRGBO(0, 0, 0, 0.5),
                          fontSize: 12 * SizeConfig.widthScale,
                          fontWeight: FontWeight.w300,
                        ),
                      ),

                  SizedBox(height: 20 * SizeConfig.heightScale),
                  _productDetail?.isInCart != true
                      ? SubmitButton(
                        text: 'Add to Cart',
                        onPressed: () {},

                        isTransparent: true,
                      )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
