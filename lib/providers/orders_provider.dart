import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:customer_app/models/orders.dart';
// import '../models/order_model.dart';
import '../services/api_service.dart';
import '../services/log_service.dart';

class OrderProvider with ChangeNotifier {
  List<Order>? _orders;
  bool _isLoading = false;

  List<Order>? get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      LogService.info("Fetching orders...");

      final response = await ApiService.getWithAuth('get_orders');

      if (response == null) {
        LogService.error("No response from server");
        _isLoading = false;
        notifyListeners();
        return;
      }

      LogService.info("Response Data: $response");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true && data['data'] != null) {
          _orders = Order.listFromJson(data["data"] ?? []);
        } else {
          throw Exception(
            "API Error: ${response.statusCode} - ${response.body}",
          );
        }
      }
    } catch (e, stacktrace) {
      LogService.error("Exception: $e\n$stacktrace");
    }

    _isLoading = false;
    notifyListeners();
  }
}
