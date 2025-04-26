import 'package:customer_app/models/product.dart';
import 'package:customer_app/providers/best_seller_provider.dart';
import 'package:customer_app/providers/suggested_product_provider.dart';
import 'package:customer_app/widgets/cards/product_card.dart';
import 'package:customer_app/widgets/headers/common_appbar.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BestSellerProductsGrid extends StatefulWidget {
  const BestSellerProductsGrid({Key? key}) : super(key: key);

  @override
  _BestSellerProductsGridState createState() => _BestSellerProductsGridState();
}

class _BestSellerProductsGridState extends State<BestSellerProductsGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BestSellerProductsProvider>(
        context,
        listen: false,
      ).fetchBestSellerProducts();
    });
  }

  void _onScroll() {
    final provider = Provider.of<BestSellerProductsProvider>(
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
          title: "Best Seller Products",
          menuPressed: () {},
          menuItems: [],
        ),
      ),
      body: Consumer<BestSellerProductsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.bestSellerProducts.isEmpty) {
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
                itemCount: provider.bestSellerProducts.length,
                itemBuilder: (context, index) {
                  final product = provider.bestSellerProducts[index];
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
