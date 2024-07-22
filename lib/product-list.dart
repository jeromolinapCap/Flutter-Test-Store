import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'api_service.dart';
import 'product.dart';
import 'cart.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> with SingleTickerProviderStateMixin {
  late Future<List<Product>> futureProducts;
  late TabController _tabController;
  final List<String> categories = ["All", "electronics", "jewelery", "men's clothing", "women's clothing"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    futureProducts = ApiService.fetchProducts();
  }

  Future<List<Product>> fetchProductsByCategory(String category) async {
    if (category == "All") {
      return ApiService.fetchProducts();
    }
    final products = await ApiService.fetchProducts();
    return products.where((product) => product.category == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: () => context.go('/'),
            child: const Text("Shop"),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => context.go('/cart'),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: categories.map((category) => Tab(text: category)).toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: categories.map((category) {
            return FutureBuilder<List<Product>>(
              future: fetchProductsByCategory(category),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = (constraints.maxWidth / 200).round().clamp(2, 4);

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final product = snapshot.data![index];
                            return GridTile(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: Image.network(
                                        product.image,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      product.title,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "\$${product.price}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          Cart().add(product);
                                        });
                                      },
                                      child: const Text('Add to Cart'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                return const Center(child: CircularProgressIndicator());
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
