import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../handlers/UserProvider.dart';

class ClothingDetailPage extends StatefulWidget {
  final Map<String, dynamic> clothingItem;

  ClothingDetailPage({required this.clothingItem});

  @override
  _ClothingDetailPageState createState() => _ClothingDetailPageState();
}

class _ClothingDetailPageState extends State<ClothingDetailPage> {
  final Color pinkColor = Color.fromARGB(255, 246, 144, 178);

  @override
  Widget build(BuildContext context) {
    final clothingItem = widget.clothingItem;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: pinkColor,
        title: Text('Product Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(clothingItem['imagePath']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Product Title
            Text(
              clothingItem['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // Product Brand and Category
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  clothingItem['brand'],
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  'Category: ${clothingItem['category'] ?? 'Unknown'}',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Product Price
            Text(
              '${clothingItem['price'].toString()} MAD',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: pinkColor),
            ),
            SizedBox(height: 16),

            // Size Selector
            Text(
              'Size',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: ['S', 'M', 'L', 'XL']
                  .map((size) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ChoiceChip(
                          label: Text(size),
                          selected: clothingItem['size'] == size,
                        ),
                      ))
                  .toList(),
            ),
            SizedBox(height: 16),

            // Add to Cart Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  _addToCart(clothingItem['id']);
                },
                icon: Icon(Icons.shopping_cart),
                label: Text('Add to Cart'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: pinkColor,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Method to add item to cart in Firestore and update UserProvider
Future<void> _addToCart(String itemId) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final userId = userProvider.userData?['id']; // Get the ID from userData map

  if (userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: User ID not found")),
    );
    return;
  }

  try {
    // Fetch the user's current cart items from userProvider
    List<dynamic> currentCart = userProvider.userData?['cart'] ?? [];

    // Check if item is already in cart to prevent duplicates
    if (!currentCart.contains(itemId)) {
      currentCart.add(itemId);

      // Save updated cart to Firestore and UserProvider
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'cart': currentCart,
      });

      // Update UserProvider
      userProvider.saveUserData({'cart': currentCart});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Item added to cart: ${widget.clothingItem['title']}")),
      );

      // Debugging: Log the cart after addition
      print('Cart updated successfully. Current cart items: $currentCart');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Item is already in your cart.")),
      );
    }
  } catch (e) {
    print("Error adding item to cart: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to add item to cart: $e")),
    );
  }
}

}
