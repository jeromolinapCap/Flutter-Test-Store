import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'cart.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItems = Cart().items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => context.go('/cart'),
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                return ListTile(
                  leading: Image.network(
                    product.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.title),
                  subtitle: Text('\$${product.price}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_shopping_cart),
                    onPressed: () {
                      Cart().remove(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Removed from cart')),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
