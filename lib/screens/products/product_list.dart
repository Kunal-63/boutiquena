import 'package:boutiquena_vendor/config/text_styles.dart';
import 'package:boutiquena_vendor/utils/custom_network_image.dart';
import 'package:boutiquena_vendor/utils/size_config.dart';
import 'package:boutiquena_vendor/widgets/headers/common_appbar.dart';
import 'package:boutiquena_vendor/widgets/inputs/input_widgets.dart';
import 'package:boutiquena_vendor/widgets/popup_menu_item.dart';
import 'package:boutiquena_vendor/widgets/popups/delete_product_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> products = [
    {
      'image':
          'https://images.pexels.com/photos/298863/pexels-photo-298863.jpeg',
      'discount': '-10%',
      'rating': 5,
      'reviews': 10,
      'title': 'Evening Dress',
      'brand': 'Dorothy Perkins',
      'price': '10 ₪',
      'isFavorite': false
    },
    {
      'image':
          'https://images.pexels.com/photos/1055691/pexels-photo-1055691.jpeg',
      'discount': '-10%',
      'rating': 4,
      'reviews': 10,
      'title': 'Evening Dress',
      'brand': 'Dorothy Perkins',
      'price': '10 ₪',
      'isFavorite': false
    },
    {
      'image':
          'https://images.pexels.com/photos/291762/pexels-photo-291762.jpeg',
      'discount': '-10%',
      'rating': 3,
      'reviews': 10,
      'title': 'Evening Dress',
      'brand': 'Dorothy Perkins',
      'price': '10 ₪',
      'isFavorite': false
    },
    {
      'image':
          'https://images.pexels.com/photos/298863/pexels-photo-298863.jpeg',
      'discount': '-10%',
      'rating': 5,
      'reviews': 10,
      'title': 'Evening Dress',
      'brand': 'Dorothy Perkins',
      'price': '10 ₪',
      'isFavorite': false
    },
    {
      'image':
          'https://images.pexels.com/photos/1055691/pexels-photo-1055691.jpeg',
      'discount': '-10%',
      'rating': 4,
      'reviews': 10,
      'title': 'Evening Dress',
      'brand': 'Dorothy Perkins',
      'price': '10 ₪',
      'isFavorite': false
    },
    {
      'image':
          'https://images.pexels.com/photos/291762/pexels-photo-291762.jpeg',
      'discount': '-10%',
      'rating': 3,
      'reviews': 10,
      'title': 'Evening Dress',
      'brand': 'Dorothy Perkins',
      'price': '10 ₪',
      'isFavorite': false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: CommonAppBar(
          title: "Product List",
          menuPressed: () {},
          menuItems: [
            PopupMenuHelper.buildPopupMenuItem(
                0, 'assets/icons/edit-popup-icon.svg', 'Edit')
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20 * SizeConfig.widthScale,
              vertical: 10 * SizeConfig.heightScale,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromRGBO(219, 233, 233, 1),
                            width: 0.94,
                          ),
                          borderRadius: BorderRadius.circular(
                            22 * SizeConfig.heightScale,
                          )),
                      padding: EdgeInsets.symmetric(
                        horizontal: 15 * SizeConfig.widthScale,
                        vertical: 10 * SizeConfig.heightScale,
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/filter-icon.svg',
                          ),
                          const SizedBox(width: 8),
                          Text('Filter',
                              style:
                                  AppTextStyles.blackSubHeadingStyle().copyWith(
                                fontSize: 14 * SizeConfig.widthScale,
                                fontWeight: FontWeight.w400,
                              )),
                        ],
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(243, 120, 102, 1),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(5),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5 * SizeConfig.heightScale,
                ),
                InputWidget(
                  hint: 'Search your any product',
                  controller: _controller,
                  svgPath: 'assets/icons/search-icon.svg',
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: 20 * SizeConfig.widthScale,
                vertical: 5 * SizeConfig.heightScale,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                var product = products[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CustomNetworkImage(
                              imageUrl: product['image'],
                              errorImage: 'assets/icons/no-image.png',
                              width: 110 * SizeConfig.widthScale,
                              height: 130 * SizeConfig.heightScale,
                              radius: 5,
                            ),
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  product['discount'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -10,
                              right: -5,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    product['isFavorite'] =
                                        !product['isFavorite'];
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(7),
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
                                      product['isFavorite']
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_border_rounded,
                                      color: product['isFavorite']
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10 * SizeConfig.widthScale,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color.fromRGBO(
                                            219, 233, 233, 1),
                                        width: 0.94,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        22 * SizeConfig.heightScale,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10 * SizeConfig.widthScale,
                                      vertical: 5 * SizeConfig.heightScale,
                                    ),
                                    child: Text('Edit',
                                        style:
                                            AppTextStyles.blackSubHeadingStyle()
                                                .copyWith(
                                          fontSize: 14 * SizeConfig.widthScale,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ),
                                  SizedBox(
                                    width: 5 * SizeConfig.widthScale,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => DeletePopUp(
                                          message:
                                              'Are you sure you want to delete this product??',
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromRGBO(
                                              219, 233, 233, 1),
                                          width: 0.94,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          22 * SizeConfig.heightScale,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10 * SizeConfig.widthScale,
                                        vertical: 5 * SizeConfig.heightScale,
                                      ),
                                      child: Text('Delete',
                                          style: AppTextStyles
                                                  .blackSubHeadingStyle()
                                              .copyWith(
                                            fontSize:
                                                14 * SizeConfig.widthScale,
                                            fontWeight: FontWeight.w400,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10 * SizeConfig.heightScale,
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: List.generate(
                                      product['rating'],
                                      (i) => const Icon(Icons.star_rounded,
                                          color:
                                              Color.fromRGBO(255, 186, 73, 1),
                                          size: 14),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '(${product['reviews']})',
                                    style: AppTextStyles.greySubHeadingStyle(
                                            color: const Color.fromRGBO(0, 0, 0, 0.6))
                                        .copyWith(
                                      fontSize: 10 * SizeConfig.widthScale,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5 * SizeConfig.heightScale,
                              ),
                              Text(product['title'],
                                  style: AppTextStyles.greySubHeadingStyle()
                                      .copyWith(
                                    fontSize: 12 * SizeConfig.widthScale,
                                    fontWeight: FontWeight.w400,
                                  )),
                              SizedBox(
                                height: 5 * SizeConfig.heightScale,
                              ),
                              Text(product['brand'],
                                  style: AppTextStyles.blackSubHeadingStyle()
                                      .copyWith(
                                    fontSize: 14 * SizeConfig.widthScale,
                                    fontWeight: FontWeight.w400,
                                  )),
                              SizedBox(
                                height: 5 * SizeConfig.heightScale,
                              ),
                              Text(product['price'],
                                  style: AppTextStyles.redw400Outfit().copyWith(
                                    fontSize: 14 * SizeConfig.widthScale,
                                    fontWeight: FontWeight.w400,
                                  )),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SvgPicture.asset('assets/icons/pin-icon.svg')
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
