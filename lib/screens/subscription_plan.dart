import 'package:provider/provider.dart';
import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/providers/subscription_provider.dart';
import 'package:customer_app/providers/vendor_profile_provider.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:customer_app/widgets/buttons/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubscriptionScreen extends StatefulWidget {
  final int? initialPlanId;
  final bool isEdit;

  const SubscriptionScreen({
    super.key,
    this.initialPlanId,
    this.isEdit = false,
  });

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int? selectedPlanId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SubscriptionProvider>(
        context,
        listen: false,
      );
      provider.fetchSubscriptionPlans().then((_) {
        setState(() {
          selectedPlanId = widget.initialPlanId ??
              provider.subscriptionPlans.firstOrNull?.id;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SubscriptionProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0D2233),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20 * SizeConfig.heightScale),
            const Text(
              'Boost your business with',
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color.fromRGBO(255, 188, 73, 1),
                  Color.fromRGBO(243, 120, 102, 1),
                  Color.fromRGBO(243, 120, 102, 1),
                  Color.fromRGBO(243, 120, 102, 1),
                  Color.fromRGBO(243, 120, 102, 1),
                  Color.fromRGBO(255, 255, 255, 1),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: const Text(
                'Premium Plans',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 5 * SizeConfig.heightScale),
            Container(
              width: 100 * SizeConfig.widthScale,
              height: 1 * SizeConfig.heightScale,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent, // Start with transparent color
                    Colors.white, // Middle with white color
                    Colors.transparent, // End with transparent color
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            SizedBox(height: 15 * SizeConfig.heightScale),
            Expanded(
              child: provider.subscriptionPlans.isNotEmpty
                  ? ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20 * SizeConfig.widthScale,
                      ),
                      itemCount: provider.subscriptionPlans.length,
                      itemBuilder: (context, index) {
                        final plan = provider.subscriptionPlans[index];
                        return _buildPlanCard(
                          plan.id,
                          plan.name,
                          plan.offerPrice.toString(),
                          "NIS/Month",
                          plan.price > plan.offerPrice
                              ? "Discounted from ${plan.price} NIS"
                              : "",
                          [
                            'Limit: ${plan.limit} products',
                            'Commission: ${plan.commission}% per sale',
                            plan.customerSupport
                                ? 'Customer support access'
                                : '',
                            plan.orderTracking ? 'Able to Track Orders' : '',
                            plan.notifications
                                ? 'Receive notifications for orders and updates'
                                : '',
                            plan.featuredProducts
                                ? 'Ability to add products to the "Featured Products" section'
                                : '',
                            plan.promotions
                                ? 'Ability to send promotional notifications to customers'
                                : '',
                            plan.homePromotions
                                ? 'Create store or product advertisements on the homepage'
                                : '',
                            plan.socialPromotions
                                ? 'Create store or product advertisements on social media'
                                : '',
                          ],
                        );
                      },
                    )
                  : Center(
                      child: provider.subscriptionPlans.isEmpty
                          ? const Text(
                              "No subscription plans available.",
                              style: TextStyle(color: Colors.white),
                            )
                          : const CircularProgressIndicator(
                              color: Color.fromRGBO(255, 188, 73, 1),
                            ),
                    ),
            ),
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: SubmitButton(
                    text: 'Subscribe Now',
                    onPressed: () async {
                      if (selectedPlanId != null) {
                        final provider = Provider.of<SubscriptionProvider>(
                          context,
                          listen: false,
                        );
                        bool success = await provider.updateSubscription(
                          selectedPlanId ?? 3,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? "Subscription updated!"
                                  : provider.errorMessage ?? "Failed to update",
                            ),
                          ),
                        );
                        if (!widget.isEdit) {
                          Navigator.pushReplacementNamed(
                            context,
                            '/store_setup',
                          );
                        } else {
                          Navigator.pop(context);
                          Future.microtask(
                            () => Provider.of<VendorProfileProvider>(
                              context,
                              listen: false,
                            ).fetchVendorProfile(),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please select a subscription plan before proceeding.',
                            ),
                          ),
                        );
                      }
                    },
                    backgroundColor: Colors.white,
                    textColor: const Color.fromRGBO(0, 0, 0, 0.93),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: -10,
                  left: 30,
                  child: Image.asset(
                    'assets/icons/stars-left.png',
                    width: 50 * SizeConfig.widthScale,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  top: -10,
                  right: 30,
                  child: Image.asset(
                    'assets/icons/stars-right.png',
                    width: 50 * SizeConfig.widthScale,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    int id,
    String title,
    String price,
    String priceTag,
    String discount,
    List<String> features,
  ) {
    bool isSelected = selectedPlanId == id;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlanId = id;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
        child: CustomPaint(
          painter: isSelected
              ? GradientBorderPainter(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromRGBO(255, 188, 73, 1),
                      Color.fromRGBO(243, 120, 102, 1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  strokeWidth: 1,
                )
              : GradientBorderPainter(
                  gradient: const LinearGradient(
                    colors: [Colors.white, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  strokeWidth: 0.3,
                ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20 * SizeConfig.widthScale,
                      vertical: 7 * SizeConfig.heightScale,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [
                                Color.fromRGBO(255, 188, 73, 1),
                                Color.fromRGBO(243, 120, 102, 1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : const LinearGradient(
                              colors: [Colors.white, Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: Text(
                      title,
                      style: AppTextStyles.whiteButtonStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ).copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 16 * SizeConfig.widthScale,
                      ),
                    ),
                  ),
                  SizedBox(height: 5 * SizeConfig.heightScale),
                  ...features
                      .where(
                        (feature) => feature.isNotEmpty,
                      ) // Filter out empty features
                      .map(
                        (feature) => Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 3 * SizeConfig.heightScale,
                            horizontal: 10 * SizeConfig.widthScale,
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/list-tick-icon.svg',
                                height: 12,
                                width: 12,
                              ),
                              SizedBox(width: 5 * SizeConfig.widthScale),
                              Expanded(
                                child: Text(
                                  feature,
                                  style: AppTextStyles.blackSubHeadingStyle(
                                    color: const Color.fromRGBO(
                                      255,
                                      255,
                                      255,
                                      0.5,
                                    ),
                                  ).copyWith(
                                    fontSize: 12 * SizeConfig.widthScale,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ), // Convert back to a list if needed

                  SizedBox(height: 5 * SizeConfig.heightScale),
                ],
              ),
              Positioned(
                right: 10 * SizeConfig.widthScale,
                top: 5 * SizeConfig.heightScale,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: AppTextStyles.whitew400Outfit().copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                      textScaleFactor: SizeConfig.widthScale,
                    ),
                    Text(
                      priceTag,
                      style: AppTextStyles.whitew400Outfit().copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                      textScaleFactor: SizeConfig.widthScale,
                    ),
                    Text(
                      discount,
                      style: AppTextStyles.whitew400Outfit().copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                      textScaleFactor: SizeConfig.widthScale,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GradientBorderPainter extends CustomPainter {
  final LinearGradient gradient;
  final double strokeWidth;

  GradientBorderPainter({required this.gradient, this.strokeWidth = 1});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final RRect rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(4),
    );
    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
