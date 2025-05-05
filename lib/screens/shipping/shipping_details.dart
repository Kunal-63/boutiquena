import 'package:customer_app/models/shipping_address.dart';
import 'package:customer_app/providers/city_provider.dart';
import 'package:customer_app/providers/shipping_address_provider.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:customer_app/widgets/buttons/submit_button.dart';
import 'package:customer_app/widgets/headers/common_appbar.dart';
import 'package:customer_app/widgets/inputs/dropdown.dart';
import 'package:customer_app/widgets/inputs/input_widgets.dart';
import 'package:customer_app/widgets/popup_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShippingDetailsScreen extends StatefulWidget {
  final ShippingAddress? shippingAddress;
  const ShippingDetailsScreen({super.key, this.shippingAddress});

  @override
  State<ShippingDetailsScreen> createState() => _ShippingDetailsScreenState();
}

class _ShippingDetailsScreenState extends State<ShippingDetailsScreen> {
  late TextEditingController fullNameController;
  late TextEditingController phoneNumberController;
  late TextEditingController addressController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController countryController;
  late TextEditingController pincodeController;
  int? selectedCityId;

  bool get isEditMode => widget.shippingAddress != null;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(
      text: widget.shippingAddress?.name ?? '',
    );
    phoneNumberController = TextEditingController(
      text: widget.shippingAddress?.mobile ?? '',
    );
    addressController = TextEditingController(
      text: widget.shippingAddress?.address ?? '',
    );
    cityController = TextEditingController();
    selectedCityId = widget.shippingAddress?.cityID;
    stateController = TextEditingController(
      text: widget.shippingAddress?.state ?? '',
    );
    countryController = TextEditingController(
      text: widget.shippingAddress?.country ?? '',
    );
    pincodeController = TextEditingController(
      text: widget.shippingAddress?.pincode ?? '',
    );
    Future.microtask(
      () => Provider.of<CityProvider>(context, listen: false).fetchCities(),
    );
  }

  bool _areFieldsValid() {
    return fullNameController.text.trim().isNotEmpty &&
        phoneNumberController.text.trim().isNotEmpty &&
        selectedCityId != null &&
        stateController.text.trim().isNotEmpty &&
        pincodeController.text.trim().isNotEmpty &&
        addressController.text.trim().isNotEmpty;
  }

  Future<void> handleSave() async {
    if (!_areFieldsValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final provider = Provider.of<ShippingAddressProvider>(
      context,
      listen: false,
    );

    if (isEditMode) {
      final success = await provider.editShippingAddress(
        id: widget.shippingAddress!.id!,
        name: fullNameController.text,
        address: addressController.text,
        cityID: selectedCityId!,
        state: stateController.text,
        country: countryController.text,
        pincode: pincodeController.text,
        mobile: phoneNumberController.text,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address updated successfully')),
        );
        Navigator.pop(context);
      }
    } else {
      final success = await provider.addShippingAddress(
        name: fullNameController.text,
        address: addressController.text,
        cityID: selectedCityId!,
        state: stateController.text,
        country: countryController.text,
        pincode: pincodeController.text,
        mobile: phoneNumberController.text,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address added successfully')),
        );
        Navigator.pop(context);
      }
    }
  }

  Future<void> handleDelete() async {
    if (!isEditMode) return;

    final provider = Provider.of<ShippingAddressProvider>(
      context,
      listen: false,
    );

    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Address'),
            content: const Text(
              'Are you sure you want to delete this address?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      final success = await provider.deleteShippingAddress(
        widget.shippingAddress!.id!,
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address deleted successfully')),
        );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cityProvider = Provider.of<CityProvider>(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: CommonAppBar(
          title: "Shipping Details",
          menuPressed: () {},
          menuItems:
              isEditMode
                  ? [
                    PopupMenuHelper.buildPopupMenuItem(
                      onTap: () => handleSave(),
                      0,
                      'assets/icons/edit-popup-icon.svg',
                      'Edit',
                    ),
                    PopupMenuHelper.buildPopupMenuItem(
                      onTap: () => handleDelete(),
                      1,
                      'assets/icons/delete-icon.svg',
                      'Delete',
                    ),
                  ]
                  : [],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30.0 * SizeConfig.widthScale),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.37),
            color: const Color.fromRGBO(255, 255, 255, 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 3,
                spreadRadius: 0,
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputWidget(
                controller: fullNameController,
                label: 'Full Name',
                isRequired: true,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                controller: phoneNumberController,
                label: 'Phone Number',
                isRequired: true,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              if (cityProvider.cities.isNotEmpty)
                CustomDropdown(
                  items:
                      cityProvider.cities
                          .map((city) => city.name ?? '')
                          .toList(),
                  onChanged: (value) {
                    final selected = cityProvider.cities.firstWhere(
                      (c) => c.name == value,
                    );
                    setState(() {
                      selectedCityId = selected.id;
                    });
                  },
                  selectedItem:
                      cityProvider.cities
                          .firstWhere(
                            (c) => c.id == selectedCityId,
                            orElse: () => cityProvider.cities.first,
                          )
                          .name ??
                      '',
                  label: 'City',
                  isRequired: true,
                )
              else
                const SizedBox(),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                controller: stateController,
                label: 'State',
                isRequired: true,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              // InputWidget(controller: countryController, label: 'Country'),
              // SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                controller: pincodeController,
                label: 'Pincode',
                isRequired: true,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                controller: addressController,
                label: 'Full Address',
                hint: 'Street, Building, Floor',
                maxLines: 3,
                isRequired: true,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              SubmitButton(
                text: isEditMode ? 'Update Address' : 'Save Address',
                onPressed: handleSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
