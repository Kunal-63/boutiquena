import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/config/theme.dart';
import 'package:customer_app/models/cart_group.dart';
import 'package:customer_app/models/shipping_address.dart';
import 'package:customer_app/providers/cart_provider.dart';
import 'package:customer_app/providers/shipping_address_provider.dart';
import 'package:customer_app/screens/shipping/shipping_details.dart';
import 'package:customer_app/utils/custom_network_image.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:customer_app/widgets/buttons/checkbox.dart';
import 'package:customer_app/widgets/buttons/submit_button.dart';
import 'package:customer_app/widgets/inputs/dropdown.dart';
import 'package:customer_app/widgets/inputs/input_widgets.dart';
import 'package:customer_app/widgets/popups/order_success_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  late CartProvider _cartProvider;
  CartGroup? selectedGroup;
  Map<int, Set<int>> groupStoreSelections = {};

  @override
  void initState() {
    super.initState();
    _cartProvider = Provider.of<CartProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _cartProvider.nullifyCart();
      _cartProvider.fetchCartGroups();
      _cartProvider.fetchCartCoupons();
    });
  }

  void _onSubmit() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) =>
              OrderPlacedPopup(onClose: () => Navigator.of(context).pop()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mergeableGroups = context.watch<CartProvider>().mergeableGroups;
    final groupNames = mergeableGroups?.map((g) => g.groupName).toList() ?? [];

    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16 * SizeConfig.widthScale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30 * SizeConfig.heightScale),

            // Mergeable Group Container
            Container(
              padding: EdgeInsets.all(10 * SizeConfig.widthScale),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 1,
                    spreadRadius: 0,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.37),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/left-icon.svg',
                        height: 14 * SizeConfig.widthScale,
                        width: 14 * SizeConfig.widthScale,
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 10 * SizeConfig.widthScale),
                      Text(
                        "Merge Your Order With",
                        style: AppTextStyles.blackSubHeadingStyle().copyWith(
                          fontSize: 16 * SizeConfig.widthScale,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  CustomDropdown(
                    items: groupNames,
                    onChanged: (selectedGroupName) {
                      final selected = mergeableGroups?.firstWhere(
                        (g) => g.groupName == selectedGroupName,
                        orElse:
                            () => CartGroup(
                              groupId: 0,
                              groupName: 'Unknown',
                              cost: 0,
                              storeIds: [],
                              matchedStores: [],
                            ),
                      );

                      setState(() {
                        selectedGroup = selected;
                        // Ensure current group has an entry
                        groupStoreSelections.putIfAbsent(
                          selectedGroup!.groupId,
                          () => {},
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  if (selectedGroup != null)
                    ...selectedGroup!.matchedStores.map((store) {
                      final groupId = selectedGroup!.groupId;
                      final selectedSet = groupStoreSelections[groupId] ?? {};
                      return StoreSelectorTile(
                        title: store.name,
                        products: 0,
                        isSelected: selectedSet.contains(store.id),
                        onChanged: (val) {
                          setState(() {
                            final storeSet = groupStoreSelections.putIfAbsent(
                              groupId,
                              () => {},
                            );
                            if (val == true) {
                              storeSet.add(store.id);
                            } else {
                              storeSet.remove(store.id);
                            }
                          });
                        },
                        logoAsset: '',
                      );
                    }).toList(),

                  SizedBox(height: 5 * SizeConfig.widthScale),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Clear All Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            groupStoreSelections.clear();
                            CartProvider.selectedStoreIds = [];
                            CartProvider.selectedGroupIds = [];
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Selections cleared.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Text(
                          "Clear All",
                          style: AppTextStyles.redw400Outfit().copyWith(
                            fontSize: 14 * SizeConfig.widthScale,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),

                      // Update Button
                      GestureDetector(
                        onTap: () {
                          final allSelectedStoreIds =
                              groupStoreSelections.values
                                  .expand((storeSet) => storeSet)
                                  .toSet();

                          final selectedGroups =
                              mergeableGroups
                                  ?.where(
                                    (group) => group.matchedStores.any(
                                      (store) => allSelectedStoreIds.contains(
                                        store.id,
                                      ),
                                    ),
                                  )
                                  .map((g) => g.groupId)
                                  .toList() ??
                              [];

                          setState(() {
                            CartProvider.selectedStoreIds =
                                allSelectedStoreIds.toList();
                            CartProvider.selectedGroupIds = selectedGroups;
                          });

                          Provider.of<CartProvider>(
                            context,
                            listen: false,
                          ).fetchCart();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Cart updated successfully.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Text(
                          "Update",
                          style: AppTextStyles.redw400Outfit().copyWith(
                            fontSize: 14 * SizeConfig.widthScale,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ProductSummaryCard(),
            ShippingDetailsCard(),
            PaymentMethodCard(),
            DiscountPromoCard(),
            AdditionalNotesCard(),
            SizedBox(height: 10 * SizeConfig.heightScale),

            SubmitButton(text: 'Place Order & Pay', onPressed: _onSubmit),

            SizedBox(height: 5 * SizeConfig.heightScale),
            Text(
              'Orders cannot be canceled or modified after completion.',
              style: AppTextStyles.redw400Outfit().copyWith(
                fontSize: 12 * SizeConfig.widthScale,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoreSelectorTile extends StatelessWidget {
  final String title;
  final int products;
  final bool isSelected;
  final Function(bool?) onChanged;
  final String logoAsset;

  const StoreSelectorTile({
    super.key,
    required this.title,
    required this.products,
    required this.isSelected,
    required this.onChanged,
    required this.logoAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12 * SizeConfig.widthScale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            radius: 20 * SizeConfig.widthScale,
            child: Text(
              title.isNotEmpty ? title[0].toUpperCase() : '',
              style: TextStyle(
                fontSize: 18 * SizeConfig.widthScale,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(width: 12 * SizeConfig.widthScale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.redw400Outfit(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                  ).copyWith(
                    fontSize: 14 * SizeConfig.widthScale,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          CustomCheckbox(
            label: '',
            value: isSelected,
            onChanged: onChanged,
            borderColor: const Color.fromRGBO(0, 0, 0, 0.5),
            fillColor: const Color.fromRGBO(0, 0, 0, 0.05),
            tickAsset: 'assets/icons/tick-icon.svg',
          ),
        ],
      ),
    );
  }
}

class ProductSummaryCard extends StatefulWidget {
  const ProductSummaryCard({super.key});

  @override
  _ProductSummaryCardState createState() => _ProductSummaryCardState();
}

class _ProductSummaryCardState extends State<ProductSummaryCard> {
  late CartProvider _cartProvider;

  @override
  void initState() {
    super.initState();
    _cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Delay fetching cart until after first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cartProvider.fetchCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        if (CartProvider.cartItems.isEmpty) {
          return Container(
            margin: EdgeInsets.only(top: 16 * SizeConfig.heightScale),
            padding: EdgeInsets.all(12 * SizeConfig.widthScale),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 1,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Cart is empty',
                style: AppTextStyles.blackSubHeadingStyle(
                  color: Colors.grey,
                ).copyWith(
                  fontSize: 16 * SizeConfig.widthScale,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }

        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 16 * SizeConfig.heightScale),
            padding: EdgeInsets.all(12 * SizeConfig.widthScale),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 1,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: CartProvider.cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = CartProvider.cartItems[index];
                    final itemSubtotal =
                        double.tryParse(cartItem.totalPrice) ?? 0;

                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomNetworkImage(
                              imageUrl: cartItem.productImageUrl,
                              errorImage: 'assets/icons/no-image.png',
                              width: 60 * SizeConfig.widthScale,
                              height: 70 * SizeConfig.widthScale,
                              fit: BoxFit.cover,
                              radius: 5,
                            ),
                            SizedBox(width: 12 * SizeConfig.widthScale),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartItem.productName,
                                    style: AppTextStyles.blackSubHeadingStyle(
                                      color: Color.fromRGBO(0, 0, 0, 0.6),
                                    ).copyWith(
                                      fontSize: 10 * SizeConfig.widthScale,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    'Dorothy Perkins',
                                    style: AppTextStyles.blackSubHeadingStyle()
                                        .copyWith(
                                          fontSize: 14 * SizeConfig.widthScale,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  SizedBox(height: 6 * SizeConfig.heightScale),
                                  Row(
                                    children: [
                                      Container(
                                        height: 30 * SizeConfig.heightScale,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8 * SizeConfig.widthScale,
                                          vertical: 4 * SizeConfig.heightScale,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          "M",
                                          style:
                                              AppTextStyles.blackSubHeadingStyle()
                                                  .copyWith(
                                                    fontSize:
                                                        12 *
                                                        SizeConfig.widthScale,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8 * SizeConfig.widthScale,
                                      ),
                                      QuantitySelector(
                                        initialQuantity: cartItem.quantity,
                                        onQuantityChanged: (newQuantity) async {
                                          return await cartProvider
                                              .updateCart(
                                                cartId: cartItem.cartId,
                                                quantity: newQuantity,
                                              )
                                              .then((isSuccess) {
                                                if (isSuccess) {
                                                  cartProvider.fetchCart();
                                                }
                                                return isSuccess;
                                              });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                cartProvider.deleteCart(
                                  cartId: cartItem.cartId,
                                );
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/delete-icon.svg',
                                    width: 10 * SizeConfig.widthScale,
                                    height: 10 * SizeConfig.widthScale,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "Delete",
                                    style: AppTextStyles.redw400Outfit()
                                        .copyWith(
                                          fontSize: 12 * SizeConfig.widthScale,
                                          color: const Color(0xFFFF5B5B),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        InfoRow(
                          label:
                              "Subtotal (${cartItem.quantity} x ${cartItem.totalPrice} ₪)",
                          value: "${cartItem.finalPrice.toStringAsFixed(2)} ₪",
                        ),
                        Divider(),
                      ],
                    );
                  },
                ),

                /// Tax, delivery, total section
                InfoRow(
                  label: "Delivery Charges:",
                  value: "${cartProvider.deliveryCharges.toStringAsFixed(2)} ₪",
                ),
                InfoRow(
                  label: "Taxes:",
                  value: "${cartProvider.tax.toStringAsFixed(2)} ₪",
                ),
                InfoRow(
                  label: "Subtotal:",
                  value: "${cartProvider.cartValue.toStringAsFixed(2)} ₪",
                ),
                SizedBox(height: 8 * SizeConfig.heightScale),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12 * SizeConfig.widthScale,
                    vertical: 10 * SizeConfig.heightScale,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFEEEEE)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Grand Total",
                        style: AppTextStyles.blackSubHeadingStyle().copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16 * SizeConfig.widthScale,
                        ),
                      ),
                      Text(
                        "${cartProvider.totalCartValue.toStringAsFixed(2)} ₪",
                        style: AppTextStyles.redw400Outfit().copyWith(
                          fontSize: 18 * SizeConfig.widthScale,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class QuantitySelector extends StatefulWidget {
  final int initialQuantity;
  final Future<bool> Function(int) onQuantityChanged;

  const QuantitySelector({
    super.key,
    required this.initialQuantity,
    required this.onQuantityChanged,
  });

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
  }

  void _updateQuantity(int newQuantity) async {
    bool success = await widget.onQuantityChanged(newQuantity);
    if (success) {
      setState(() {
        quantity = newQuantity;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update quantity.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30 * SizeConfig.heightScale,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 12),
            onPressed: () {
              if (quantity > 1) {
                _updateQuantity(quantity - 1);
              }
            },
          ),
          Text(
            '$quantity',
            style: TextStyle(
              fontSize: 14 * SizeConfig.widthScale,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 12),
            onPressed: () {
              _updateQuantity(quantity + 1);
            },
          ),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4 * SizeConfig.heightScale),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.blackSubHeadingStyle().copyWith(
              fontSize: 14 * SizeConfig.widthScale,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.blackSubHeadingStyle(
              color: Color.fromRGBO(0, 0, 0, 0.5),
            ).copyWith(
              fontSize: 12 * SizeConfig.widthScale,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class ShippingDetailsCard extends StatefulWidget {
  const ShippingDetailsCard({super.key});

  @override
  State<ShippingDetailsCard> createState() => _ShippingDetailsCardState();
}

class _ShippingDetailsCardState extends State<ShippingDetailsCard> {
  String? selectedMethod;
  String? selectedAddressId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch shipping addresses when the screen is first loaded
      Provider.of<ShippingAddressProvider>(
        context,
        listen: false,
      ).fetchShippingAddresses();
      // Fetch cart details once addresses are fetched
      Provider.of<CartProvider>(context, listen: false).fetchCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final shippingAddressProvider = Provider.of<ShippingAddressProvider>(
      context,
    );
    final shippingAddresses = shippingAddressProvider.shippingAddresses;
    // Correctly define cartProvider
    final cartProvider = Provider.of<CartProvider>(context);

    return Container(
      margin: EdgeInsets.only(top: 16 * SizeConfig.heightScale),
      padding: EdgeInsets.all(16 * SizeConfig.widthScale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 1)],
      ),
      child:
          shippingAddresses.isEmpty
              ? _buildAddShippingAddress(context)
              : _buildShippingDetails(context, shippingAddresses, cartProvider),
    );
  }

  Widget _buildAddShippingAddress(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ShippingDetailsScreen(shippingAddress: null),
          ),
        );
      },
      child: Container(
        height: 150 * SizeConfig.heightScale,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_location_alt_outlined,
                size: 40,
                color: Colors.grey,
              ),
              SizedBox(height: 10),
              Text(
                "Add Shipping Address",
                style: AppTextStyles.blackSubHeadingStyle().copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 16 * SizeConfig.widthScale,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShippingDetails(
    BuildContext context,
    List<ShippingAddress> shippingAddresses,
    CartProvider cartProvider, // Passed in cartProvider here
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: shippingAddresses.length,
          itemBuilder: (context, index) {
            final ShippingAddress address = shippingAddresses[index];
            return Container(
              margin: EdgeInsets.only(bottom: 10 * SizeConfig.heightScale),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color:
                      (selectedAddressId == address.id)
                          ? Colors.redAccent
                          : Colors.grey.shade300,
                ),
              ),
              child: RadioListTile<String>(
                value: address.id?.toString() ?? '',
                groupValue: selectedAddressId,
                onChanged: (value) {
                  setState(() {
                    selectedAddressId = value;
                    CartProvider.selectedShippingId = int.parse(value!);
                    cartProvider.fetchCart();
                  });
                },
                title: Row(
                  children: [
                    Expanded(child: Text(address.name ?? '')),
                    GestureDetector(
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
                      child: Icon(
                        Icons.edit,
                        color: Color.fromRGBO(243, 120, 102, 1),
                        size: 20 * SizeConfig.widthScale,
                      ),
                    ),
                  ],
                ),
                subtitle: Text('${address.address}, ${address.state}'),
                activeColor: Colors.redAccent,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            );
          },
        ),
        const Divider(),
        Text(
          "Choose Shipping Method",
          style: AppTextStyles.blackSubHeadingStyle().copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 16 * SizeConfig.widthScale,
          ),
        ),
        _radioTile("Express Delivery"),
        _radioTile("Regular Delivery"),
        _radioTile("Store Pickup"),

        // Estimated Delivery Date
        Container(
          margin: EdgeInsets.only(top: 16 * SizeConfig.heightScale),
          padding: EdgeInsets.all(12 * SizeConfig.widthScale),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFFEEEEE)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: RichText(
            text: TextSpan(
              text: "Estimated Delivery Date: ",
              style: AppTextStyles.greySubHeadingStyle().copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14 * SizeConfig.widthScale,
              ),
              children: [
                TextSpan(
                  text: "29 March, 2025",
                  style: AppTextStyles.blackSubHeadingStyle().copyWith(
                    fontWeight: FontWeight.w300,
                    fontSize: 14 * SizeConfig.widthScale,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _radioTile(String label) {
    return RadioListTile<String>(
      value: label,
      groupValue: selectedMethod,
      onChanged: (val) => setState(() => selectedMethod = val),
      title: Text(
        label,
        style: AppTextStyles.blackSubHeadingStyle(
          color: Color.fromRGBO(0, 0, 0, 0.5),
        ).copyWith(
          fontSize: 14 * SizeConfig.widthScale,
          fontWeight: FontWeight.w300,
        ),
      ),
      activeColor: const Color(0xFFFF5B5B),
      contentPadding: EdgeInsets.zero,
    );
  }
}

class CardContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const CardContainer({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16 * SizeConfig.heightScale),
      padding: EdgeInsets.all(16 * SizeConfig.widthScale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 1)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const Divider(height: 24),
          child,
        ],
      ),
    );
  }
}

class PaymentMethodCard extends StatefulWidget {
  const PaymentMethodCard({super.key});

  @override
  State<PaymentMethodCard> createState() => _PaymentMethodCardState();
}

class _PaymentMethodCardState extends State<PaymentMethodCard> {
  String selectedMethod = "Card";

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      title: "Payment Methods",
      child: Column(
        children: [
          _radioOption(
            "Visa/Mastercard/Debit Card",
            "Card",
            'assets/icons/card-icon.png',
          ),
          _radioOption("PayPal", "PayPal", 'assets/icons/paypal-icon.png'),
          _radioOption(
            "Apple Pay / Google Pay",
            "GooglePay",
            'assets/icons/google-icon.png',
          ),
          _radioOption(
            "Cash on Delivery (COD)",
            "COD",
            'assets/icons/coin-icon.png',
          ),
        ],
      ),
    );
  }

  Widget _radioOption(String label, String value, String iconPath) {
    final isSelected = selectedMethod == value;

    return GestureDetector(
      onTap: () => setState(() => selectedMethod = value),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromRGBO(112, 112, 112, 1),
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(iconPath),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.blackSubHeadingStyle(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                ).copyWith(
                  fontSize: 12 * SizeConfig.widthScale,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color.fromRGBO(112, 112, 112, 1),
                  width: 2,
                ),
              ),
              child:
                  isSelected
                      ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(112, 112, 112, 1),
                          ),
                        ),
                      )
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}

class DiscountPromoCard extends StatefulWidget {
  const DiscountPromoCard({super.key});

  @override
  State<DiscountPromoCard> createState() => _DiscountPromoCardState();
}

class _DiscountPromoCardState extends State<DiscountPromoCard> {
  final TextEditingController promoCodeController = TextEditingController();
  bool redeemCoins = true;

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      title: "Discounts & Promo Code",
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: promoCodeController,
                  autofocus: false,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  decoration: AppTheme.inputDecoration.copyWith(
                    hintText: 'Enter Promo Code',
                    counterText: "", // Hides the character counter
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(219, 233, 233, 1),
                        width: 0.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(219, 233, 233, 1),
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(219, 233, 233, 1),
                        width: 0.5,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 0,
                      minHeight: 0,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF151D27),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20 * SizeConfig.widthScale,
                      vertical: 12 * SizeConfig.heightScale,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: Text("Apply", style: AppTextStyles.whitew400Outfit()),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              CustomCheckbox(
                label: '',
                value: redeemCoins,
                onChanged: (bool? isselected) {},
                borderColor: const Color.fromRGBO(0, 0, 0, 0.5),
                fillColor: const Color.fromRGBO(0, 0, 0, 0.05),
                tickAsset: 'assets/icons/tick-icon.svg',
              ),
              Expanded(
                child: Text(
                  "Redeem Coins for Discounts",
                  style: AppTextStyles.greySubHeadingStyle().copyWith(
                    fontSize: 12 * SizeConfig.widthScale,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Text(
                "100 ₪",
                style: AppTextStyles.greySubHeadingStyle(
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                ).copyWith(
                  fontSize: 14 * SizeConfig.widthScale,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Consumer<CartProvider>(
            builder: (context, cartProvider, _) {
              final coupons = cartProvider.coupons ?? [];

              if (coupons.isEmpty) {
                return const SizedBox.shrink();
              }

              return Container(
                margin: EdgeInsets.only(top: 16 * SizeConfig.heightScale),
                height: 110 * SizeConfig.heightScale,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: coupons.length,
                  itemBuilder: (context, index) {
                    final coupon = coupons[index];
                    final isSelected =
                        CartProvider.selectedCouponId == coupon.id;

                    return Container(
                      width: 230 * SizeConfig.widthScale,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? Color(0xFFFFEEEE) : Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isSelected ? Colors.red : Colors.grey.shade300,
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Discount',
                                style: AppTextStyles.blackSubHeadingStyle()
                                    .copyWith(
                                      fontSize: 16 * SizeConfig.widthScale,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                              Text(
                                '${coupon.discountValue ?? '0'}% OFF',
                                style: AppTextStyles.greySubHeadingStyle()
                                    .copyWith(
                                      fontSize: 14 * SizeConfig.widthScale,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                              Text(
                                'Valid till ${coupon.expiryDate}',
                                style: AppTextStyles.greySubHeadingStyle()
                                    .copyWith(
                                      fontSize: 12 * SizeConfig.widthScale,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                              Text(
                                coupon.code ?? '',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Spacer(),
                          if (!isSelected)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: () {
                                    CartProvider.selectedCouponId = coupon.id;
                                    cartProvider.fetchCart();
                                  },
                                  child: Text(
                                    "Apply",
                                    style: AppTextStyles.whiteButtonStyle()
                                        .copyWith(
                                          fontSize: 12 * SizeConfig.widthScale,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AdditionalNotesCard extends StatelessWidget {
  const AdditionalNotesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      title: "Additional Notes",
      child: InputWidget(
        controller: TextEditingController(),
        hint: 'Add Notes for Order/Delivery',
        maxLines: 2,
      ),
    );
  }
}
