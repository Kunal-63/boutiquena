import 'package:customer_app/models/top_category.dart';
import 'package:customer_app/providers/category_products_provider.dart';
import 'package:customer_app/providers/suggested_product_provider.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:customer_app/widgets/cards/product_card.dart';
import 'package:customer_app/widgets/headers/common_appbar.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryProductsGrid extends StatefulWidget {
  final TopCategory category;
  CategoryProductsGrid({Key? key, required this.category}) : super(key: key);

  @override
  _CategoryProdyuctsGridState createState() => _CategoryProdyuctsGridState();
}

class _CategoryProdyuctsGridState extends State<CategoryProductsGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProductsProvider>(
        context,
        listen: false,
      ).fetchCateogryProducts(widget.category.id ?? 1);
    });
  }

  void _onScroll() {
    final provider = Provider.of<CategoryProductsProvider>(
      context,
      listen: false,
    );
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      provider.loadMore(widget.category.id ?? 1);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: CommonAppBar(
          title: widget.category.categoryName ?? '',
          menuPressed: () {},
          menuItems: [],
        ),
      ),
      body: Consumer<CategoryProductsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.categoryProducts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  childAspectRatio: 0.53,
                ),
                itemCount: provider.categoryProducts.length,
                itemBuilder: (context, index) {
                  final product = provider.categoryProducts[index];
                  return SizedBox(
                    height: 350 * SizeConfig.heightScale,
                    child: ProductCardWidget(
                      data: product,
                      imageURL: provider.productBaseImageUrl,
                    ),
                  );
                },
              ),

              if (provider.isFetchingMore)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 16,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
