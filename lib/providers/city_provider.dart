import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:customer_app/models/city.dart';
import 'package:customer_app/services/api_service.dart';
import 'package:customer_app/services/log_service.dart';

class CityProvider with ChangeNotifier {
  List<City> _cities = [];
  bool _isLoading = false;

  List<City> get cities => _cities;
  bool get isLoading => _isLoading;

  Future<void> fetchCities() async {
    _isLoading = true;
    notifyListeners();

    try {
      LogService.info("Fetching cities...");
      final response = await ApiService.getWithAuth('get-city');

      if (response == null) {
        LogService.error("No response from server");
        _isLoading = false;
        notifyListeners();
        return;
      }

      final Map<String, dynamic> data = json.decode(response.body);
      LogService.info("City Response Data: $data");

      if (data["status"] == true && data["data"] != null) {
        _cities = City.listFromJson(data["data"]);
      } else {
        throw Exception("API Error: ${response.body}");
      }
    } catch (e, stacktrace) {
      LogService.error("City Fetch Error: $e\n$stacktrace");
    }

    _isLoading = false;
    notifyListeners();
  }

  List<City> getCitiesByRegion(int regionId) {
    return _cities.where((c) => c.regionId == regionId).toList();
  }
}
