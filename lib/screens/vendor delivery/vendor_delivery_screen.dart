import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:customer_app/models/region.dart';
import 'package:customer_app/models/vendor_delivery_price.dart';
import 'package:customer_app/providers/region_provider.dart';
import 'package:customer_app/providers/vendor_delivery_price.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:customer_app/widgets/buttons/submit_button.dart';
import 'package:customer_app/widgets/headers/common_appbar.dart';
import 'package:customer_app/widgets/inputs/dropdown.dart';
import 'package:customer_app/widgets/inputs/input_widgets.dart';

class VendorDeliveryScreen extends StatefulWidget {
  const VendorDeliveryScreen({super.key});

  @override
  State<VendorDeliveryScreen> createState() => _VendorDeliveryScreenState();
}

class _VendorDeliveryScreenState extends State<VendorDeliveryScreen> {
  final TextEditingController _controller = TextEditingController();
  int? _selectedRegionId;
  double? _existingPrice;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<RegionProvider>(context, listen: false).fetchRegions();
      Provider.of<VendorDeliveryProvider>(
        context,
        listen: false,
      ).fetchVendorDeliveryPrices();
    });
  }

  void _onRegionSelected(dynamic regionId) {
    final regionProvider = Provider.of<RegionProvider>(context, listen: false);
    final vendorDeliveryProvider = Provider.of<VendorDeliveryProvider>(
      context,
      listen: false,
    );

    // Use an empty Region object if no match is found
    final selectedRegion = regionProvider.regions?.firstWhere(
      (region) => region.id == regionId, // Compare with the region id
      orElse: () => Region(id: -1, name: "Unknown"),
    );

    // Check if a valid region was found (id != -1 means it was found)
    if (selectedRegion?.id != -1) {
      setState(() {
        _selectedRegionId =
            selectedRegion?.id; // Store the region id instead of name
        // Check if price already exists
        VendorDeliveryPrice? existingPrice = vendorDeliveryProvider
            .getPriceForRegion(_selectedRegionId!);
        _existingPrice = existingPrice?.price;
        _controller.text = _existingPrice?.toString() ?? "";
      });
    }
  }

  void _validateAndSubmit() async {
    final String fees = _controller.text.trim();

    if (_selectedRegionId == null || fees.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a region and enter delivery fees!'),
        ),
      );
      return;
    }

    if (!_isNumeric(fees)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Delivery Fees must be a valid number!')),
      );
      return;
    }

    double price = double.parse(fees);

    final vendorDeliveryProvider = Provider.of<VendorDeliveryProvider>(
      context,
      listen: false,
    );

    // Add or update delivery price
    bool success = await vendorDeliveryProvider.saveVendorDeliveryPrice(
      _selectedRegionId!,
      price,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Delivery price updated successfully!')),
      );

      vendorDeliveryProvider.fetchVendorDeliveryPrices(); // Refresh the list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update delivery price!')),
      );
    }
  }

  bool _isNumeric(String value) {
    return RegExp(r'^[0-9]+(\.[0-9]+)?$').hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    final regionProvider = Provider.of<RegionProvider>(context);
    final vendorDeliveryProvider = Provider.of<VendorDeliveryProvider>(context);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: CommonAppBar(
          title: "Vendor Delivery Fees",
          menuPressed: () {},
          menuItems: [],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(20 * SizeConfig.widthScale),
            padding: EdgeInsets.all(20 * SizeConfig.widthScale),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.37),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.06),
                  blurRadius: 3,
                  spreadRadius: 0,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                regionProvider.isLoading
                    ? const CircularProgressIndicator()
                    : CustomDropdown(
                      items:
                          regionProvider.regions
                              ?.map((region) => region.name ?? "Unknown")
                              .toList() ??
                          [],
                      onChanged: (regionName) {
                        final regionProvider = Provider.of<RegionProvider>(
                          context,
                          listen: false,
                        );
                        final selectedRegion = regionProvider.regions
                            ?.firstWhere(
                              (region) => region.name == regionName,
                              orElse: () => Region(id: -1, name: "Unknown"),
                            );
                        // Pass the region ID to the _onRegionSelected method
                        _onRegionSelected(selectedRegion?.id);
                      },
                      isMultiSelect: false,
                      label: 'Region',
                    ),
                SizedBox(height: 15 * SizeConfig.heightScale),
                InputWidget(controller: _controller, label: 'Delivery Fees'),
                SizedBox(height: 15 * SizeConfig.heightScale),
                SubmitButton(text: 'Save', onPressed: _validateAndSubmit),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
