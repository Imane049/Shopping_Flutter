import 'package:flutter/material.dart';
import '../components/navigationBar.dart';

class ClothingDetailPage extends StatelessWidget {
  const ClothingDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panier"),
      ),
      body: const Center(
        child: Text(
          "Clothing detail Page",
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
