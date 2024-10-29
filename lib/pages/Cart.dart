import 'package:flutter/material.dart';
import '../components/navigationBar.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panier"),
      ),
      body: const Center(
        child: Text(
          "Cart Page",
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1, // Set to 1 for Cart tab
        onTap: (index) {
          // Optional: Handle other logic if needed
        },
      ),
    );
  }
}
