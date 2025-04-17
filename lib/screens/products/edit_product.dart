import 'dart:io';

import 'package:provider/provider.dart';
import 'package:vendor_app/config/text_styles.dart';
import 'package:vendor_app/models/product.dart';
import 'package:vendor_app/models/product_details.dart';
import 'package:vendor_app/models/store_category.dart';
import 'package:vendor_app/providers/product_provider.dart';
import 'package:vendor_app/providers/store_category.dart';
import 'package:vendor_app/utils/custom_network_image.dart';
import 'package:vendor_app/utils/size_config.dart';
import 'package:vendor_app/widgets/buttons/submit_button.dart';
import 'package:vendor_app/widgets/headers/common_appbar.dart';
import 'package:vendor_app/widgets/inputs/dropdown.dart';
import 'package:vendor_app/widgets/inputs/input_widgets.dart';
import 'package:vendor_app/widgets/popup_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProductScreen extends StatefulWidget {
  final int? productID;

  const EditProductScreen({this.productID, super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  List<File> _images = [];
  File? image;
  List<int> remainingImageIds = [];

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

  ProductDetail? _productDetail;

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

    setState(() {
      image = File(pickedFiles!.path);
    });
  }

  Future<void> _loadProductDetail(int id) async {
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    await productProvider.fetchProductDetailById(id);

    setState(() {
      _productDetail = productProvider.selectedProductDetail;
    });

    if (_productDetail != null) {
      final p = _productDetail!;

      _productNameController.text = p.productName ?? '';
      _productNameArabicController.text = p.productNameArabic ?? '';
      _productNameHebrewController.text = p.productNameHebrew ?? '';
      _priceController.text = p.vendorPrice?.toString() ?? '';

      _shortDescriptionController.text = p.shortDescription ?? '';
      _shortDescriptionArabicController.text = p.shortDescriptionArabic ?? '';
      _shortDescriptionHebrewController.text = p.shortDescriptionHebrew ?? '';

      _descriptionController.text = p.description ?? '';
      _descriptionArabicController.text = p.descriptionArabic ?? '';
      _descriptionHebrewController.text = p.descriptionHebrew ?? '';

      _metaTitleController.text = p.metaTitle ?? '';
      _metaTitleArabicController.text = p.metaTitleArabic ?? '';
      _metaTitleHebrewController.text = p.metaTitleHebrew ?? '';

      _metaDescriptionController.text = p.metaDescription ?? '';
      _metaDescriptionArabicController.text = p.metaDescriptionArabic ?? '';
      _metaDescriptionHebrewController.text = p.metaDescriptionHebrew ?? '';

      _metaKeywordsController.text = p.metaKeywords ?? '';
      _metaKeywordsArabicController.text = p.metaKeywordsArabic ?? '';
      _metaKeywordsHebrewController.text = p.metaKeywordsHebrew ?? '';

      _selectedCategoryId = p.categoryId;
      isPinned = p.isPinned ?? "Yes";
      isFeatured = p.isFeatured ?? "Yes";
      remainingImageIds = p.images?.map((img) => img.id!).toList() ?? [];
    }
  }

  Future<void> _updateProduct() async {
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );

    ProductDetail updatedProduct = ProductDetail(
      categoryId: _selectedCategoryId,
      id: widget.productID,
      vendorPrice: _priceController.text,
      productName: _productNameController.text,
      productNameArabic: _productNameArabicController.text,
      productNameHebrew: _productNameHebrewController.text,
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

    bool isSuccess = await productProvider.updateProduct(
      updatedProduct,
      _images,
      image,
      remainingImageIds,
    );

    if (isSuccess) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Product Updated!")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update the product!")),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    super.initState();

    if (widget.productID != null) {
      _loadProductDetail(widget.productID!);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StoreCategoryProvider>(
        context,
        listen: false,
      ).fetchStoreCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: CommonAppBar(
          title: "Edit Product",
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
                  Text(
                    "Product Image",
                    style: AppTextStyles.blackHeadingStyle().copyWith(
                      fontSize: 16 * SizeConfig.widthScale,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 5),
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
                        // Show Image or Empty Widget if no image
                        image != null
                            ? Container(
                              width: 119 * SizeConfig.widthScale,
                              height: 98 * SizeConfig.heightScale,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(218, 218, 218, 1),
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: FileImage(image!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          image = null; // Reset the image
                                        });
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : _productDetail?.productImage != null
                            ? Container(
                              width: 119 * SizeConfig.widthScale,
                              height: 98 * SizeConfig.heightScale,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(218, 218, 218, 1),
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    _productDetail!.imageUrl != null &&
                                            _productDetail!.productImage != null
                                        ? '${_productDetail!.imageUrl!}/${_productDetail!.productImage ?? ''}'
                                        : '',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          image = null; // Reset the image
                                        });
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : Container(
                              width: 119 * SizeConfig.widthScale,
                              height: 98 * SizeConfig.heightScale,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(218, 218, 218, 1),
                                borderRadius: BorderRadius.circular(10),
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

              // Multiple Product Images Column
              Column(
                children: [
                  Text(
                    "Product Images",
                    style: AppTextStyles.blackHeadingStyle().copyWith(
                      fontSize: 16 * SizeConfig.widthScale,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: _pickImages,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GridView.builder(
                          shrinkWrap:
                              true, // To make sure it doesn’t take up more space than needed
                          physics:
                              const NeverScrollableScrollPhysics(), // Disable scrolling within the grid
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                              ),
                          itemCount:
                              (_images.length +
                                  (_productDetail?.images?.length ?? 0)) +
                              1, // Add 1 for the "Add Image" button
                          itemBuilder: (context, index) {
                            if (index ==
                                (_images.length +
                                    (_productDetail?.images?.length ?? 0))) {
                              // Display the "Add Image" button at the last position
                              return GestureDetector(
                                onTap: _pickImages, // Function to pick images
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
                              // Display the image container
                              bool isLocalImage = index < _images.length;
                              int networkImageIndex = index - _images.length;

                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image:
                                        isLocalImage
                                            ? FileImage(_images[index])
                                                as ImageProvider
                                            : NetworkImage(
                                              _productDetail!.imagesLargeUrl !=
                                                          null &&
                                                      _productDetail!
                                                              .images![networkImageIndex]
                                                              .image !=
                                                          null
                                                  ? '${_productDetail!.imagesLargeUrl!}/${_productDetail!.images![networkImageIndex].image ?? ''}'
                                                  : '',
                                            ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (isLocalImage) {
                                              _images.removeAt(index);
                                            } else {
                                              if (_productDetail
                                                      ?.images?[networkImageIndex]
                                                      .id !=
                                                  null) {
                                                remainingImageIds.remove(
                                                  _productDetail
                                                      ?.images?[networkImageIndex]
                                                      .id,
                                                );
                                                _productDetail!.images!
                                                    .removeAt(
                                                      networkImageIndex,
                                                    );
                                              }
                                            }
                                          });
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
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
                  if (categoryProvider.isLoading) {
                    return CircularProgressIndicator();
                  }
                  final categories = categoryProvider.categories ?? [];
                  if (categories.isEmpty) {
                    return Container();
                  }
                  String? selectedCategoryName;
                  if (_selectedCategoryId != null) {
                    final selectedCategory = categories.firstWhere(
                      (c) => c.id == _selectedCategoryId,
                      orElse:
                          () =>
                              categories.isNotEmpty
                                  ? categories.first
                                  : StoreCategory(id: 0, name: "None"),
                    );
                    selectedCategoryName = selectedCategory.name;
                  }
                  return CustomDropdown(
                    label: 'Store Category',
                    items: categories.map((c) => c.name ?? '').toList(),
                    selectedItem: selectedCategoryName,
                    onChanged: (selectedName) {
                      final selectedCategory = categories.firstWhere(
                        (c) => c.name == selectedName,
                      );
                      setState(() {
                        _selectedCategoryId = selectedCategory.id;
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
              Text(
                "Is this product pinned?",
                style: AppTextStyles.blackHeadingStyle().copyWith(
                  fontSize: 16 * SizeConfig.widthScale,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              _buildRadioButton('Yes', 'yes', isPinned, (value) {
                setState(() {
                  isPinned = value;
                });
              }),
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
                      text: 'Update',
                      onPressed: _updateProduct,
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
