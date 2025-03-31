import 'dart:io';

import 'package:provider/provider.dart';
import 'package:vendor_app/config/text_styles.dart';
import 'package:vendor_app/models/product.dart';
import 'package:vendor_app/providers/product_provider.dart';
import 'package:vendor_app/utils/size_config.dart';
import 'package:vendor_app/widgets/buttons/submit_button.dart';
import 'package:vendor_app/widgets/headers/common_appbar.dart';
import 'package:vendor_app/widgets/inputs/dropdown.dart';
import 'package:vendor_app/widgets/inputs/input_widgets.dart';
import 'package:vendor_app/widgets/popup_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  List<File> _images = [];
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productCodeController = TextEditingController();
  final TextEditingController _availableStockController =
      TextEditingController();
  final TextEditingController _maxOrderQuantityController =
      TextEditingController();
  final TextEditingController _sizesController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _expireDateController = TextEditingController();
  final TextEditingController _specialDiscountController =
      TextEditingController();
  final TextEditingController _specialDiscountExpireController =
      TextEditingController();
  final TextEditingController _returnPolicyController = TextEditingController();

  /// Separate state variables for radio buttons
  String? _selectedReturnOption; // Yes or No for Return Policy
  String? _selectedExchangeOption; // Yes or No for Exchange Policy

  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();

    setState(() {
      _images = pickedFiles.map((file) => File(file.path)).toList();
    });
  }

  void _addProduct() async {
    if (_productCodeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Product Code cannot be empty!")));
      return;
    }

    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    Product newProduct = Product(
      // productName: _productNameController.text,
      productCode: _productCodeController.text,
      // stock: _availableStockController.text,
      // : _maxOrderQuantityController.text,
      // screenSize: _sizesController.text,
      // productPrice: _priceController.text,
      // productDiscount: _discountController.text,
      // : _expireDateController.text,
      // : _specialDiscountController.text,
      // specialDiscountExpire: _specialDiscountExpireController.text,
      // returnPolicy:
      //     _selectedReturnOption == "yes" ? _returnPolicyController.text : null,
      // exchangePolicy: _selectedExchangeOption,
      // images: _images,
    );
    bool isSuccess = await productProvider.addProduct(newProduct);
    if (isSuccess) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Product Added!!")));
      Navigator.pushNamed(context, '/product_list');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to Add the Product!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: CommonAppBar(
          title: "Add Product",
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
      body: Padding(
        padding: EdgeInsets.all(30.0 * SizeConfig.widthScale),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Product Images",
                style: AppTextStyles.blackHeadingStyle().copyWith(
                  fontSize: 16 * SizeConfig.widthScale,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImages,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: -6.84 * 3.141592653589793 / 180,
                      child: Container(
                        width: 119 * SizeConfig.widthScale,
                        height: 98 * SizeConfig.heightScale,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(128, 128, 128, 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    Container(
                      width: 119 * SizeConfig.widthScale,
                      height: 98 * SizeConfig.heightScale,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(218, 218, 218, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                          _images.isEmpty
                              ? const Icon(
                                Icons.add_rounded,
                                color: Color.fromRGBO(112, 112, 112, 1),
                                size: 20,
                              )
                              : GridView.builder(
                                padding: const EdgeInsets.all(8),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5,
                                    ),
                                itemCount: _images.length,
                                itemBuilder:
                                    (context, index) => Image.file(
                                      _images[index],
                                      fit: BoxFit.cover,
                                    ),
                              ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                label: 'Product Name',
                hint: 'Enter product name...',
                controller: _productNameController,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                label: 'Product Code',
                hint: 'Enter product code...',
                controller: _productCodeController,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              CustomDropdown(
                label: 'Product Type',
                items: const [
                  'Product Type 1',
                  'Product Type 2',
                  'Product Type 3',
                ],
                onChanged: (dynamic value) {},
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                label: 'Available Stock Quantity',
                hint: '1000 Peace',
                controller: _availableStockController,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                label: 'Maximum Order Quantity ',
                hint: '1000 Peace',
                controller: _maxOrderQuantityController,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              Row(
                children: [
                  Expanded(
                    child: InputWidget(
                      label: 'Sizes',
                      hint: 'L,M,XL',
                      controller: _sizesController,
                    ),
                  ),
                  SizedBox(width: 20 * SizeConfig.widthScale),
                  Expanded(
                    child: InputWidget(
                      label: 'Price',
                      hint: '12',
                      controller: _priceController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              CustomDropdown(
                label: 'Colour Variations',
                items: const ['Red', 'Blue', 'Green'],
                onChanged: (dynamic value) {},
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              Row(
                children: [
                  Expanded(
                    child: InputWidget(
                      label: 'Discount',
                      hint: '10 %',
                      controller: _discountController,
                    ),
                  ),
                  SizedBox(width: 20 * SizeConfig.widthScale),
                  Expanded(
                    child: InputWidget(
                      label: 'Expire Date',
                      hint: '12-02-2025',
                      controller: _expireDateController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              Container(
                padding: EdgeInsets.all(15 * SizeConfig.widthScale),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Give Special Discount?',
                      style: AppTextStyles.redw400Outfit().copyWith(
                        fontSize: 14 * SizeConfig.widthScale,
                      ),
                    ),
                    SizedBox(height: 5 * SizeConfig.heightScale),
                    const Divider(
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                      thickness: 0.5,
                    ),
                    SizedBox(height: 5 * SizeConfig.heightScale),
                    InputWidget(
                      label: 'Buy / Get',
                      hint: 'Buy 2 Get 1 Free',
                      controller: _specialDiscountController,
                    ),
                    SizedBox(height: 20 * SizeConfig.heightScale),
                    Row(
                      children: [
                        Expanded(
                          child: InputWidget(
                            label: 'Discount',
                            hint: '10 %',
                            controller: _specialDiscountExpireController,
                          ),
                        ),
                        // SizedBox(width: 20 * SizeConfig.widthScale),
                        // Expanded(
                        //   child: InputWidget(
                        //     label: 'Expire Date',
                        //     hint: '12-02-2025',
                        //     controller: _productNameController,
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Return Policy',
                  style: AppTextStyles.inputLabelStyle(),
                ),
              ),
              SizedBox(height: 5 * SizeConfig.heightScale),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildRadioButton("Yes", "yes", _selectedReturnOption, (
                        value,
                      ) {
                        _selectedReturnOption = value;
                      }),
                      const SizedBox(width: 20),
                      _buildRadioButton("No", "no", _selectedReturnOption, (
                        value,
                      ) {
                        _selectedReturnOption = value;
                      }),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5 * SizeConfig.heightScale),
              if (_selectedReturnOption == "yes")
                InputWidget(
                  hint: 'Write your return policy here....',
                  controller: _returnPolicyController,
                  maxLines: 1,
                ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              const Divider(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                thickness: 0.5,
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Exchange Policy',
                  style: AppTextStyles.inputLabelStyle(),
                ),
              ),
              SizedBox(height: 5 * SizeConfig.heightScale),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildRadioButton("Yes", "yes", _selectedExchangeOption, (
                        value,
                      ) {
                        _selectedExchangeOption = value;
                      }),
                      const SizedBox(width: 20),
                      _buildRadioButton("No", "no", _selectedExchangeOption, (
                        value,
                      ) {
                        _selectedExchangeOption = value;
                      }),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5 * SizeConfig.heightScale),
              if (_selectedExchangeOption == "yes")
                CustomDropdown(
                  items: const ['7 Days'],
                  onChanged: (dynamic value) {},
                ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/product_details');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/open-eye-icon.svg',
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Preview your product',
                      style: AppTextStyles.blackSubHeadingStyle().copyWith(
                        fontSize: 16 * SizeConfig.widthScale,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              Row(
                children: [
                  Expanded(
                    child: SubmitButton(
                      text: 'Save as draft',
                      onPressed: () {},
                      isTransparent: true,
                    ),
                  ),
                  SizedBox(width: 10 * SizeConfig.widthScale),
                  Expanded(
                    child: SubmitButton(
                      text: 'Publish',
                      onPressed: _addProduct,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'New products must be approved by the admin before being published. You will get approval within ',
                      style: AppTextStyles.blackSubHeadingStyle().copyWith(
                        fontSize: 12 * SizeConfig.widthScale,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    TextSpan(
                      text: '24 hours.',
                      style: AppTextStyles.blackSubHeadingStyle().copyWith(
                        fontSize: 12 * SizeConfig.widthScale,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioButton(
    String label,
    String value,
    String? _selectedOption,
    Function(String) onChanged,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          onChanged(value);
        });
      },
      child: Row(
        children: [
          Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color.fromRGBO(243, 120, 102, 1),
                width: 1,
              ),
            ),
            child:
                _selectedOption == value
                    ? const Center(
                      child: Icon(
                        Icons.circle,
                        size: 12,
                        color: Color.fromRGBO(243, 120, 102, 1),
                      ),
                    )
                    : null,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: AppTextStyles.greySubHeadingStyle().copyWith(
              fontSize: 14 * SizeConfig.widthScale,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
