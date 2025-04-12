import 'package:customer_app/models/category_item.dart';
import 'package:customer_app/models/product.dart';
import 'package:customer_app/screens/products/best_sellers.dart';
import 'package:customer_app/widgets/cards/product_card.dart';
import 'package:customer_app/widgets/inputs/input_widgets.dart';
import 'package:provider/provider.dart';
import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/config/theme.dart';
import 'package:customer_app/providers/login_provider.dart';
import 'package:customer_app/screens/main_screen.dart';
import 'package:customer_app/utils/custom_network_image.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:customer_app/widgets/cards/discount.dart';
import 'package:customer_app/widgets/headers/main_screen_appbar.dart';
import 'package:customer_app/widgets/inputs/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  final List<CategoryItem> sampleCategories = [
    CategoryItem("Fashion", "assets/images/fashion.png"),
    CategoryItem("Gadgets", "assets/images/gadgets.png"),
    CategoryItem("Home & Living", "assets/images/home_living.png"),
    CategoryItem("Accessories", "assets/images/accessories.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Main content with AppBar and body
            Column(
              children: [
                SizedBox(
                  height: (80.0),
                  child: CustomAppBar(
                    title: "Dashboard",
                    imageUrl:
                        "https://st3.depositphotos.com/1007566/13310/v/450/depositphotos_133109560-stock-illustration-male-profile-avatar-with-brown.jpg",
                    errorImage: "assets/icons/avatar.jpg",
                    onBellPressed: () {},
                    onSettingsPressed: () {},
                    onMenuPressed: () {
                      setState(() {
                        _isDrawerOpen = !_isDrawerOpen;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.0 * SizeConfig.widthScale),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        SizedBox(height: 15 * SizeConfig.heightScale),
                        buildCategoryCarousel(sampleCategories),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                        _buildInfoCard(),
                        SizedBox(height: 10 * SizeConfig.heightScale),
                        _buildProductsSection(),
                        SizedBox(height: 10 * SizeConfig.heightScale),
                        buildBestSellersSection([]),
                        SizedBox(height: 10 * SizeConfig.heightScale),
                        _buildExclusiveProductsSection(),
                        SizedBox(height: 10 * SizeConfig.heightScale),
                        buildFeaturedStoresSection(),
                        SizedBox(height: 10 * SizeConfig.heightScale),

                        buildNearByStoresSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Custom endDrawer that shows BELOW AppBar
            if (_isDrawerOpen)
              Positioned(
                top: 80,
                right: 0,
                child: Container(
                  width: 250 * SizeConfig.widthScale,
                  height: MediaQuery.of(context).size.height - 70,
                  color: Colors.white,
                  child: Material(
                    color: Colors.white,
                    child: ListView(
                      padding: EdgeInsets.all(15 * SizeConfig.widthScale),
                      children: [
                        ListTile(
                          leading: Image.asset(
                            'assets/icons/loyalty-point-icon.png',
                            height: 20 * SizeConfig.widthScale,
                            width: 20 * SizeConfig.widthScale,
                          ),
                          title: Text(
                            "View Loyalty Points",
                            style: AppTextStyles.redw400Outfit(
                              color: Colors.black,
                            ).copyWith(
                              fontSize: 14 * SizeConfig.widthScale,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {},
                        ),
                        Divider(),
                        ListTile(
                          leading: SvgPicture.asset(
                            'assets/icons/search-icon.svg',
                            height: 20 * SizeConfig.widthScale,
                            width: 20 * SizeConfig.widthScale,
                            colorFilter: ColorFilter.mode(
                              Color.fromRGBO(243, 120, 102, 1),
                              BlendMode.srcIn,
                            ),
                          ),
                          title: Text(
                            "All Products",
                            style: AppTextStyles.redw400Outfit(
                              color: Colors.black,
                            ).copyWith(
                              fontSize: 14 * SizeConfig.widthScale,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {},
                        ),
                        Divider(),
                        ListTile(
                          leading: SvgPicture.asset(
                            'assets/icons/store-listing-icon.svg',
                            height: 20 * SizeConfig.widthScale,
                            width: 20 * SizeConfig.widthScale,
                            colorFilter: ColorFilter.mode(
                              Color.fromRGBO(243, 120, 102, 1),
                              BlendMode.srcIn,
                            ),
                          ),
                          title: Text(
                            "All Store Listing",
                            style: AppTextStyles.redw400Outfit(
                              color: Colors.black,
                            ).copyWith(
                              fontSize: 14 * SizeConfig.widthScale,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {},
                        ),
                        Divider(),
                        ListTile(
                          leading: SvgPicture.asset(
                            'assets/icons/wishlist-icon.svg',
                            height: 20 * SizeConfig.widthScale,
                            width: 20 * SizeConfig.widthScale,
                            colorFilter: ColorFilter.mode(
                              Color.fromRGBO(243, 120, 102, 1),
                              BlendMode.srcIn,
                            ),
                          ),
                          title: Text(
                            "Wishlist",
                            style: AppTextStyles.redw400Outfit(
                              color: Colors.black,
                            ).copyWith(
                              fontSize: 14 * SizeConfig.widthScale,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {},
                        ),
                        Divider(),
                        ListTile(
                          leading: Image.asset(
                            'assets/icons/contact-us.png',
                            height: 20 * SizeConfig.widthScale,
                            width: 20 * SizeConfig.widthScale,
                          ),
                          title: Text(
                            "Contact Us",
                            style: AppTextStyles.redw400Outfit(
                              color: Colors.black,
                            ).copyWith(
                              fontSize: 14 * SizeConfig.widthScale,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {},
                        ),
                        Divider(),
                        ListTile(
                          leading: SvgPicture.asset(
                            'assets/icons/featured-store.svg',
                            height: 20 * SizeConfig.widthScale,
                            width: 20 * SizeConfig.widthScale,
                            colorFilter: ColorFilter.mode(
                              Color.fromRGBO(243, 120, 102, 1),
                              BlendMode.srcIn,
                            ),
                          ),
                          title: Text(
                            "Featured Store",
                            style: AppTextStyles.redw400Outfit(
                              color: Colors.black,
                            ).copyWith(
                              fontSize: 14 * SizeConfig.widthScale,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    TextEditingController controller = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row with location and balance
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppTheme.primaryColor,
                  size: 20 * SizeConfig.heightScale,
                ),

                Text(
                  "21, Rizana street, Israel",
                  style: AppTextStyles.blackSubHeadingStyle().copyWith(
                    fontSize: 12 * SizeConfig.widthScale,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppTheme.primaryColor,
                  size: 16 * SizeConfig.heightScale,
                ),
              ],
            ),
            Row(
              children: [
                Image.asset(
                  'assets/icons/home-coins.png',
                  width: 20,
                  height: 20,
                ),
                SizedBox(width: 4),
                Text(
                  "100 ₪",
                  style: AppTextStyles.blackSubHeadingStyle().copyWith(
                    fontSize: 12 * SizeConfig.widthScale,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10 * SizeConfig.heightScale),

        // Search bar with camera icon
        Container(
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color.fromRGBO(219, 233, 233, 1)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/search-icon.svg',
                colorFilter: ColorFilter.mode(
                  Color.fromRGBO(172, 172, 172, 1),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search for brands and products",
                    border: InputBorder.none,
                  ),
                ),
              ),

              Icon(
                Icons.camera_alt_outlined,
                color: Color.fromRGBO(50, 50, 50, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCategoryCarousel(List<CategoryItem> categories) {
    return SizedBox(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_back, color: Color.fromRGBO(0, 0, 0, 0.5)),
          SizedBox(width: 6 * SizeConfig.widthScale),

          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => SizedBox(width: 20),
              itemBuilder: (context, index) {
                final category = categories[index];
                return Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(category.imagePath),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(color: Colors.black12),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      category.title,
                      style: AppTextStyles.blackSubHeadingStyle().copyWith(
                        fontSize: 10 * SizeConfig.widthScale,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(width: 6 * SizeConfig.widthScale),
          Icon(Icons.arrow_forward, color: Color.fromRGBO(0, 0, 0, 0.5)),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    List<String> images = [
      "https://th.bing.com/th/id/OIP.JN2YuhRiEVw4-QjfLIBHkgHaE8?rs=1&pid=ImgDetMain",
      "https://3.bp.blogspot.com/-4rTxMEZ5fUo/WQFHD8D0qxI/AAAAAAAAF68/L3NnSJzYuzQD4B9D8-5iWZhg-bGzybtZQCEw/s1600/Where-to-find-makeup-samples.JPG",
      "https://th.bing.com/th/id/OIP.JN2YuhRiEVw4-QjfLIBHkgHaE8?rs=1&pid=ImgDetMain",
      "https://3.bp.blogspot.com/-4rTxMEZ5fUo/WQFHD8D0qxI/AAAAAAAAF68/L3NnSJzYuzQD4B9D8-5iWZhg-bGzybtZQCEw/s1600/Where-to-find-makeup-samples.JPG",
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(images[index], fit: BoxFit.cover),
                    Container(color: Colors.black.withOpacity(0.3)),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            "Nevya Beauty",
                            style: AppTextStyles.whitew400Outfit().copyWith(
                              fontSize: 14 * SizeConfig.widthScale,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Moisturizing Cream",
                            style: AppTextStyles.whitew400Outfit().copyWith(
                              fontSize: 10 * SizeConfig.widthScale,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Positioned(top: 10, right: 10, child: _buildExploreButton()),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: images.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 4,
                  dotWidth: 4,
                  spacing: 4,
                  activeDotColor: AppTheme.primaryColor,
                  dotColor: AppTheme.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExploreButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Color.fromRGBO(27, 46, 64, 1),
        borderRadius: BorderRadius.circular(30),
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

  Widget _buildExclusiveProductsSection() {
    List<Map<String, dynamic>> sampleProducts = [
      {
        "name": "Evening Dress",
        "price": 10,
        "imageUrl":
            "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267",
        "discount": "",
        "productType": "Evening Dress",
      },
      {
        "name": "Evening Dress",
        "price": 10,
        "imageUrl":
            "https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f",
        "discount": "",
        "productType": "Evening Dress",
      },
      {
        "name": "Evening Dress",
        "price": 10,
        "imageUrl":
            "https://images.unsplash.com/photo-1618354691214-0a4a2f03a3b5",
        "discount": "-10%",
        "productType": "Evening Dress",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Exclusive Offers",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "View all",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 5,
                  ),

                  child: Text(
                    'BUY 1 GET 1 FREE',
                    style: AppTextStyles.redw400Outfit(
                      color: Colors.black,
                    ).copyWith(
                      fontSize: 14 * (SizeConfig.widthScale ?? 1.0),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                SizedBox(
                  height: (SizeConfig.heightScale ?? 1.0) * 255,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: sampleProducts.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: ProductCardWidget(data: sampleProducts[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductsSection() {
    List<Map<String, dynamic>> sampleProducts = [
      {
        "name": "Evening Dress",
        "price": 10,
        "imageUrl":
            "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267",
        "discount": "",
        "productType": "Evening Dress",
      },
      {
        "name": "Evening Dress",
        "price": 10,
        "imageUrl":
            "https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f",
        "discount": "",
        "productType": "Evening Dress",
      },
      {
        "name": "Evening Dress",
        "price": 10,
        "imageUrl":
            "https://images.unsplash.com/photo-1618354691214-0a4a2f03a3b5",
        "discount": "-10%",
        "productType": "Evening Dress",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Suggested products",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "View all",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 255 * SizeConfig.heightScale,
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
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: sampleProducts.length,
            itemBuilder: (context, index) {
              return ProductCardWidget(data: sampleProducts[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget buildBestSellersSection(List<Map<String, dynamic>> products) {
    List<Map<String, dynamic>> sampleProducts = [
      {
        "name": "Evening Dress",
        "price": 10,
        "imageUrl":
            "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267",
        "discount": "",
        "productType": "Evening Dress",
      },
      {
        "name": "Evening Dress",
        "price": 10,
        "imageUrl":
            "https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f",
        "discount": "",
        "productType": "Evening Dress",
      },
      {
        "name": "Evening Dress",
        "price": 10,
        "imageUrl":
            "https://images.unsplash.com/photo-1618354691214-0a4a2f03a3b5",
        "discount": "-10%",
        "productType": "Evening Dress",
      },
    ];
    return BestSellersSection(products: sampleProducts);
  }

  Widget buildFeaturedStoresSection() {
    List<Map<String, dynamic>> featuredStores = [
      {
        "name": "Trendy Fashions",
        "rating": 5,
        "logoText": "Tf",
        "products": List.generate(
          5,
          (index) =>
              'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267',
        ),
      },
      {
        "name": "Simona Hub",
        "rating": 5,
        "logoText": "si",
        "products": List.generate(
          5,
          (index) =>
              'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267',
        ),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Featured Stores",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "View all",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [...featuredStores.map((store) => buildStoreCard(store))],
          ),
        ),
      ],
    );
  }

  Widget buildStoreCard(Map<String, dynamic> store) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromRGBO(250, 250, 250, 1),
        borderRadius: BorderRadius.circular(10.37),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Store Logo Circle
              CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.primaryColor,
                child: Text(
                  store["logoText"],
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(width: 12),
              // Store Name and Rating
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store["name"],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      Text("${store["rating"]}/5"),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              // Explore Button
              _buildExploreButton(),
            ],
          ),
          Divider(),
          // Horizontal Product List
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: store["products"].length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      store["products"][index],
                      width: 60,
                      fit: BoxFit.cover,
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

  Widget buildNearByStoresSection() {
    List<Map<String, dynamic>> featuredStores = [
      {
        "name": "Trendy Fashions",
        "rating": 5,
        "logoText": "Tf",
        "products": List.generate(
          5,
          (index) =>
              'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267',
        ),
      },
      {
        "name": "Simona Hub",
        "rating": 5,
        "logoText": "si",
        "products": List.generate(
          5,
          (index) =>
              'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267',
        ),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Near by stores",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "View all",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              ...featuredStores.map((store) => buildNearByStoreCard(store)),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildNearByStoreCard(Map<String, dynamic> store) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromRGBO(250, 250, 250, 1),
        borderRadius: BorderRadius.circular(10.37),
      ),
      child: Row(
        children: [
          // Store Logo Circle
          CircleAvatar(
            radius: 24,
            backgroundColor: AppTheme.primaryColor,
            child: Text(
              store["logoText"],
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          const SizedBox(width: 12),
          // Store Name and Rating
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                store["name"],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 16),
                  Text("${store["rating"]}/5"),
                ],
              ),
            ],
          ),
          const Spacer(),
          // Explore Button
          _buildExploreButton(),
        ],
      ),
    );
  }
}
