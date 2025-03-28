import 'package:vendor_app/config/text_styles.dart';
import 'package:vendor_app/config/theme.dart';
import 'package:vendor_app/models/product.dart';
import 'package:vendor_app/utils/custom_network_image.dart';
import 'package:vendor_app/utils/size_config.dart';
import 'package:vendor_app/widgets/cards/discount.dart';
import 'package:vendor_app/widgets/cards/product_card.dart';
import 'package:vendor_app/widgets/headers/main_screen_appbar.dart';
import 'package:vendor_app/widgets/inputs/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: CustomAppBar(
          title: "Dashboard",
          imageUrl:
              "https://st3.depositphotos.com/1007566/13310/v/450/depositphotos_133109560-stock-illustration-male-profile-avatar-with-brown.jpg",
          errorImage: "assets/icons/avatar.jpg",
          onBellPressed: () {},
          onSettingsPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0 * SizeConfig.widthScale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 15 * SizeConfig.heightScale),
            _buildInfoCard(),
            SizedBox(height: 10 * SizeConfig.heightScale),
            _buildSalesDiscountSection(),
            SizedBox(height: 10 * SizeConfig.heightScale),
            _buildProductsSection(),
            SizedBox(height: 10 * SizeConfig.heightScale),
            _buildReviewSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: "Hello, ",
                style: AppTextStyles.blackSubHeadingStyle().copyWith(
                  fontSize: 14 * SizeConfig.widthScale,
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  TextSpan(
                    text: 'Kunal Adwani',
                    style: AppTextStyles.blackSubHeadingStyle().copyWith(
                      fontSize: 14 * SizeConfig.widthScale,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "Welcome to BoutiqueNA",
              style: AppTextStyles.blackSubHeadingStyle().copyWith(
                fontSize: 14 * SizeConfig.widthScale,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Image.asset('assets/icons/waving-hand.png'),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(217, 176, 170, 1),
        borderRadius: BorderRadius.circular(10.37),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPageView(),
                const SizedBox(height: 5),
                _buildExploreButton(),
                const SizedBox(height: 5),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 4,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 4,
                    dotWidth: 4,
                    activeDotColor: AppTheme.primaryColor,
                    dotColor: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          _buildIdeaImage(),
        ],
      ),
    );
  }

  Widget _buildPageView() {
    List<String> texts = [
      "Now you can add more products on your store and earn more profit.",
      "Get the best offers for your store and increase sales.",
      "Manage your store easily with our latest features.",
      "Enhance your business with advanced analytics.",
    ];
    return SizedBox(
      height: 60,
      child: PageView.builder(
        controller: _pageController,
        itemCount: texts.length,
        itemBuilder:
            (context, index) => Text(
              texts[index],
              style: AppTextStyles.blackSubHeadingStyle().copyWith(
                fontSize: 14 * SizeConfig.widthScale,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
      ),
    );
  }

  Widget _buildExploreButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Explore",
            style: AppTextStyles.whiteButtonStyle().copyWith(
              fontSize: 10 * SizeConfig.widthScale,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 5),
          SvgPicture.asset('assets/icons/north-east-arrow.svg'),
        ],
      ),
    );
  }

  Widget _buildIdeaImage() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.asset(
          'assets/icons/generate-idea.png',
          height: 120,
          width: 120,
          fit: BoxFit.cover,
        ),
        Positioned(
          right: 20,
          bottom: -15,
          child: Image.asset(
            'assets/icons/home-coins.png',
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget _buildSalesDiscountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sales & Discount",
          style: AppTextStyles.blackHeadingStyle().copyWith(
            fontSize: 16 * SizeConfig.widthScale,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.37),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.06),
                blurRadius: 3,
                spreadRadius: 0,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomDropdown(
                items: const ['Last 28 days'],
                selectedItem: 'Last 28 days',
                onChanged: (value) {},
                width: 130 * SizeConfig.widthScale,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                    height: 150 * SizeConfig.heightScale,
                    width: SizeConfig.screenWidth * 0.5,
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        axisLine: AxisLine(width: 1, color: Colors.black),
                        majorGridLines: MajorGridLines(width: 0),
                        arrangeByIndex: true, // Bars ke gap ko kam karta hai
                        interval: 1, // Sirf 0 aur 1 dikhega
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ), // Label style sahi
                        edgeLabelPlacement:
                            EdgeLabelPlacement
                                .shift, // Label ko thoda side me karta hai
                      ),
                      primaryYAxis: NumericAxis(
                        axisLine: AxisLine(width: 1, color: Colors.black),
                        majorGridLines: MajorGridLines(width: 0),
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      plotAreaBorderWidth: 0, // Padding hata diya
                      margin: EdgeInsets.zero, // Extra margin bhi hata diya
                      series: <CartesianSeries>[
                        ColumnSeries<Map<String, dynamic>, String>(
                          dataSource: const [
                            {'x': '0', 'y': 300},
                            {'x': '1', 'y': 400},
                            {'x': '2', 'y': 200},
                            {'x': '3', 'y': 500},
                            {'x': '4', 'y': 500},
                          ],
                          xValueMapper: (data, _) => data['x'],
                          yValueMapper: (data, _) => data['y'],
                          color: const Color.fromRGBO(243, 120, 102, 1),
                          width: 0.5, // Bar ka width aur kam kiya
                          spacing: 0.1, // Gap aur tight kiya
                        ),
                        ColumnSeries<Map<String, dynamic>, String>(
                          dataSource: const [
                            {'x': '0', 'y': 200},
                            {'x': '1', 'y': 500},
                            {'x': '2', 'y': 200},
                            {'x': '3', 'y': 500},
                            {'x': '4', 'y': 500},
                          ],
                          xValueMapper: (data, _) => data['x'],
                          yValueMapper: (data, _) => data['y'],
                          color: const Color.fromRGBO(27, 46, 64, 1),
                          width: 0.5,
                          spacing: 0.1,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 150 * SizeConfig.heightScale,
                          child: SfCircularChart(
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <CircularSeries>[
                              DoughnutSeries<Map<String, dynamic>, String>(
                                dataSource: const [
                                  {'x': 'Profit', 'y': 80},
                                  {'x': 'Loss', 'y': 20},
                                ],
                                xValueMapper: (data, _) => data['x'],
                                yValueMapper: (data, _) => data['y'],
                                pointColorMapper:
                                    (data, index) =>
                                        index == 0
                                            ? const Color.fromRGBO(
                                              243,
                                              120,
                                              102,
                                              1,
                                            )
                                            : const Color.fromRGBO(
                                              248,
                                              159,
                                              146,
                                              1,
                                            ),
                                innerRadius: '70%',
                              ),
                            ],
                            legend: Legend(isVisible: false),
                          ),
                        ),
                        Text(
                          '80%',
                          style: AppTextStyles.blackSubHeadingStyle().copyWith(
                            fontSize: 16 * SizeConfig.widthScale,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(color: Color.fromRGBO(0, 0, 0, 0.5)),
              const DiscountCouponWidget(
                discountText: 'Flat',
                discount: '10%',
                productType: 'Evening Dress',
                productName: 'Dorothy Perkins',
                oldPrice: '12₪',
                newPrice: '10₪',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewSection() {
    List<Map<String, String>> reviews = [
      {
        'name': 'Ruby Sumona',
        'review':
            'I buy one Dress for my birthday and the quality of dress material was really good. I am happy with your product. Thank you!',
        'rating': '5/5',
      },
      {
        'name': 'John Doe',
        'review':
            'Excellent customer service and the product quality is top-notch!',
        'rating': '4.8/5',
      },
      {
        'name': 'Lisa Brown',
        'review':
            'Timely delivery and very well packed. Satisfied with the purchase.',
        'rating': '4.5/5',
      },
      {
        'name': 'Michael Scott',
        'review': 'Nice collection of dresses. Worth the price.',
        'rating': '4.7/5',
      },
      {
        'name': 'Emily Clark',
        'review':
            'Amazing quality and quick delivery. Will definitely recommend!',
        'rating': '5/5',
      },
    ];

    PageController pageController = PageController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Customer Reviews",
              style: AppTextStyles.blackHeadingStyle().copyWith(
                fontSize: 16 * SizeConfig.widthScale,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "View all",
              style: AppTextStyles.redw400Outfit().copyWith(
                fontSize: 16 * SizeConfig.widthScale,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.37),
            color: const Color.fromRGBO(255, 255, 255, 1),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.06),
                blurRadius: 3,
                spreadRadius: 0,
                offset: Offset(0, 1),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10 * SizeConfig.widthScale,
            vertical: 10 * SizeConfig.widthScale,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height:
                    180 * SizeConfig.heightScale, // Fixed height for PageView
                child: PageView.builder(
                  controller: pageController,
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    var review = reviews[index];
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.37),
                        color: const Color.fromRGBO(250, 250, 250, 1),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomNetworkImage(
                                imageUrl:
                                    'https://as2.ftcdn.net/v2/jpg/04/50/02/89/1000_F_450028910_0Jsl6odMYrGLjOsPYR27yMFVwsNnZiwb.jpg',
                                errorImage: 'assets/icons/no-image.png',
                                height: 38 * SizeConfig.widthScale,
                                width: 38 * SizeConfig.widthScale,
                                radius: 38 * SizeConfig.widthScale,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  review['name']!,
                                  style: AppTextStyles.blackSubHeadingStyle()
                                      .copyWith(
                                        fontSize: 16 * SizeConfig.widthScale,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Color.fromRGBO(255, 186, 73, 1),
                                    size: 20,
                                  ),
                                  Text(
                                    review['rating']!,
                                    style: AppTextStyles.blackSubHeadingStyle()
                                        .copyWith(
                                          fontSize: 12 * SizeConfig.widthScale,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 5 * SizeConfig.heightScale),
                          Divider(
                            color: const Color.fromRGBO(0, 0, 0, 0.3),
                            height: 20 * SizeConfig.heightScale,
                            thickness: 0.2,
                          ),
                          SizedBox(height: 5 * SizeConfig.heightScale),
                          Text(
                            '“${review['review']}”',
                            style: AppTextStyles.greySubHeadingStyle().copyWith(
                              fontSize: 12 * SizeConfig.widthScale,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              Container(
                padding: EdgeInsets.only(right: 10 * SizeConfig.widthScale),
                child: SmoothPageIndicator(
                  controller: pageController,
                  count: 4,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 4,
                    dotWidth: 4,
                    activeDotColor: AppTheme.primaryColor,
                    dotColor: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductsSection() {
    List<Product> sampleProducts = [
      Product(
        name: "Laptop",
        price: 999,
        imageUrl:
            "https://th.bing.com/th/id/OIP.s9gtURohWjYwnMgYl3v4fwHaGy?rs=1&pid=ImgDetMain",
        discount: "-20%",
        productType: "Electronics",
      ),
      Product(
        name: "Smartphone",
        price: 499,
        imageUrl:
            "https://th.bing.com/th/id/OIP.s9gtURohWjYwnMgYl3v4fwHaGy?rs=1&pid=ImgDetMain",
        discount: "-15%",
        productType: "Electronics",
      ),
      Product(
        name: "Headphones",
        price: 199,
        imageUrl:
            "https://th.bing.com/th/id/OIP.s9gtURohWjYwnMgYl3v4fwHaGy?rs=1&pid=ImgDetMain",
        discount: "-10%",
        productType: "Accessories",
      ),
      Product(
        name: "Smartwatch",
        price: 299,
        imageUrl:
            "https://th.bing.com/th/id/OIP.s9gtURohWjYwnMgYl3v4fwHaGy?rs=1&pid=ImgDetMain",
        discount: "-25%",
        productType: "Wearables",
      ),
      Product(
        name: "Camera",
        price: 799,
        imageUrl:
            "https://th.bing.com/th/id/OIP.s9gtURohWjYwnMgYl3v4fwHaGy?rs=1&pid=ImgDetMain",
        discount: "-18%",
        productType: "Photography",
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Your Products",
              style: AppTextStyles.blackHeadingStyle().copyWith(
                fontSize: 16 * SizeConfig.widthScale,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "View all",
              style: AppTextStyles.redw400Outfit().copyWith(
                fontSize: 16 * SizeConfig.widthScale,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(1),
          height: 220 * SizeConfig.heightScale,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.37),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.06),
                blurRadius: 3,
                spreadRadius: 0,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  sampleProducts
                      .map((product) => ProductCardWidget(product: product))
                      .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
