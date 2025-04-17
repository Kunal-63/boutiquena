import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/config/text_styles.dart';
import 'package:vendor_app/models/product.dart';
import 'package:vendor_app/models/product_details.dart';
import 'package:vendor_app/providers/product_provider.dart';
import 'package:vendor_app/screens/products/edit_product.dart';
import 'package:vendor_app/utils/custom_network_image.dart';
import 'package:vendor_app/utils/size_config.dart';
import 'package:vendor_app/widgets/headers/common_appbar.dart';
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
  final PageController _pageController = PageController(viewportFraction: 0.75);
  ProductDetail? _productDetail;

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

    super.initState();

    if (widget.productID != null) {
      _loadProductDetail(widget.productID!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: CommonAppBar(
          title: "Dorothy Perkins",
          menuPressed: () {},
          menuItems: [
            PopupMenuItem<int>(
              value: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Close popup first
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => EditProductScreen(
                            productID:
                                widget
                                    .productID, // pass the current product instance here
                          ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    SvgPicture.asset('assets/icons/edit-popup-icon.svg'),
                    const SizedBox(width: 10),
                    const Text('Edit'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30.0 * SizeConfig.widthScale),
        child: Container(
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
              Stack(
                children: [
                  SizedBox(
                    height: 220,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _productDetail?.images?.length,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() {});
                      },
                      itemBuilder: (context, index) {
                        return AnimatedBuilder(
                          animation: _pageController,
                          builder: (context, child) {
                            double scale = 0.9;
                            double height = 200;

                            if (_pageController.position.haveDimensions) {
                              double page = _pageController.page ?? 0.0;
                              double difference = (page - index).abs();
                              scale = (1 - (0.2 * difference)).clamp(0.8, 1.0);
                              height = scale == 1.0 ? 220 : 200;
                            }
                            return Center(
                              child: SizedBox(
                                height: height,
                                child: Transform.scale(
                                  scale: scale,
                                  child: Container(
                                    // margin: const EdgeInsets.symmetric(horizontal: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: CustomNetworkImage(
                                      imageUrl:
                                          '${_productDetail?.imagesLargeUrl}/${_productDetail?.images?[index].image}' ??
                                          'assets/icons/no-image.png',
                                      fit: BoxFit.cover,
                                      errorImage: 'assets/icons/no-image.png',
                                      radius: 10,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(243, 120, 102, 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        _productDetail?.vendorPrice ?? '0',
                        style: AppTextStyles.whitew400Outfit().copyWith(
                          fontSize: 10 * SizeConfig.widthScale,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
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
                  Column(
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
                        style: AppTextStyles.blackSubHeadingStyle().copyWith(
                          fontSize: 16 * SizeConfig.widthScale,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
                "Meta Title:",
                style: AppTextStyles.blackSubHeadingStyle().copyWith(
                  fontSize: 16 * SizeConfig.heightScale,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 5 * SizeConfig.heightScale),
              Text(
                _productDetail?.metaTitle ?? "Product Meta Keywords",
                style: AppTextStyles.greySubHeadingStyle(
                  color: const Color.fromRGBO(0, 0, 0, 0.5),
                ).copyWith(
                  fontSize: 12 * SizeConfig.widthScale,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              Text(
                "Meta Keywords:",
                style: AppTextStyles.blackSubHeadingStyle().copyWith(
                  fontSize: 16 * SizeConfig.heightScale,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 5 * SizeConfig.heightScale),
              Text(
                _productDetail?.metaKeywords ?? "Product Meta Keywords",
                style: AppTextStyles.greySubHeadingStyle(
                  color: const Color.fromRGBO(0, 0, 0, 0.5),
                ).copyWith(
                  fontSize: 12 * SizeConfig.widthScale,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              Text(
                "Meta Description:",
                style: AppTextStyles.blackSubHeadingStyle().copyWith(
                  fontSize: 16 * SizeConfig.heightScale,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 5 * SizeConfig.heightScale),
              Text(
                _productDetail?.metaDescription ?? "Product Meta Description",
                style: AppTextStyles.greySubHeadingStyle(
                  color: const Color.fromRGBO(0, 0, 0, 0.5),
                ).copyWith(
                  fontSize: 12 * SizeConfig.widthScale,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
            ],
          ),
        ),
      ),
    );
  }
}
