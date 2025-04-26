import 'package:customer_app/models/shipping_address.dart';
import 'package:customer_app/providers/shipping_address_provider.dart';
import 'package:customer_app/screens/shipping/shipping_details.dart';
import 'package:customer_app/utils/size_config.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShippingAddressProvider>(
        context,
        listen: false,
      ).fetchShippingAddresses();
    });
  }

  void _checkAndNavigate(ShippingAddressProvider provider) {
    if (!_navigatedToAdd && provider.shippingAddresses.isEmpty) {
      _navigatedToAdd = true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ShippingDetailsScreen()),
      );
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

          if (provider.shippingAddresses.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _checkAndNavigate(provider);
            });

            return const SizedBox();
          }

          return ListView.builder(
            padding: EdgeInsets.all(20 * SizeConfig.widthScale),
            itemCount: provider.shippingAddresses.length,
            itemBuilder: (context, index) {
              final ShippingAddress address = provider.shippingAddresses[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) =>
                              ShippingDetailsScreen(shippingAddress: address),
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
                    subtitle: Text('${address.address}, ${address.city}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
