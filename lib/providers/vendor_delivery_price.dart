import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vendor_app/models/vendor_delivery_price.dart';
import 'package:vendor_app/services/api_service.dart';
import 'package:vendor_app/services/log_service.dart';

class VendorDeliveryProvider with ChangeNotifier {
  List<VendorDeliveryPrice> _deliveryPrices = [];
  bool _isLoading = false;

  List<VendorDeliveryPrice> get deliveryPrices => _deliveryPrices;
  bool get isLoading => _isLoading;

  /// **Fetch Delivery Prices from API**
  Future<void> fetchVendorDeliveryPrices() async {
    _isLoading = true;
    notifyListeners();

    try {
      LogService.info("Fetching vendor delivery prices...");
      final response = await ApiService.getWithAuth(
        'get-vendor-delivery-price',
      );

      if (response == null) {
        LogService.error("No response from server");
        _isLoading = false;
        notifyListeners();
        return;
      }

      final Map<String, dynamic>? data = json.decode(response.body);
      LogService.info("Response Data: $data");

      if (data?["status"] == true && data?["data"] != null) {
        _deliveryPrices = VendorDeliveryPrice.listFromJson(data!["data"]);
      } else {
        throw Exception("API Error: ${response.body}");
      }
    } catch (e, stacktrace) {
      LogService.error("Exception: $e\n$stacktrace");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// **Check if a region already has a delivery price**
  VendorDeliveryPrice? getPriceForRegion(int regionId) {
    try {
      return _deliveryPrices.firstWhere(
        (price) => price.regionId == regionId,
        orElse: () => VendorDeliveryPrice(),
      );
    } catch (_) {
      return null;
    }
  }

  /// **Add or Update Delivery Price**
  Future<bool> saveVendorDeliveryPrice(int regionId, double price) async {
    VendorDeliveryPrice? existingPrice = getPriceForRegion(regionId);

    if (existingPrice?.id != null) {
      return await _updateDeliveryPrice(
        existingPrice!.id!,
        existingPrice.regionId!,
        price,
      );
    } else {
      // **Add new price**
      return await _addDeliveryPrice(regionId, price);
    }
  }

  /// **Add New Delivery Price**
  Future<bool> _addDeliveryPrice(int regionId, double price) async {
    try {
      // Ensure price is a double
      price = price.toDouble();

      final response = await ApiService.postWithAuth(
        'add-vendor-delivery-price',
        {"regions": regionId, "price": price},
      );

      if (response == null) {
        LogService.error("No response from server");
        return false;
      }

      final Map<String, dynamic> data =
          response is String
              ? json.decode(response)
              : response as Map<String, dynamic>;

      if (data?["status"] == true && data?["data"] != null) {
        _deliveryPrices.add(VendorDeliveryPrice.fromJson(data!["data"]));
        notifyListeners();
        return true;
      } else {
        throw Exception("API Error: ${response.body}");
      }
    } catch (e, stacktrace) {
      LogService.error("Exception: $e\n$stacktrace");
      return false;
    }
  }

  /// **Update Existing Delivery Price**
  Future<bool> _updateDeliveryPrice(
    int priceId,
    int regionId,
    double price,
  ) async {
    try {
      // Ensure price is a double
      price = price.toDouble();

      final response = await ApiService.postWithAuth(
        'update-vendor-delivery-price',
        {"id": priceId, "regions": regionId, "price": price},
      );

      if (response == null) {
        LogService.error("No response from server");
        return false;
      }

      final Map<String, dynamic> data =
          response is String
              ? json.decode(response)
              : response as Map<String, dynamic>;

      if (data?["status"] == true && data?["data"] != null) {
        int index = _deliveryPrices.indexWhere((p) => p.id == priceId);
        if (index != -1) {
          _deliveryPrices[index] = VendorDeliveryPrice.fromJson(data!["data"]);
          notifyListeners();
        }
        return true;
      } else {
        throw Exception("API Error: ${response.body}");
      }
    } catch (e, stacktrace) {
      LogService.error("Exception: $e\n$stacktrace");
      return false;
    }
  }
}
