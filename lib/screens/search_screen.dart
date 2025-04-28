import 'dart:io';

import 'package:customer_app/config/theme.dart';
import 'package:customer_app/providers/search_provider.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:customer_app/widgets/cards/product_card.dart';
import 'package:customer_app/widgets/headers/common_appbar.dart';
import 'package:customer_app/widgets/inputs/input_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  XFile? _imageFile;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _refreshProducts(String query) {
    if (query.trim().isNotEmpty) {
      context.read<SearchScreenProvider>().fetchSearchedProducts(query.trim());
    }
  }

  // Pick image from camera
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  // Pick image from gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: CommonAppBar(
          title: "Search",
          menuPressed: () {},
          menuItems: const [],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.0 * SizeConfig.widthScale,
          vertical: 10.0 * SizeConfig.heightScale,
        ),
        child: Column(
          children: [
            InputWidget(
              controller: searchController,
              hint: "Search",
              svgPath: 'assets/icons/search-icon.svg',
              onChanged: (value) {
                _refreshProducts(value);
              },
            ),
            SizedBox(height: 10.0 * SizeConfig.heightScale),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _pickImageFromCamera,
                    child: Container(
                      height: 50 * SizeConfig.heightScale,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.primaryColor,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(Icons.camera_alt),
                          SizedBox(width: 8),
                          Text('Camera'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: _pickImageFromGallery,
                    child: Container(
                      // padding: EdgeInsets.all(20 * SizeConfig.widthScale),
                      height: 50 * SizeConfig.heightScale,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.primaryColor,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(Icons.image),
                          SizedBox(width: 8),
                          Text('Gallery'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0 * SizeConfig.heightScale),
            if (_imageFile != null) ...[
              Image.file(File(_imageFile!.path), width: 100, height: 100),
              SizedBox(height: 10),
            ],
            Expanded(
              child: Consumer<SearchScreenProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.filteredProducts.isEmpty) {
                    return const Center(child: Text("No products found"));
                  }

                  return GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0 * SizeConfig.widthScale,
                      mainAxisSpacing: 5.0 * SizeConfig.heightScale,
                      childAspectRatio: 0.5,
                    ),
                    itemCount: provider.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = provider.filteredProducts[index];
                      return ProductCardWidget(
                        data: product,
                        imageURL: provider.imagePath ?? '',
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
