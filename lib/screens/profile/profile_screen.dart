import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/config/theme.dart';
import 'package:customer_app/providers/vendor_profile_provider.dart';
import 'package:customer_app/screens/profile/profile_header.dart';
import 'package:customer_app/screens/subscription_plan.dart';
import 'package:customer_app/utils/custom_network_image.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:customer_app/widgets/headers/common_appbar.dart';
import 'package:customer_app/widgets/inputs/input_widgets.dart';
import 'package:customer_app/widgets/popup_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subscriptionController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _workingHoursController = TextEditingController();
  int? subscripitonID;

  String profileImageUrl = '';
  String userName = "Loading...";

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<VendorProfileProvider>(
            context,
            listen: false,
          ).fetchVendorProfile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<VendorProfileProvider>(context);
    if (profileProvider.isLoading) {
      _storeNameController.text = "Loading...";
      _phoneController.text = "Loading...";
      _emailController.text = "Loading...";
      _subscriptionController.text = "Loading...";
      _passwordController.text = "Loading...";
      _workingHoursController.text = "Loading...";
      userName = "Loading...";
    } else if (profileProvider.vendorProfile != null) {
      final profile = profileProvider.vendorProfile!;
      _storeNameController.text = profile.storeDetails?.name ?? "";
      _phoneController.text = profile.mobile ?? "";
      _emailController.text = profile.email ?? "";
      _subscriptionController.text = profile.subscriptionsName ?? "";
      _passwordController.text = ""; // Keeping password field empty
      _workingHoursController.text = profile.storeDetails?.businessHours ?? "";
      userName = profile.name ?? "No Name";
      profileImageUrl = profile.imagePath ?? "";
      subscripitonID = profile.subscriptionId;
    }
    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: CommonAppBar(
          title: "Profile",
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
        padding: EdgeInsets.symmetric(
          vertical: 15.0 * SizeConfig.heightScale,
          horizontal: 30 * SizeConfig.widthScale,
        ),
        child: Column(
          children: [
            ProfileHeader(userName: 'Kunal Adwani', profileImageUrl: ''),
            SizedBox(height: 10 * SizeConfig.heightScale),
            buildWishlistSection([]),
            SizedBox(height: 10 * SizeConfig.heightScale),
            buildWishlistSection([]),
            SizedBox(height: 10 * SizeConfig.heightScale),
            Container(
              padding: EdgeInsets.all(10 * SizeConfig.widthScale),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
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
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Your Rewards",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "See all",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.redAccent.shade200,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: double.infinity,

                    padding: EdgeInsets.all(5 * SizeConfig.widthScale),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/home-coins.png',
                              height: 25,
                              width: 25,
                            ),
                            SizedBox(width: 10 * SizeConfig.widthScale),
                            Text(
                              "Collected Coins",
                              style: AppTextStyles.blackSubHeadingStyle()
                                  .copyWith(
                                    fontSize: 14 * SizeConfig.widthScale,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                        Text(
                          "100 ₪",
                          style: AppTextStyles.greySubHeadingStyle().copyWith(
                            fontSize: 14 * SizeConfig.widthScale,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildWishlistSection(List<Map<String, dynamic>> products) {
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
  return WishlistSection(products: sampleProducts);
}

class WishlistSection extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const WishlistSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 250 * SizeConfig.heightScale,
          padding: EdgeInsets.all(10 * SizeConfig.widthScale),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
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
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Wishlist",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "See all",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.redAccent.shade200,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return WishlistCard(data: products[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WishlistCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const WishlistCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final imageUrl = data['imageUrl'] ?? '';
    final title = data['title'] ?? 'Evening Dress';
    final brand = data['brand'] ?? 'Dorothy Perkins';
    final price = data['price']?.toString() ?? '10';

    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              height: 90,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) => Container(
                    height: 90,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported),
                  ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 2),

                  Text(
                    brand,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                "$price ₪",
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 5 * SizeConfig.heightScale),
          _iconButton(Icons.favorite_rounded),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black12),
      ),
      child: Icon(icon, size: 18, color: Colors.redAccent),
    );
  }
}
