import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/models/customer_profile.dart';
import 'package:customer_app/models/product.dart';
import 'package:customer_app/providers/customer_profile_provider.dart';
import 'package:customer_app/providers/wishlist_provider.dart';
import 'package:customer_app/screens/profile/profile_header.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:customer_app/widgets/cards/product_card.dart';
import 'package:customer_app/widgets/headers/common_appbar.dart';
import 'package:customer_app/widgets/popup_menu_item.dart';
import 'package:flutter/material.dart';
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

  CustomerProfile? customerProfile;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<CustomerProfileProvider>(
            context,
            listen: false,
          ).fetchCustomerProfile(),
    );
    Future.microtask(
      () =>
          Provider.of<WishlistProvider>(context, listen: false).fetchWishlist(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<CustomerProfileProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
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
      customerProfile = profile;

      _phoneController.text = profile.mobile ?? "";
      _emailController.text = profile.email ?? "";

      _passwordController.text = ""; // Keeping password field empty

      userName = profile.name ?? "No Name";
      profileImageUrl = profile.imagePath ?? "";
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
            ProfileHeader(
              userName: userName,
              profileImageUrl:
                  '${customerProfile?.imagePath}/${customerProfile?.image}',
              onSettingsTap: () {
                Navigator.pushNamed(context, '/edit_profile');
              },
            ),
            SizedBox(height: 10 * SizeConfig.heightScale),
            buildWishlistSection(
              wishlistProvider.wishlistProducts,
              wishlistProvider.productBaseImageUrl,
            ),
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

Widget buildWishlistSection(List<Product> products, String? imageURL) {
  return WishlistSection(products: products, imageURL: imageURL);
}

class WishlistSection extends StatelessWidget {
  final List<Product> products;
  final String? imageURL;

  const WishlistSection({super.key, required this.products, this.imageURL});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        products.isNotEmpty
            ? Container(
              height: 290 * SizeConfig.heightScale,
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
                        return ProductCardWidget(
                          data: products[index],
                          imageURL: imageURL,
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
            : Container(),
      ],
    );
  }
}
