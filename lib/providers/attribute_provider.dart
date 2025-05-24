import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vendor_app/models/attribute_model.dart';
import 'package:vendor_app/services/api_service.dart';
import 'package:vendor_app/services/log_service.dart';

class AttributeProvider with ChangeNotifier {
  List<AttributeType> _attributeTypes = [];
  bool _isLoading = false;

  List<AttributeType> get attributeTypes => _attributeTypes;
  bool get isLoading => _isLoading;

  /// **Fetch Attribute Types from API**
  Future<void> fetchAttributeTypes() async {
    _isLoading = true;
    notifyListeners();

    try {
      LogService.info("Fetching attribute types...");
      final response = await ApiService.getWithAuth('get-attribute-type');

      if (response == null || response.body == null) {
        LogService.error("No response from server");
        _isLoading = false;
        notifyListeners();
        return;
      }

      final Map<String, dynamic> data = json.decode(response.body);
      LogService.info("Attribute Response: $data");

      if (data["status"] == true && data["data"] != null) {
        _attributeTypes = AttributeType.listFromJson(data["data"]);
      } else {
        throw Exception("API Error: ${response.body}");
      }
    } catch (e, stacktrace) {
      LogService.error("Attribute Fetch Error: $e\n$stacktrace");
    }

    _isLoading = false;
    notifyListeners();
  }

  AttributeType? getById(int id) {
    try {
      return _attributeTypes.firstWhere((attr) => attr.id == id);
    } catch (_) {
      return null;
    }
  }
}
