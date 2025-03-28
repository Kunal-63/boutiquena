import 'package:vendor_app/config/text_styles.dart';
import 'package:vendor_app/utils/custom_network_image.dart';
import 'package:vendor_app/utils/size_config.dart';
import 'package:vendor_app/widgets/headers/common_appbar.dart';
import 'package:vendor_app/widgets/inputs/dropdown.dart';
import 'package:vendor_app/widgets/popup_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  int selectedSizeIndex = -1;
  final PageController _pageController = PageController(viewportFraction: 0.75);
  @override
  Widget build(BuildContext context) {
    List<String> orderImages = [
      'https://indianhotdeal.com/wp-content/uploads/2022/11/bd0b03bb-5cdb-44b1-a101-df7cb563f454-1536x864.jpeg',
      'https://indianhotdeal.com/wp-content/uploads/2022/11/bd0b03bb-5cdb-44b1-a101-df7cb563f454-1536x864.jpeg',
      'https://indianhotdeal.com/wp-content/uploads/2022/11/bd0b03bb-5cdb-44b1-a101-df7cb563f454-1536x864.jpeg',
    ];
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: CommonAppBar(
          title: "View Order",
          menuPressed: () {},
          menuItems: [
            PopupMenuHelper.buildPopupMenuItem(
              0,
              'assets/icons/edit-popup-icon.svg',
              'Edit',
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
                      itemCount: orderImages.length,
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
                                      imageUrl: orderImages[index],
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
                        '-20%',
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
                      Row(
                        children: [
                          Text(
                            "Clothing",
                            style: AppTextStyles.greySubHeadingStyle(
                              color: const Color.fromRGBO(0, 0, 0, 0.8),
                            ).copyWith(
                              fontSize: 12 * SizeConfig.widthScale,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Row(
                            children: [
                              Row(
                                children: List.generate(
                                  5,
                                  (i) => const Icon(
                                    Icons.star_rounded,
                                    color: Color.fromRGBO(255, 186, 73, 1),
                                    size: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '(10)',
                                style: AppTextStyles.greySubHeadingStyle(
                                  color: const Color.fromRGBO(0, 0, 0, 0.6),
                                ).copyWith(
                                  fontSize: 10 * SizeConfig.widthScale,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5 * SizeConfig.heightScale),
                      Text(
                        "Dorothy Perkins",
                        style: AppTextStyles.blackSubHeadingStyle().copyWith(
                          fontSize: 16 * SizeConfig.widthScale,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "10 ₪",
                    style: AppTextStyles.redw400Outfit().copyWith(
                      fontSize: 24 * SizeConfig.heightScale,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color.fromRGBO(219, 233, 233, 1),
                        width: 0.5,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Size: L',
                          style: AppTextStyles.greySubHeadingStyle().copyWith(
                            fontSize: 12 * SizeConfig.widthScale,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Color: Black',
                          style: AppTextStyles.greySubHeadingStyle().copyWith(
                            fontSize: 12 * SizeConfig.widthScale,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10 * SizeConfig.widthScale),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Product Name : ',
                            style: AppTextStyles.blackSubHeadingStyle()
                                .copyWith(
                                  fontSize: 12 * SizeConfig.widthScale,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                          Text(
                            'Brown Shirt',
                            style: AppTextStyles.blackSubHeadingStyle(
                              color: const Color.fromRGBO(0, 0, 0, 0.6),
                            ).copyWith(
                              fontSize: 12 * SizeConfig.widthScale,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2 * SizeConfig.heightScale),
                      Row(
                        children: [
                          Text(
                            'SKU ID : ',
                            style: AppTextStyles.blackSubHeadingStyle()
                                .copyWith(
                                  fontSize: 12 * SizeConfig.widthScale,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                          Text(
                            '#00143535',
                            style: AppTextStyles.blackSubHeadingStyle(
                              color: const Color.fromRGBO(0, 0, 0, 0.6),
                            ).copyWith(
                              fontSize: 12 * SizeConfig.widthScale,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              const Divider(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                thickness: 0.5,
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Estimated Delivery Date",
                    style: AppTextStyles.blackSubHeadingStyle().copyWith(
                      fontSize: 12 * SizeConfig.heightScale,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "24 January, 2025",
                    style: AppTextStyles.greySubHeadingStyle().copyWith(
                      fontSize: 12 * SizeConfig.heightScale,
                      fontWeight: FontWeight.w300,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Customer Name",
                    style: AppTextStyles.blackSubHeadingStyle().copyWith(
                      fontSize: 12 * SizeConfig.heightScale,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "Kunal Adwani",
                    style: AppTextStyles.greySubHeadingStyle().copyWith(
                      fontSize: 12 * SizeConfig.heightScale,
                      fontWeight: FontWeight.w300,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Customer’s Address",
                    style: AppTextStyles.blackSubHeadingStyle().copyWith(
                      fontSize: 12 * SizeConfig.heightScale,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 5 * SizeConfig.heightScale),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color.fromRGBO(204, 204, 204, 1),
                        width: 0.5,
                      ),
                    ),
                    width: double.infinity,
                    child: Text(
                      "123 Main Street, NearJinoa Cafe, Apt 4B, Los Angeles, CA, USA.",
                      style: AppTextStyles.greySubHeadingStyle().copyWith(
                        fontSize: 12 * SizeConfig.heightScale,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              Text(
                "Delivery Status",
                style: AppTextStyles.blackSubHeadingStyle().copyWith(
                  fontSize: 12 * SizeConfig.heightScale,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 5 * SizeConfig.heightScale),
              CustomDropdown(
                items: const ['pending'],
                onChanged: (dynamic newValue) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
