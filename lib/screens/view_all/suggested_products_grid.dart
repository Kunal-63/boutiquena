import 'package:customer_app/models/product.dart';
import 'package:customer_app/providers/suggested_product_provider.dart';
import 'package:customer_app/widgets/cards/product_card.dart';
import 'package:customer_app/widgets/headers/common_appbar.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SuggestedProductsGrid extends StatefulWidget {
  const SuggestedProductsGrid({Key? key}) : super(key: key);

  @override
  _SuggestedProductsGridState createState() => _SuggestedProductsGridState();
}

class _SuggestedProductsGridState extends State<SuggestedProductsGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SuggestedProductsProvider>(
        context,
        listen: false,
      ).fetchSuggestedProducts();
    });
  }

  void _onScroll() {
    final provider = Provider.of<SuggestedProductsProvider>(
      context,
      listen: false,
    );
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      provider.loadMore();
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
          title: "Suggested Products",
          menuPressed: () {},
          menuItems: [],
        ),
      ),
      body: Consumer<SuggestedProductsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.suggestedProducts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: provider.suggestedProducts.length,
                itemBuilder: (context, index) {
                  final product = provider.suggestedProducts[index];
                  return ProductCardWidget(
                    data: product,
                    imageURL: provider.productBaseImageUrl,
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
