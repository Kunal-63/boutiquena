import 'dart:io';

import 'package:vendor_app/config/text_styles.dart';
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
  String? _selectedOption;
  final TextEditingController _productNameController = TextEditingController();

  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();

    setState(() {
      _images = pickedFiles.map((file) => File(file.path)).toList();
    });
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
                controller: _productNameController,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                label: 'Maximum Order Quantity ',
                hint: '1000 Peace',
                controller: _productNameController,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              Row(
                children: [
                  Expanded(
                    child: InputWidget(
                      label: 'Sizes',
                      hint: 'L,M,XL',
                      controller: _productNameController,
                    ),
                  ),
                  SizedBox(width: 20 * SizeConfig.widthScale),
                  Expanded(
                    child: InputWidget(
                      label: 'Price',
                      hint: '12',
                      controller: _productNameController,
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
                      controller: _productNameController,
                    ),
                  ),
                  SizedBox(width: 20 * SizeConfig.widthScale),
                  Expanded(
                    child: InputWidget(
                      label: 'Expire Date',
                      hint: '12-02-2025',
                      controller: _productNameController,
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
                      controller: _productNameController,
                    ),
                    SizedBox(height: 20 * SizeConfig.heightScale),
                    Row(
                      children: [
                        Expanded(
                          child: InputWidget(
                            label: 'Discount',
                            hint: '10 %',
                            controller: _productNameController,
                          ),
                        ),
                        SizedBox(width: 20 * SizeConfig.widthScale),
                        Expanded(
                          child: InputWidget(
                            label: 'Expire Date',
                            hint: '12-02-2025',
                            controller: _productNameController,
                          ),
                        ),
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
                      _buildRadioButton("Yes", "yes"),
                      const SizedBox(width: 20),
                      _buildRadioButton("No", "no"),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5 * SizeConfig.heightScale),
              if (_selectedOption == "yes")
                InputWidget(
                  hint: 'Write your return policy here....',
                  controller: _productNameController,
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
                      _buildRadioButton("Yes", "yes"),
                      const SizedBox(width: 20),
                      _buildRadioButton("No", "no"),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5 * SizeConfig.heightScale),
              if (_selectedOption == "yes")
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
                      onPressed: () {
                        Navigator.pushNamed(context, '/product_list');
                      },
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

  Widget _buildRadioButton(String label, String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = value;
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
