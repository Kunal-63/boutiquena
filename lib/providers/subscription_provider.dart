import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:customer_app/models/subscription_plans.dart';
import 'package:customer_app/services/api_service.dart';
import 'package:customer_app/services/log_service.dart';

class SubscriptionProvider with ChangeNotifier {
  List<SubscriptionPlan> _plans = [];
  List<SubscriptionPlan> get subscriptionPlans => _plans;
  bool _isLoading = false;
  String? _errorMessage;

  List<SubscriptionPlan> get plans => _plans;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Fetch Subscription Plans
  Future<void> fetchSubscriptionPlans() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    LogService.info("Fetching subscription plans...");

    try {
      final response = await ApiService.getWithAuth('subscription-plans');
      if (response == null) {
        throw Exception("No response from server");
      }

      LogService.info("API Response Code: ${response.statusCode}");
      LogService.debug("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == true && data["product_categories"] != null) {
          _plans = (data["product_categories"] as List)
              .map((json) => SubscriptionPlan.fromJson(json))
              .toList();
          LogService.info("Subscription plans loaded successfully.");
        } else {
          _errorMessage = "Failed to load subscription plans.";
          LogService.warning("API returned failure status.");
        }
      } else {
        throw Exception("API Error: ${response.statusCode}");
      }
    } catch (e) {
      _errorMessage = "An error occurred while fetching plans: $e";
      LogService.error("Error fetching subscription plans: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Update Subscription Plan
  Future<bool> updateSubscription(int subscriptionId) async {
    LogService.info("Updating subscription plan: ID $subscriptionId");

    try {
      final response = await ApiService.postWithAuth('update-subscription', {
        "subscription_id": subscriptionId,
      });

      if (response == null) {
        throw Exception("No response from server");
      }

      // Check if response is a JSON-decoded map or an HTTP response
      if (response is Map<String, dynamic>) {
        // If response is already a map, extract values directly
        if (response["status"] == true) {
          LogService.info("Subscription updated successfully.");
          return true;
        } else {
          _errorMessage = response["message"] ?? "Subscription update failed.";
          LogService.warning("Subscription update failed: $_errorMessage");
          notifyListeners();
          return false;
        }
      } else {
        // If response is an HTTP response, decode it first
        LogService.info("API Response Code: ${response.statusCode}");
        final data = json.decode(response.body);

        if (data["status"] == true) {
          LogService.info("Subscription updated successfully.");
          return true;
        } else {
          _errorMessage = data["message"] ?? "Subscription update failed.";
          LogService.warning("Subscription update failed: $_errorMessage");
          notifyListeners();
          return false;
        }
      }
    } catch (e) {
      _errorMessage = "An error occurred while updating subscription: $e";
      LogService.error("Error updating subscription: $e");
      notifyListeners();
      return false;
    }
  }
}
