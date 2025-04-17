import 'package:provider/provider.dart';
import 'package:vendor_app/config/text_styles.dart';
import 'package:vendor_app/models/orders.dart';
import 'package:vendor_app/providers/orders_provider.dart';
import 'package:vendor_app/utils/custom_network_image.dart';
import 'package:vendor_app/utils/size_config.dart';
import 'package:vendor_app/widgets/buttons/submit_button.dart';
import 'package:vendor_app/widgets/headers/common_appbar.dart';
import 'package:vendor_app/widgets/inputs/input_widgets.dart';
import 'package:vendor_app/widgets/popup_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Order> _filteredOrders = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      _filteredOrders = orderProvider.orders ?? [];
    });
  }

  void _filterOrders(String query) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    setState(() {
      _filteredOrders =
          orderProvider.orders?.where((order) {
            return order.name?.toLowerCase().contains(query.toLowerCase()) ??
                false;
          }).toList() ??
          [];
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(50.0 * SizeConfig.widthScale),
        ),
      ),
      builder:
          (context) => Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 6,
                  width: 60,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(36, 59, 124, 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                InputWidget(
                  hint: 'Search your order..',
                  controller: _controller,
                  svgPath: 'assets/icons/search-icon.svg',
                  onChanged: _filterOrders,
                ),
                SizedBox(height: 20 * SizeConfig.heightScale),
                SubmitButton(
                  text: 'Apply',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final orderProvider = Provider.of<OrderProvider>(context);
    // final orders = orderProvider.orders ?? [];
    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: CommonAppBar(
          title: "Orders",
          backPressed: () {},
          menuPressed: () {
            print("Menu Pressed");
          },
          menuItems: [
            PopupMenuHelper.buildPopupMenuItem(
              0,
              'assets/icons/edit-popup-icon.svg',
              'Edit',
            ),
            PopupMenuHelper.buildPopupMenuItem(
              1,
              'assets/icons/delete-icon.svg',
              'Delete',
            ),
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
                    GestureDetector(
                      onTap: _showFilterBottomSheet,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color.fromRGBO(219, 233, 233, 1),
                            width: 0.94,
                          ),
                          borderRadius: BorderRadius.circular(
                            22 * SizeConfig.heightScale,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15 * SizeConfig.widthScale,
                          vertical: 10 * SizeConfig.heightScale,
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/icons/filter-icon.svg'),
                            const SizedBox(width: 8),
                            Text(
                              'Filter',
                              style: AppTextStyles.blackSubHeadingStyle()
                                  .copyWith(
                                    fontSize: 14 * SizeConfig.widthScale,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5 * SizeConfig.heightScale),
                InputWidget(
                  hint: 'Search your order..',
                  controller: _controller,
                  svgPath: 'assets/icons/search-icon.svg',
                ),
              ],
            ),
          ),
          _filteredOrders.isEmpty
              ? Expanded(
                child: Center(
                  child: Text(
                    'No Orders Found!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.blackSubHeadingStyle().copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 16 * SizeConfig.widthScale,
                    ),
                  ),
                ),
              )
              : Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20 * SizeConfig.widthScale,
                    vertical: 5 * SizeConfig.heightScale,
                  ),
                  itemCount: _filteredOrders.length,
                  itemBuilder: (context, index) {
                    var order = _filteredOrders[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/order_details');
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: BorderRadius.circular(10.37),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CustomNetworkImage(
                                    imageUrl:
                                        'http://69.62.72.21/dev/public/front/images/product_images/small/64835.jpg',
                                    errorImage: 'assets/icons/no-image.png',
                                    width: 110 * SizeConfig.widthScale,
                                    height: 125 * SizeConfig.heightScale,
                                    radius: 5,
                                  ),
                                  SizedBox(width: 10 * SizeConfig.widthScale),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          order.name ?? '',
                                          style:
                                              AppTextStyles.greySubHeadingStyle()
                                                  .copyWith(
                                                    fontSize:
                                                        12 *
                                                        SizeConfig.widthScale,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                        ),
                                        SizedBox(
                                          height: 2 * SizeConfig.heightScale,
                                        ),
                                        Text(
                                          'H&M',
                                          style:
                                              AppTextStyles.blackSubHeadingStyle()
                                                  .copyWith(
                                                    fontSize:
                                                        14 *
                                                        SizeConfig.widthScale,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                        ),
                                        SizedBox(
                                          height: 2 * SizeConfig.heightScale,
                                        ),
                                        Text(
                                          order.orderStatus ?? '',
                                          style:
                                              AppTextStyles.greySubHeadingStyle()
                                                  .copyWith(
                                                    fontSize:
                                                        12 *
                                                        SizeConfig.widthScale,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                        ),
                                        SizedBox(
                                          height: 2 * SizeConfig.heightScale,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: const Color.fromRGBO(
                                                219,
                                                233,
                                                233,
                                                1,
                                              ),
                                              width: 0.5,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Size: L',
                                                style:
                                                    AppTextStyles.greySubHeadingStyle()
                                                        .copyWith(
                                                          fontSize:
                                                              12 *
                                                              SizeConfig
                                                                  .widthScale,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                              ),
                                              Text(
                                                'Color: Black',
                                                style:
                                                    AppTextStyles.greySubHeadingStyle()
                                                        .copyWith(
                                                          fontSize:
                                                              12 *
                                                              SizeConfig
                                                                  .widthScale,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2 * SizeConfig.heightScale,
                                        ),
                                        Row(
                                          children: [
                                            Row(
                                              children: List.generate(
                                                5,
                                                (i) => const Icon(
                                                  Icons.star_rounded,
                                                  color: Color.fromRGBO(
                                                    255,
                                                    186,
                                                    73,
                                                    1,
                                                  ),
                                                  size: 14,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              '(5)',
                                              style:
                                                  AppTextStyles.greySubHeadingStyle(
                                                    color: const Color.fromRGBO(
                                                      0,
                                                      0,
                                                      0,
                                                      0.6,
                                                    ),
                                                  ).copyWith(
                                                    fontSize:
                                                        10 *
                                                        SizeConfig.widthScale,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5 * SizeConfig.heightScale,
                                        ),
                                        Text(
                                          order.couponAmount ?? '',
                                          style: AppTextStyles.redw400Outfit()
                                              .copyWith(
                                                fontSize:
                                                    14 * SizeConfig.widthScale,
                                                fontWeight: FontWeight.w400,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5 * SizeConfig.heightScale),
                              const Divider(
                                color: Color.fromRGBO(0, 0, 0, 0.3),
                              ),
                              SizedBox(height: 5 * SizeConfig.heightScale),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Estimated Delivery Date',
                                    style: AppTextStyles.blackSubHeadingStyle()
                                        .copyWith(
                                          fontSize: 12 * SizeConfig.widthScale,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                  Text(
                                    '25 January, 2025',
                                    style: AppTextStyles.greySubHeadingStyle()
                                        .copyWith(
                                          fontSize: 12 * SizeConfig.widthScale,
                                          fontWeight: FontWeight.w300,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
