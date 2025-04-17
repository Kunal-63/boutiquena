import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/config/theme.dart';
import 'package:customer_app/screens/orders/checkout_screen.dart';
import 'package:customer_app/screens/orders/tracking_screen.dart';
import 'package:customer_app/utils/custom_network_image.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:customer_app/widgets/order_tracking.dart';
import 'package:flutter/material.dart';

class OrderPlaced extends StatelessWidget {
  OrderPlaced({super.key});

  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  String? city;
  TextEditingController addressController = TextEditingController();
  String? saveAdress;
  TextEditingController otherDetails = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30.0 * SizeConfig.widthScale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/icons/confetti.png',
                height: 60 * SizeConfig.widthScale,
                width: 60 * SizeConfig.widthScale,
              ),
            ),
            SizedBox(height: 20 * SizeConfig.heightScale),
            Text(
              "Thank You! \n Your Order has been Placed",
              style: AppTextStyles.blackSubHeadingStyle().copyWith(
                fontSize: 20 * SizeConfig.widthScale,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10 * SizeConfig.heightScale),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 15 * SizeConfig.widthScale,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  width: 0.5,
                ),
              ),
              width: 200 * SizeConfig.widthScale,
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Order number:",
                    style: AppTextStyles.blackSubHeadingStyle().copyWith(
                      fontSize: 12 * SizeConfig.widthScale,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 5 * SizeConfig.heightScale),
                  Text(
                    "#00143535",
                    style: AppTextStyles.greySubHeadingStyle().copyWith(
                      fontSize: 12 * SizeConfig.widthScale,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10 * SizeConfig.heightScale),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TrackingScreen()),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 15 * SizeConfig.widthScale,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Color.fromRGBO(0, 0, 0, 0.3),
                    width: 0.5,
                  ),
                ),
                width: 200 * SizeConfig.widthScale,
                alignment: Alignment.center,
                child: Text(
                  "Track Order",
                  style: AppTextStyles.whitew400Outfit().copyWith(
                    fontSize: 16 * SizeConfig.widthScale,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            CardContainer(
              title: 'Shipping To',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Full Name:',
                        style: AppTextStyles.blackSubHeadingStyle().copyWith(
                          fontSize: 12 * SizeConfig.widthScale,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 5 * SizeConfig.heightScale),
                      Text(
                        'Kunal Adwani',
                        style: AppTextStyles.greySubHeadingStyle().copyWith(
                          fontSize: 12 * SizeConfig.widthScale,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5 * SizeConfig.heightScale),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Phone Number:',
                        style: AppTextStyles.blackSubHeadingStyle().copyWith(
                          fontSize: 12 * SizeConfig.widthScale,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 5 * SizeConfig.heightScale),
                      Text(
                        '+972 54-1234567',
                        style: AppTextStyles.greySubHeadingStyle().copyWith(
                          fontSize: 12 * SizeConfig.widthScale,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5 * SizeConfig.heightScale),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Address:',
                        style: AppTextStyles.blackSubHeadingStyle().copyWith(
                          fontSize: 12 * SizeConfig.widthScale,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 5 * SizeConfig.heightScale),
                      Flexible(
                        child: Text(
                          '123 Herzl Street, Apartment 5, Tel Aviv-Yafo, 6525801, Israel',
                          style: AppTextStyles.greySubHeadingStyle().copyWith(
                            fontSize: 12 * SizeConfig.widthScale,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5 * SizeConfig.heightScale),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Shipping Method:',
                        style: AppTextStyles.blackSubHeadingStyle().copyWith(
                          fontSize: 12 * SizeConfig.widthScale,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 5 * SizeConfig.heightScale),
                      Text(
                        'COD (Cash on Delivery)',
                        style: AppTextStyles.greySubHeadingStyle().copyWith(
                          fontSize: 12 * SizeConfig.widthScale,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5 * SizeConfig.heightScale),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Estimated Delivery Date:',
                        style: AppTextStyles.blackSubHeadingStyle().copyWith(
                          fontSize: 12 * SizeConfig.widthScale,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 5 * SizeConfig.heightScale),
                      Text(
                        'March 10, 2025',
                        style: AppTextStyles.greySubHeadingStyle().copyWith(
                          fontSize: 12 * SizeConfig.widthScale,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CardContainer(
              title: 'Product Details',
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 15 * SizeConfig.widthScale,
                      horizontal: 10 * SizeConfig.widthScale,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomNetworkImage(
                          imageUrl:
                              'https://ts1.mm.bing.net/th?id=OIP.A1DvA7N7QgNLsblkh0pG6gHaEv&pid=15.1',
                          errorImage: 'assets/icons/no-image.png',
                          width: 60 * SizeConfig.widthScale,
                          height: 70 * SizeConfig.widthScale,
                          fit: BoxFit.cover,
                          radius: 5,
                        ),
                        SizedBox(width: 12 * SizeConfig.widthScale),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Evening Dress',
                                style: AppTextStyles.blackSubHeadingStyle(
                                  color: Color.fromRGBO(0, 0, 0, 0.6),
                                ).copyWith(
                                  fontSize: 10 * SizeConfig.widthScale,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'Dorothy Perkins',
                                style: AppTextStyles.blackSubHeadingStyle()
                                    .copyWith(
                                      fontSize: 14 * SizeConfig.widthScale,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                              Text(
                                'Store : Trendy Fashion',
                                style: AppTextStyles.blackSubHeadingStyle(
                                  color: Color.fromRGBO(0, 0, 0, 0.6),
                                ).copyWith(
                                  fontSize: 12 * SizeConfig.widthScale,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'M | Black | Flat 20% off',
                                style: AppTextStyles.blackSubHeadingStyle(
                                  color: Color.fromRGBO(0, 0, 0, 0.5),
                                ).copyWith(
                                  fontSize: 12 * SizeConfig.widthScale,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12 * SizeConfig.widthScale),
                        Text(
                          "27 ₪",
                          style: AppTextStyles.redw400Outfit().copyWith(
                            fontSize: 18 * SizeConfig.widthScale,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20 * SizeConfig.heightScale),
            Text(
              'Your order #00143535 has been confirmed! Estimated delivery by March 10, 2025.',
              style: AppTextStyles.greySubHeadingStyle().copyWith(
                fontSize: 12 * SizeConfig.widthScale,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
