import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:customer_app/models/shipping_address.dart';
import 'package:customer_app/services/api_service.dart';
import 'package:customer_app/services/log_service.dart';

class ShippingAddressProvider extends ChangeNotifier {
  bool isShippingAddressLoading = false;
  List<ShippingAddress> shippingAddresses = [];

  Future<void> fetchShippingAddresses() async {
    isShippingAddressLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.getWithAuth('list-shipping-address');
      if (response != null && response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded['status'] == true) {
          final List<dynamic> addressList = decoded['data'];
          shippingAddresses =
              addressList
                  .map<ShippingAddress>(
                    (item) => ShippingAddress.fromJson(item),
                  )
                  .toList();
          print("SHIPPING ADDRESS$shippingAddresses");
        } else {
          shippingAddresses = [];
          LogService.error(
            'Shipping address fetch failed: ${decoded['message']}',
          );
        }
      } else {
        shippingAddresses = [];
        LogService.error(
          'Shipping address fetch failed: ${response?.statusCode}',
        );
      }
    } catch (e) {
      shippingAddresses = [];
      LogService.error('Shipping address fetch error: $e');
    } finally {
      isShippingAddressLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addShippingAddress({
    required String name,
    required String address,
    required String city,
    required String state,
    required String country,
    required String pincode,
    required String mobile,
  }) async {
    try {
      final response = await ApiService.postWithAuth('add-shipping-address', {
        'name': name,
        'address': address,
        'city': city,
        'state': state,
        'country': country,
        'pincode': pincode,
        'mobile': mobile,
      });

      if (response != null) {
        if (response['status'] == true) {
          await fetchShippingAddresses();
          return true;
        } else {
          LogService.error(
            'Add shipping address failed: ${response['message']}',
          );
        }
      } else {
        LogService.error('Add shipping address failed: Response is null');
      }
    } catch (e) {
      LogService.error('Add shipping address error: $e');
    }
    return false;
  }

  Future<bool> editShippingAddress({
    required int id,
    required String name,
    required String address,
    required String city,
    required String state,
    required String country,
    required String pincode,
    required String mobile,
  }) async {
    try {
      final response =
          await ApiService.postWithAuth('edit-shipping-address/$id', {
            'name': name,
            'address': address,
            'city': city,
            'state': state,
            'country': country,
            'pincode': pincode,
            'mobile': mobile,
          });

      if (response != null) {
        if (response['status'] == true) {
          await fetchShippingAddresses();
          return true;
        } else {
          LogService.error(
            'Edit shipping address failed: ${response['message']}',
          );
        }
      } else {
        LogService.error('Edit shipping address failed: Response is null');
      }
    } catch (e) {
      LogService.error('Edit shipping address error: $e');
    }
    return false;
  }

  Future<bool> deleteShippingAddress(int id) async {
    try {
      final response = await ApiService.deleteWithAuth(
        'delete-shipping-address/$id',
      );

      if (response != null) {
        if (response.statusCode == 200) {
          await fetchShippingAddresses();
          return true;
        } else {
          await fetchShippingAddresses();
          LogService.error('Delete shipping address failed: ${response.body}');
        }
      } else {
        await fetchShippingAddresses();
        LogService.error('Delete shipping address failed: Response is null');
      }
    } catch (e) {
      await fetchShippingAddresses();
      LogService.error('Delete shipping address error: $e');
    }
    return false;
  }
}
