import 'package:customer_app/providers/search_provider.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:customer_app/widgets/cards/product_card.dart';
import 'package:customer_app/widgets/headers/common_appbar.dart';
import 'package:customer_app/widgets/inputs/input_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

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
                _refreshProducts(value); // Trigger product refresh
              },
            ),
            SizedBox(height: 20.0 * SizeConfig.heightScale),
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
                      crossAxisSpacing: 10.0 * SizeConfig.widthScale,
                      mainAxisSpacing: 10.0 * SizeConfig.heightScale,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: provider.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = provider.filteredProducts[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: ProductCardWidget(
                          data: product,
                          imageURL: provider.imagePath ?? '',
                        ),
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
