import 'package:boutiquena_vendor/config/text_styles.dart';
import 'package:boutiquena_vendor/utils/custom_network_image.dart';
import 'package:boutiquena_vendor/utils/size_config.dart';
import 'package:boutiquena_vendor/widgets/buttons/submit_button.dart';
import 'package:boutiquena_vendor/widgets/headers/common_appbar.dart';
import 'package:boutiquena_vendor/widgets/inputs/input_widgets.dart';
import 'package:boutiquena_vendor/widgets/popup_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<Map<String, dynamic>> orders = [
    {
      'image':
          'https://images.pexels.com/photos/298863/pexels-photo-298863.jpeg',
      'title': 'Evening Dress',
      'brand': 'Dorothy Perkins',
      'size': 'L',
      'color': 'Brown',
      'rating': 5,
      'reviews': 10,
      'price': '10 ₪',
      'deliveryDate': '24 January, 2025'
    },
    {
      'image':
          'https://images.pexels.com/photos/1055691/pexels-photo-1055691.jpeg',
      'title': 'Casual Dress',
      'brand': 'H&M',
      'size': 'M',
      'color': 'Black',
      'rating': 4,
      'reviews': 8,
      'price': '15 ₪',
      'deliveryDate': '25 January, 2025'
    },
    {
      'image':
          'https://images.pexels.com/photos/291762/pexels-photo-291762.jpeg',
      'title': 'Summer Dress',
      'brand': 'Zara',
      'size': 'S',
      'color': 'Blue',
      'rating': 3,
      'reviews': 6,
      'price': '12 ₪',
      'deliveryDate': '26 January, 2025'
    }
  ];
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(50.0 * SizeConfig.widthScale)),
      ),
      builder: (context) => Container(
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
            ),
            SizedBox(height: 20 * SizeConfig.heightScale),
            SubmitButton(
              text: 'Apply',
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: CommonAppBar(
          title: "Orders",
          menuPressed: () {
            print("Menu Pressed");
          },
          menuItems: [
            PopupMenuHelper.buildPopupMenuItem(
                0, 'assets/icons/edit-popup-icon.svg', 'Edit'),
            PopupMenuHelper.buildPopupMenuItem(
                1, 'assets/icons/delete-icon.svg', 'Delete'),
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
                            SvgPicture.asset(
                              'assets/icons/filter-icon.svg',
                            ),
                            const SizedBox(width: 8),
                            Text('Filter',
                                style: AppTextStyles.blackSubHeadingStyle()
                                    .copyWith(
                                  fontSize: 14 * SizeConfig.widthScale,
                                  fontWeight: FontWeight.w400,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5 * SizeConfig.heightScale,
                ),
                InputWidget(
                  hint: 'Search your order..',
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
              itemCount: orders.length,
              itemBuilder: (context, index) {
                var order = orders[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/order_details');
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.circular(10.37)),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomNetworkImage(
                                imageUrl: order['image'],
                                errorImage: 'assets/icons/no-image.png',
                                width: 110 * SizeConfig.widthScale,
                                height: 125 * SizeConfig.heightScale,
                                radius: 5,
                              ),
                              SizedBox(
                                width: 10 * SizeConfig.widthScale,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(order['title'],
                                        style:
                                            AppTextStyles.greySubHeadingStyle()
                                                .copyWith(
                                          fontSize: 12 * SizeConfig.widthScale,
                                          fontWeight: FontWeight.w400,
                                        )),
                                    SizedBox(
                                      height: 2 * SizeConfig.heightScale,
                                    ),
                                    Text(order['brand'],
                                        style:
                                            AppTextStyles.blackSubHeadingStyle()
                                                .copyWith(
                                          fontSize: 14 * SizeConfig.widthScale,
                                          fontWeight: FontWeight.w400,
                                        )),
                                    SizedBox(
                                      height: 2 * SizeConfig.heightScale,
                                    ),
                                    Text(order['title'],
                                        style:
                                            AppTextStyles.greySubHeadingStyle()
                                                .copyWith(
                                          fontSize: 12 * SizeConfig.widthScale,
                                          fontWeight: FontWeight.w400,
                                        )),
                                    SizedBox(
                                      height: 2 * SizeConfig.heightScale,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: const Color.fromRGBO(
                                                219, 233, 233, 1),
                                            width: 0.5),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Size: ${order['size']}',
                                              style: AppTextStyles
                                                      .greySubHeadingStyle()
                                                  .copyWith(
                                                fontSize:
                                                    12 * SizeConfig.widthScale,
                                                fontWeight: FontWeight.w400,
                                              )),
                                          Text('Color: ${order['color']}',
                                              style: AppTextStyles
                                                      .greySubHeadingStyle()
                                                  .copyWith(
                                                fontSize:
                                                    12 * SizeConfig.widthScale,
                                                fontWeight: FontWeight.w400,
                                              )),
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
                                            order['rating'],
                                            (i) => const Icon(
                                                Icons.star_rounded,
                                                color: Color.fromRGBO(
                                                    255, 186, 73, 1),
                                                size: 14),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          '(${order['reviews']})',
                                          style:
                                              AppTextStyles.greySubHeadingStyle(
                                                      color:
                                                          const Color.fromRGBO(
                                                              0, 0, 0, 0.6))
                                                  .copyWith(
                                            fontSize:
                                                10 * SizeConfig.widthScale,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5 * SizeConfig.heightScale,
                                    ),
                                    Text(order['price'],
                                        style: AppTextStyles.redw400Outfit()
                                            .copyWith(
                                          fontSize: 14 * SizeConfig.widthScale,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5 * SizeConfig.heightScale,
                          ),
                          const Divider(
                            color: Color.fromRGBO(0, 0, 0, 0.3),
                          ),
                          SizedBox(
                            height: 5 * SizeConfig.heightScale,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                order['deliveryDate'],
                                style: AppTextStyles.greySubHeadingStyle()
                                    .copyWith(
                                  fontSize: 12 * SizeConfig.widthScale,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          )
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
