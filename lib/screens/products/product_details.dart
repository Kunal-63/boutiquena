import 'package:customer_app/providers/cart_provider.dart';
import 'package:customer_app/providers/wishlist_provider.dart';
import 'package:customer_app/screens/main_screen.dart';
import 'package:customer_app/widgets/buttons/submit_button.dart';
import 'package:customer_app/widgets/cards/product_card.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/models/product_details.dart';
import 'package:customer_app/providers/product_provider.dart';
import 'package:customer_app/utils/custom_network_image.dart';
import 'package:customer_app/utils/size_config.dart';
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
  Map<String, List<SkuRecord>> colorGroupedSkus = {};
  String? selectedColor;
  int? selectedSkuId;
  String? selectedSize;

  List<ProductDetail> _similarProducts = [];

  Future<void> _loadProductDetail(int id) async {
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    await productProvider.fetchProductDetailById(id);
    await productProvider.fetchSimilarProducts(id);

    final product = productProvider.selectedProductDetail;

    final Map<String, List<SkuRecord>> groupedSkus = {};

    if (product?.skuRecords != null) {
      final allSkus = product!.skuRecords!.values.expand((list) => list);
      for (var sku in allSkus) {
        if (sku.attributeValueName != null) {
          final colorKey =
              (sku.colorName == null || sku.colorName == 'undefined')
                  ? 'undefined'
                  : sku.colorName!;
          groupedSkus.putIfAbsent(colorKey, () => []).add(sku);
        }
      }
    }

    setState(() {
      _productDetail = product;
      _similarProducts = productProvider.similarProducts;
      colorGroupedSkus = groupedSkus;

      // Select the first available color if not already selected
      if (groupedSkus.isNotEmpty && selectedColor == null) {
        selectedColor = groupedSkus.keys.first;

        // Also select a default size for that color if available
        final defaultSkus = groupedSkus[selectedColor];
        if (defaultSkus != null && defaultSkus.isNotEmpty) {
          selectedSize = defaultSkus.first.attributeValueName;
          selectedSkuId = defaultSkus.first.id;
          selectedAttributeId = defaultSkus.first.attributeId;
        }
      }
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: Container(
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.37),
            color: const Color.fromRGBO(255, 255, 255, 1),
          ),
          // padding: const EdgeInsets.all(10),
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
                icon: Icon(
                  _productDetail?.isInWishlist == true
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color:
                      _productDetail?.isInWishlist == true
                          ? Colors.redAccent
                          : null,
                ),
                onPressed: () async {
                  await Future.microtask(
                    () => Provider.of<WishlistProvider>(
                      context,
                      listen: false,
                    ).toggleWishlist((_productDetail?.id.toString() ?? '0')),
                  );
                  _loadProductDetail(_productDetail?.id ?? 0);
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0 * SizeConfig.widthScale),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 350 * SizeConfig.widthScale,
                    width: double.infinity,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _productDetail?.images?.length ?? 0,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final imageUrl =
                            '${_productDetail?.imagesSmallUrl}/${_productDetail?.images?[index].image}';
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
                              '${_productDetail?.productName ?? '..'} ',
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
                  if (selectedColor != null &&
                      colorGroupedSkus[selectedColor!] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16 * SizeConfig.heightScale),
                        Text(
                          "Sizes:",
                          style: AppTextStyles.blackSubHeadingStyle().copyWith(
                            fontSize: 16 * SizeConfig.heightScale,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 8 * SizeConfig.heightScale),
                        Wrap(
                          spacing: 10 * SizeConfig.widthScale,
                          children:
                              colorGroupedSkus[selectedColor!]!
                                  .map((sku) => sku.attributeValueName!)
                                  .toSet()
                                  .map(
                                    (size) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedSize = size;
                                          selectedSkuId =
                                              colorGroupedSkus[selectedColor!]!
                                                  .firstWhere(
                                                    (sku) =>
                                                        sku.attributeValueName ==
                                                        size,
                                                  )
                                                  .id;
                                          selectedAttributeId =
                                              colorGroupedSkus[selectedColor!]!
                                                  .firstWhere(
                                                    (sku) =>
                                                        sku.attributeValueName ==
                                                        size,
                                                  )
                                                  .attributeId;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              10 * SizeConfig.widthScale,
                                          vertical: 6 * SizeConfig.heightScale,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              selectedSize == size
                                                  ? Colors.redAccent
                                                  : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          border: Border.all(
                                            color:
                                                selectedSize == size
                                                    ? Colors.redAccent
                                                    : Colors.grey.shade400,
                                          ),
                                        ),
                                        child: Text(
                                          size,
                                          style:
                                              AppTextStyles.blackSubHeadingStyle()
                                                  .copyWith(
                                                    fontSize:
                                                        14 *
                                                        SizeConfig.widthScale,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        selectedSize == size
                                                            ? Colors.white
                                                            : Colors.black,
                                                  ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ],
                    ),

                  SizedBox(height: 20 * SizeConfig.heightScale),
                  Text(
                    "Colours:",
                    style: AppTextStyles.blackSubHeadingStyle().copyWith(
                      fontSize: 16 * SizeConfig.heightScale,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8 * SizeConfig.heightScale),
                  Wrap(
                    spacing: 10 * SizeConfig.widthScale,
                    runSpacing: 8 * SizeConfig.heightScale,
                    children:
                        colorGroupedSkus.entries
                            .where(
                              (entry) =>
                                  entry.value.first.colorHex != null &&
                                  entry.value.first.colorHex != 'undefined',
                            )
                            .map((entry) {
                              final colorName = entry.key;
                              final sku =
                                  entry.value.first; // Just for hex & id
                              final hexCode = sku.colorHex!.replaceFirst(
                                '#',
                                '0xFF',
                              );
                              final color = Color(int.parse(hexCode));
                              final skuId = sku.id ?? 0;

                              return colorOption(colorName, color, skuId);
                            })
                            .toList(),
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
                  Html(
                    data:
                        _productDetail?.shortDescription ??
                        "<p>No description available</p>",
                    style: {
                      // ---- Base text -----------------------------------------------------------------
                      "body": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.all(0),
                        color: const Color.fromRGBO(0, 0, 0, 0.5),
                        fontSize: FontSize(12 * SizeConfig.widthScale),
                        fontWeight: FontWeight.w300,
                        fontFamily:
                            AppTextStyles.greySubHeadingStyle().fontFamily,
                      ),

                      // ---- Paragraphs ----------------------------------------------------------------
                      "p": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.all(0),
                      ),

                      // ---- Headings (h1‒h6) ----------------------------------------------------------
                      for (final h in ['h1', 'h2', 'h3', 'h4', 'h5', 'h6'])
                        h: Style(
                          margin: Margins.only(bottom: 4),
                          padding: HtmlPaddings.all(0),
                          fontWeight: FontWeight.w600, // a bit bolder
                        ),

                      // ---- Unordered lists -----------------------------------------------------------
                      "ul": Style(
                        margin: Margins.only(left: 18, top: 4, bottom: 4),
                        padding: HtmlPaddings.all(0),
                      ),

                      // ---- Ordered lists -------------------------------------------------------------
                      "ol": Style(
                        margin: Margins.only(left: 18, top: 4, bottom: 4),
                        padding: HtmlPaddings.all(0),
                      ),

                      // ---- List items ---------------------------------------------------------------
                      "li": Style(
                        margin: Margins.only(bottom: 2),
                        padding: HtmlPaddings.all(0),
                        // bullet and number size follows list text automatically
                      ),
                    },
                  ),
                  SizedBox(height: 20 * SizeConfig.heightScale),
                  Text(
                    "Description:",
                    style: AppTextStyles.blackSubHeadingStyle().copyWith(
                      fontSize: 16 * SizeConfig.heightScale,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 5 * SizeConfig.heightScale),
                  Html(
                    data:
                        _productDetail?.description ??
                        "<p>No description available</p>",
                    style: {
                      // ---- Base text -----------------------------------------------------------------
                      "body": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.all(0),
                        color: const Color.fromRGBO(0, 0, 0, 0.5),
                        fontSize: FontSize(12 * SizeConfig.widthScale),
                        fontWeight: FontWeight.w300,
                        fontFamily:
                            AppTextStyles.greySubHeadingStyle().fontFamily,
                      ),

                      // ---- Paragraphs ----------------------------------------------------------------
                      "p": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.all(0),
                      ),

                      // ---- Headings (h1‒h6) ----------------------------------------------------------
                      for (final h in ['h1', 'h2', 'h3', 'h4', 'h5', 'h6'])
                        h: Style(
                          margin: Margins.only(bottom: 4),
                          padding: HtmlPaddings.all(0),
                          fontWeight: FontWeight.w600, // a bit bolder
                        ),

                      // ---- Unordered lists -----------------------------------------------------------
                      "ul": Style(
                        margin: Margins.only(left: 18, top: 4, bottom: 4),
                        padding: HtmlPaddings.all(0),
                      ),

                      // ---- Ordered lists -------------------------------------------------------------
                      "ol": Style(
                        margin: Margins.only(left: 18, top: 4, bottom: 4),
                        padding: HtmlPaddings.all(0),
                      ),

                      // ---- List items ---------------------------------------------------------------
                      "li": Style(
                        margin: Margins.only(bottom: 2),
                        padding: HtmlPaddings.all(0),
                        // bullet and number size follows list text automatically
                      ),
                    },
                  ),
                  SizedBox(height: 20 * SizeConfig.heightScale),
                  Text(
                    "Return Policy:",
                    style: AppTextStyles.blackSubHeadingStyle().copyWith(
                      fontSize: 16 * SizeConfig.heightScale,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 5 * SizeConfig.heightScale),
                  Text(
                    'If you want to return product do not remove product tag.If you want to return your product than you have to return it  within 7 days.',
                    style: AppTextStyles.greySubHeadingStyle(
                      color: const Color.fromRGBO(0, 0, 0, 0.5),
                    ).copyWith(
                      fontSize: 12 * SizeConfig.widthScale,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 20 * SizeConfig.heightScale),
                  Text(
                    "Exchange Policy:",
                    style: AppTextStyles.blackSubHeadingStyle().copyWith(
                      fontSize: 16 * SizeConfig.heightScale,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 5 * SizeConfig.heightScale),
                  Text(
                    'If you want to Exchange product than you have to exchange it  within 7 days.',
                    style: AppTextStyles.greySubHeadingStyle(
                      color: const Color.fromRGBO(0, 0, 0, 0.5),
                    ).copyWith(
                      fontSize: 12 * SizeConfig.widthScale,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 20 * SizeConfig.heightScale),

                  _productDetail?.isInCart != true
                      ? SubmitButton(
                        text: 'Add to Cart',
                        onPressed: () async {
                          await Provider.of<CartProvider>(
                            context,
                            listen: false,
                          ).addToCart(
                            productId: _productDetail?.id ?? 0,
                            attributeId: selectedAttributeId ?? 0,
                            quantity: 1,
                          );
                          await _loadProductDetail(widget.productID ?? 0);
                        },

                        isTransparent: true,
                      )
                      : SubmitButton(
                        text: 'Go to Cart',
                        onPressed: () {
                          Navigator.pop(context);
                          MainScreen.selectedIndexNotifier.value = 2;
                        },

                        isTransparent: true,
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
                    "Similar Products",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              height: 350 * SizeConfig.heightScale,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 1,
                    spreadRadius: 0,
                    // offset: Offset(0, 2),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.37),
              ),
              child: Consumer<ProductProvider>(
                builder: (context, provider, _) {
                  final products = provider.similarProducts;

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCardWidget(
                        data: products[index],
                        imageURL: provider.similarProductImageURL,
                        onWishlistTap: () {
                          provider.fetchSimilarProducts(
                            _productDetail?.id ?? 0,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget colorOption(String colorName, Color color, int skuId) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = colorName;
          selectedSkuId = skuId;
        });
      },
      child: Container(
        width: 120 * SizeConfig.widthScale, // fixed width for wrapping
        padding: EdgeInsets.symmetric(
          horizontal: 8 * SizeConfig.widthScale,
          vertical: 4 * SizeConfig.heightScale,
        ),
        decoration: BoxDecoration(
          color:
              selectedSkuId == skuId
                  ? Colors.grey.shade300
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Container(
              height: 24 * SizeConfig.heightScale,
              width: 24 * SizeConfig.heightScale,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                border: Border.all(
                  color:
                      selectedSkuId != skuId
                          ? const Color.fromRGBO(0, 0, 0, 0.2)
                          : Colors.transparent,
                ),
              ),
            ),
            SizedBox(width: 8 * SizeConfig.widthScale),
            Expanded(
              child: Text(
                colorName,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.blackSubHeadingStyle().copyWith(
                  fontSize: 14 * SizeConfig.widthScale,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromRGBO(37, 38, 38, 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotifyMeSwitch extends StatefulWidget {
  const NotifyMeSwitch({super.key});

  @override
  _NotifyMeSwitchState createState() => _NotifyMeSwitchState();
}

class _NotifyMeSwitchState extends State<NotifyMeSwitch> {
  bool isSwitched = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(
          value: isSwitched,
          onChanged: (value) {
            setState(() {
              isSwitched = value;
            });
          },
          activeColor: Colors.white, // Thumb color when ON
          activeTrackColor: Color(
            0xFFEFF3FA,
          ), // Track color when ON (light blueish)
          inactiveThumbColor: Colors.grey.shade400, // Thumb color when OFF
          inactiveTrackColor: Colors.grey.shade300, // Track color when OFF
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        SizedBox(width: 8),
        Text(
          "Notify me when out of stock",
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
