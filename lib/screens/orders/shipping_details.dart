import 'package:customer_app/screens/orders/order_placed_screen.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:customer_app/widgets/buttons/submit_button.dart';
import 'package:customer_app/widgets/headers/common_appbar.dart';
import 'package:customer_app/widgets/inputs/dropdown.dart';
import 'package:customer_app/widgets/inputs/input_widgets.dart';
import 'package:customer_app/widgets/popup_menu_item.dart';
import 'package:flutter/material.dart';

class ShippingDetails extends StatelessWidget {
  ShippingDetails({super.key});

  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  String? city;
  TextEditingController addressController = TextEditingController();
  String? saveAdress;
  TextEditingController otherDetails = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: CommonAppBar(
          title: "Shipping Details",
          menuPressed: () {},
          menuItems: [
            PopupMenuHelper.buildPopupMenuItem(
              0,
              'assets/icons/edit-popup-icon.svg',
              'Edit',
            ),
          ],
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
              InputWidget(controller: fullNameController, label: 'Full Name'),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                controller: phoneNumberController,
                label: 'Phone Number',
                prefix: '+972',
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              CustomDropdown(items: [''], onChanged: (val) {}, label: 'City'),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                controller: addressController,
                label: 'Full Address',
                hint: 'Street, Building, Floor',
                maxLines: 3,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                controller: otherDetails,
                label: 'Other Details',
                hint: 'Apartment, Landmark, etc.',
                maxLines: 3,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              SubmitButton(
                text: 'Save Adress',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => OrderPlaced()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
