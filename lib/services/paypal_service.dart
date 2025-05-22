// import 'package:flutter/material.dart';
// import 'package:flutter_braintree_payment/flutter_braintree_payment.dart';
// import 'package:customer_app/providers/cart_provider.dart';
// import 'package:provider/provider.dart';

// class PayPalService {
//   static Future<bool> processPayment(BuildContext context) async {
//     try {
//       final cartProvider = Provider.of<CartProvider>(context, listen: false);
//       final totalAmount = cartProvider.totalCartValue.toStringAsFixed(2);

//       // Initialize Braintree payment and client token
//       final request = BraintreePayment();

//       // Normally, this should be done on the server side, not here
//       final clientToken =
//           'AY3eLhOUfiAy9mShf2GrrazAw0WSMuykbH4XQQSEf8pb9yttPbFXPDj6I5LQ8-k3-iXfBCORGGA3DCBN'; // You'd need to find a way to generate this in Flutter directly

//       // Start PayPal payment flow
//       final result = await request.paypalPayment(
//         PayPalRequest(
//           token: clientToken,
//           amount: totalAmount,
//           displayName: 'BOUTIQUE NA',
//           androidAppLinkReturnUrl: 'customerapp://main_screen',
//         ),
//       );

//       if (result != null) {
//         debugPrint('PayPal Nonce: ${result.nonce}');

//         // For now, simulate success
//         return true;
//       } else {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text('Payment canceled.')));
//         return false;
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Payment error: $e')));
//       return false;
//     }
//   }
// }
