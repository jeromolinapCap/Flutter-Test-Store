import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'cart-page.dart';
import 'product-detail.dart';
import 'product-list.dart';
import 'product.dart';
import 'api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const ProductList(),
        ),
        GoRoute(
          path: '/product/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return FutureBuilder<Product>(
              future: ApiService.fetchProductById(id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ProductDetail(product: snapshot.data!);
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                return const Center(child: CircularProgressIndicator());
              },
            );
          },
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) => const CartPage(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Shop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      routerDelegate: _router.routerDelegate,
      routeInformationParser: _router.routeInformationParser,
    );
  }
}
