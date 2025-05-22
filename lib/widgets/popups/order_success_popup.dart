import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/screens/orders/tracking_screen.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:customer_app/widgets/buttons/submit_button.dart';
import 'package:flutter/material.dart';

class OrderPlacedPopup extends StatefulWidget {
  final VoidCallback onClose;

  const OrderPlacedPopup({super.key, required this.onClose});

  @override
  State<OrderPlacedPopup> createState() => _OrderPlacedPopupState();
}

class _OrderPlacedPopupState extends State<OrderPlacedPopup> {
  int rating = 3;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: widget.onClose,
                child: const Icon(Icons.close, size: 20),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Thank You for Your Order!",
              style: AppTextStyles.blackSubHeadingStyle().copyWith(
                fontSize: 20 * SizeConfig.widthScale,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Image.asset("assets/images/rating.png"),
            const SizedBox(height: 10),
            Text(
              "Your order #12345678 has been successfully placed.\nWe’d love to hear your feedback!",
              textAlign: TextAlign.center,
              style: AppTextStyles.greySubHeadingStyle().copyWith(
                fontSize: 12 * SizeConfig.widthScale,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.grey.shade300, Colors.black87],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: const [0.0, 0.5],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "Rate Your Experience",
                    style: AppTextStyles.blackSubHeadingStyle().copyWith(
                      fontSize: 14 * SizeConfig.widthScale,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.grey.shade300, Colors.black87],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        stops: const [0.0, 0.5],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) => _buildStar(index)),
            ),
            const SizedBox(height: 10),
            SubmitButton(
              text: 'Submit',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TrackingScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStar(int index) {
    return IconButton(
      onPressed: () => setState(() => rating = index + 1),
      icon: Icon(
        index < rating ? Icons.star_rounded : Icons.star_border_rounded,
        size: 30,
        color:
            index < rating ? Colors.amber : Color.fromRGBO(112, 112, 112, 0.5),
      ),
    );
  }
}
