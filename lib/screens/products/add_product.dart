import 'dart:io';

import 'package:provider/provider.dart';
import 'package:vendor_app/config/text_styles.dart';
import 'package:vendor_app/models/attribute_model.dart';
import 'package:vendor_app/models/product.dart';
import 'package:vendor_app/providers/attribute_provider.dart';
import 'package:vendor_app/providers/product_provider.dart';
import 'package:vendor_app/providers/store_category.dart';
import 'package:vendor_app/utils/size_config.dart';
import 'package:vendor_app/widgets/buttons/submit_button.dart';
import 'package:vendor_app/widgets/headers/common_appbar.dart';
import 'package:vendor_app/widgets/inputs/dropdown.dart';
import 'package:vendor_app/widgets/inputs/input_widgets.dart';
import 'package:vendor_app/widgets/popup_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  List<File> _images = [];
  File? _image;

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _shortDescriptionController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _productNameArabicController =
      TextEditingController();
  final TextEditingController _shortDescriptionArabicController =
      TextEditingController();
  final TextEditingController _descriptionArabicController =
      TextEditingController();
  final TextEditingController _productNameHebrewController =
      TextEditingController();
  final TextEditingController _shortDescriptionHebrewController =
      TextEditingController();
  final TextEditingController _descriptionHebrewController =
      TextEditingController();
  final TextEditingController _metaTitleController = TextEditingController();
  final TextEditingController _metaDescriptionController =
      TextEditingController();
  final TextEditingController _metaKeywordsController = TextEditingController();
  final TextEditingController _metaTitleArabicController =
      TextEditingController();
  final TextEditingController _metaDescriptionArabicController =
      TextEditingController();
  final TextEditingController _metaKeywordsArabicController =
      TextEditingController();
  final TextEditingController _metaTitleHebrewController =
      TextEditingController();
  final TextEditingController _metaDescriptionHebrewController =
      TextEditingController();
  final TextEditingController _metaKeywordsHebrewController =
      TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  int? _selectedCategoryId;
  int? selectedAttributeId;

  String isPinned = "Yes";
  String isFeatured = "Yes";

  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();

    setState(() {
      _images = pickedFiles.map((file) => File(file.path)).toList();
    });
  }

  Future<void> _pickImage() async {
    final pickedFiles = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFiles == null) return;

    setState(() {
      _image = File(pickedFiles.path);
    });
  }

  void _addProduct() async {
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    Product newProduct = Product(
      categoryId: _selectedCategoryId,

      productName: _productNameController.text,
      productNameArabic: _productNameArabicController.text,
      productNameHebrew: _productNameHebrewController.text,
      vendorPrice: double.tryParse(_priceController.text),
      shortDescription: _shortDescriptionController.text,
      shortDescriptionArabic: _shortDescriptionArabicController.text,
      shortDescriptionHebrew: _shortDescriptionHebrewController.text,
      description: _descriptionController.text,
      descriptionArabic: _descriptionArabicController.text,
      descriptionHebrew: _descriptionHebrewController.text,
      metaTitle: _metaTitleController.text,
      metaTitleArabic: _metaTitleArabicController.text,
      metaTitleHebrew: _metaTitleHebrewController.text,
      metaKeywords: _metaKeywordsController.text,
      metaKeywordsArabic: _metaKeywordsArabicController.text,
      metaKeywordsHebrew: _metaKeywordsHebrewController.text,
      metaDescription: _metaDescriptionController.text,
      metaDescriptionArabic: _metaDescriptionArabicController.text,
      metaDescriptionHebrew: _metaDescriptionHebrewController.text,
      isPinned: isPinned,
      isFeatured: isFeatured,
    );
    bool isSuccess = await productProvider.addProduct(
      newProduct,
      _images,
      _image,
      selectedAttributeId,
    );
    if (isSuccess) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Product Added!!")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to Add the Product!")));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StoreCategoryProvider>(
        context,
        listen: false,
      ).fetchStoreCategories();
      Provider.of<AttributeProvider>(
        context,
        listen: false,
      ).fetchAttributeTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final attributeProvider = Provider.of<AttributeProvider>(context);
    final List<AttributeType> attributeTypes = attributeProvider.attributeTypes;
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
              Column(
                children: [
                  Column(
                    children: [
                      Text(
                        "Product Image",
                        style: AppTextStyles.blackHeadingStyle().copyWith(
                          fontSize: 16 * SizeConfig.widthScale,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _pickImage,
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
                                image: DecorationImage(
                                  image:
                                      _image != null
                                          ? FileImage(_image!)
                                          : const AssetImage(
                                            'assets/images/placeholder.png',
                                          ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: const Icon(
                                Icons.add_rounded,
                                color: Color.fromRGBO(112, 112, 112, 1),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20 * SizeConfig.heightScale),
                  Column(
                    children: [
                      Text(
                        "Product Images",
                        style: AppTextStyles.blackHeadingStyle().copyWith(
                          fontSize: 16 * SizeConfig.widthScale,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 10 * SizeConfig.heightScale),

                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: 1,
                            ),
                        itemCount: _images.length + 1, // Extra for add button
                        itemBuilder: (context, index) {
                          if (index == _images.length) {
                            return GestureDetector(
                              onTap: _pickImages,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey[300],
                                ),
                                child: const Icon(
                                  Icons.add_rounded,
                                  color: Color.fromRGBO(112, 112, 112, 1),
                                  size: 30,
                                ),
                              ),
                            );
                          } else {
                            return Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: FileImage(_images[index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _images.removeAt(index);
                                      });
                                    },
                                    child: const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.black54,
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                label: 'Product Name',
                hint: 'Enter product name...',
                controller: _productNameController,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              Consumer<StoreCategoryProvider>(
                builder: (context, categoryProvider, _) {
                  final categories = categoryProvider.categories ?? [];

                  return CustomDropdown(
                    label: 'Store Category',
                    items: categories.map((c) => c.name ?? '').toList(),
                    selectedItem:
                        _selectedCategoryId == null
                            ? null
                            : categories
                                .firstWhere((c) => c.id == _selectedCategoryId)
                                .name,
                    onChanged: (selectedName) {
                      final selected = categories.firstWhere(
                        (c) => c.name == selectedName,
                      );
                      setState(() {
                        _selectedCategoryId = selected.id;
                      });
                    },
                  );
                },
              ),

              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                label: 'Product Price',
                hint: 'Enter product code...',
                controller: _priceController,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                label: 'Short Description',
                hint: 'Enter short description...',
                maxLines: 2,
                controller: _shortDescriptionController,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                label: 'Description',
                hint: 'Enter description...',
                maxLines: 3,
                controller: _descriptionController,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                label: 'Product Name Arabic',
                hint: 'Enter product name...',

                controller: _productNameArabicController,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                label: 'Short Description Arabic',
                hint: 'Enter short description...',
                maxLines: 2,
                controller: _shortDescriptionArabicController,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                label: 'Description Arabic',
                hint: 'Enter description...',
                maxLines: 3,
                controller: _descriptionArabicController,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                label: 'Product Name Hebrew',
                hint: 'Enter product name...',
                controller: _productNameHebrewController,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                label: 'Short Description Hebrew',
                hint: 'Enter short description...',
                maxLines: 2,
                controller: _shortDescriptionHebrewController,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                label: 'Description Hebrew',
                hint: 'Enter description...',
                maxLines: 3,
                controller: _descriptionHebrewController,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                label: 'Meta Title',
                hint: 'Enter meta title...',
                controller: _metaTitleController,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                label: 'Meta Description',
                hint: 'Enter meta description...',
                maxLines: 3,
                controller: _metaDescriptionController,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                label: 'Meta Keywords',
                hint: 'Enter meta keywords...',
                maxLines: 3,
                controller: _metaKeywordsController,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                label: 'Meta Title Arabic',
                hint: 'Enter meta title...',
                controller: _metaTitleArabicController,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                label: 'Meta Description Arabic',
                hint: 'Enter meta description...',
                maxLines: 3,
                controller: _metaDescriptionArabicController,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                label: 'Meta Keywords Arabic',
                hint: 'Enter meta keywords...',
                maxLines: 3,
                controller: _metaKeywordsArabicController,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                label: 'Meta Title Hebrew',
                hint: 'Enter meta title...',
                controller: _metaTitleHebrewController,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                label: 'Meta Description Hebrew',
                hint: 'Enter meta description...',
                maxLines: 3,
                controller: _metaDescriptionHebrewController,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              InputWidget(
                label: 'Meta Keywords Hebrew',
                hint: 'Enter meta keywords...',
                maxLines: 3,
                controller: _metaKeywordsHebrewController,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              CustomDropdown(
                items: attributeTypes.map((attr) => attr.name).toList(),
                onChanged: (value) {
                  // Find the selected attribute by name
                  final selected = attributeTypes.firstWhere(
                    (attr) => attr.name == value,
                  );
                  selectedAttributeId = selected.id;

                  // You can store selectedAttributeId in a variable or call a method
                  print("Selected ID: $selectedAttributeId");
                },
                label: 'Select Attribute Type',
                isRequired: true,
              ),
              SizedBox(height: 20 * SizeConfig.heightScale),
              Container(
                width: double.infinity,
                child: Text(
                  "Is this product pinned?",
                  style: AppTextStyles.blackHeadingStyle().copyWith(
                    fontSize: 16 * SizeConfig.widthScale,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildRadioButton('Yes', 'yes', isPinned, (value) {
                    setState(() {
                      isPinned = value;
                    });
                  }),
                  SizedBox(width: 20 * SizeConfig.widthScale),
                  _buildRadioButton('No', 'no', isPinned, (value) {
                    setState(() {
                      isPinned = value;
                    });
                  }),
                ],
              ),

              SizedBox(height: 10 * SizeConfig.heightScale),
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
    String? selectedOption,
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
                selectedOption == value
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
