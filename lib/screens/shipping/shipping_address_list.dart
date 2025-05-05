import 'package:customer_app/models/shipping_address.dart';
import 'package:customer_app/providers/shipping_address_provider.dart';
import 'package:customer_app/screens/shipping/shipping_details.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:customer_app/widgets/buttons/submit_button.dart';
import 'package:customer_app/widgets/headers/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShippingAddressListScreen extends StatefulWidget {
  const ShippingAddressListScreen({super.key});

  @override
  State<ShippingAddressListScreen> createState() =>
      _ShippingAddressListScreenState();
}

class _ShippingAddressListScreenState extends State<ShippingAddressListScreen> {
  bool _navigatedToAdd = false;

  @override
  void initState() {
    super.initState();
    _fetchAndNavigate();
  }

  Future<void> _fetchAndNavigate() async {
    final provider = Provider.of<ShippingAddressProvider>(
      context,
      listen: false,
    );
    await provider.fetchShippingAddresses();

    if (provider.shippingAddresses.isEmpty && mounted) {
      if (!_navigatedToAdd) {
        _navigatedToAdd = true;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ShippingDetailsScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: CommonAppBar(
          title: "My Addresses",
          menuPressed: () {},
          menuItems: [],
        ),
      ),
      body: Consumer<ShippingAddressProvider>(
        builder: (context, provider, _) {
          if (provider.isShippingAddressLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: EdgeInsets.all(20 * SizeConfig.widthScale),
            child: Column(
              children: [
                if (provider.shippingAddresses.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        "No addresses found.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.shippingAddresses.length,
                      itemBuilder: (context, index) {
                        final ShippingAddress address =
                            provider.shippingAddresses[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ShippingDetailsScreen(
                                      shippingAddress: address,
                                    ),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 1,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              tileColor: Colors.white,
                              title: Text(address.name ?? ''),
                              subtitle: Text(
                                '${address.address}, ${address.state}',
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                SizedBox(height: 20 * SizeConfig.heightScale),
                SubmitButton(
                  text: 'Add New Address',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ShippingDetailsScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20 * SizeConfig.heightScale),
              ],
            ),
          );
        },
      ),
    );
  }
}
